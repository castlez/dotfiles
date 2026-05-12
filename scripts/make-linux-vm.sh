#!/usr/bin/env bash
# =============================================================================
# create-fedora-vm.sh
# Creates a Fedora 44 KVM virtual machine on Bazzite (or any Fedora/RHEL host)
# Requires: qemu-kvm, libvirt, virt-install (via ujust setup-virtualization)
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# CONFIGURATION -- edit these to taste
# -----------------------------------------------------------------------------
VM_NAME="fedora44-vm"
VM_VCPUS=2
VM_RAM_MB=2048          # RAM in MiB
VM_DISK_GB=20           # Disk size in GB
VM_DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"

ISO_FILENAME="Fedora-Server-netinst-x86_64-44-1.7.iso"
ISO_DIR="/var/lib/libvirt/images"
ISO_PATH="${ISO_DIR}/${ISO_FILENAME}"

# Official Fedora mirror -- redirects to a geographically close mirror
ISO_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/44/Server/x86_64/iso/${ISO_FILENAME}"

# Checksum file URL
CHECKSUM_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/44/Server/x86_64/iso/Fedora-Server-44-1.7-x86_64-CHECKSUM"
CHECKSUM_FILE="${ISO_DIR}/Fedora-Server-44-1.7-x86_64-CHECKSUM"

# -----------------------------------------------------------------------------
# HELPERS
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# -----------------------------------------------------------------------------
# PREFLIGHT CHECKS
# -----------------------------------------------------------------------------
info "Running preflight checks..."

for cmd in virt-install virsh qemu-img curl sha256sum; do
    if ! command -v "$cmd" &>/dev/null; then
        error "'$cmd' not found. Run 'ujust setup-virtualization' first, then reboot."
    fi
done

if ! systemctl is-active --quiet libvirtd; then
    error "libvirtd is not running. Try: sudo systemctl start libvirtd"
fi

if [[ ! -e /dev/kvm ]]; then
    error "/dev/kvm not found. Ensure virtualization is enabled in your BIOS/UEFI."
fi

if ! id -nG "$USER" | grep -qw libvirt; then
    warn "You are not in the 'libvirt' group. You may be prompted for a password."
    warn "To fix permanently: sudo usermod -aG libvirt \$USER  (then re-login)"
fi

if virsh dominfo "$VM_NAME" &>/dev/null; then
    error "A VM named '${VM_NAME}' already exists. Delete it first with:\n  virsh undefine ${VM_NAME} --remove-all-storage"
fi

info "Preflight checks passed."

# -----------------------------------------------------------------------------
# DOWNLOAD ISO (if not already present)
# -----------------------------------------------------------------------------
if [[ -f "$ISO_PATH" ]]; then
    # Make sure the existing file isn't a leftover HTML error page
    if file "$ISO_PATH" 2>/dev/null | grep -q "HTML"; then
        warn "Existing ISO looks like an HTML error page -- deleting and re-downloading."
        sudo rm -f "$ISO_PATH"
    else
        info "ISO already found at ${ISO_PATH}, skipping download."
    fi
fi

if [[ ! -f "$ISO_PATH" ]]; then
    info "Downloading Fedora 44 Server netinstall ISO (~800 MB)..."
    info "Source: ${ISO_URL}"
    sudo curl -L -f --progress-bar -o "$ISO_PATH" "$ISO_URL" \
        || error "Download failed. Check your internet connection or try the URL manually."
    info "Download complete."
fi

# -----------------------------------------------------------------------------
# VERIFY CHECKSUM
# -----------------------------------------------------------------------------
info "Downloading checksum file for verification..."
SKIP_CHECKSUM=0

if ! sudo curl -L -f --silent -o "$CHECKSUM_FILE" "$CHECKSUM_URL"; then
    warn "Could not download checksum file (HTTP error) -- skipping verification."
    SKIP_CHECKSUM=1
elif grep -q "<!DOCTYPE" "$CHECKSUM_FILE" 2>/dev/null; then
    warn "Checksum file looks like an HTML error page -- skipping verification."
    SKIP_CHECKSUM=1
fi

if [[ "$SKIP_CHECKSUM" == "0" ]]; then
    info "Verifying ISO integrity (this will take a minute)..."
    EXPECTED_HASH=$(grep "SHA256 (${ISO_FILENAME})" "$CHECKSUM_FILE" | awk '{print $NF}')
    if [[ -z "$EXPECTED_HASH" ]]; then
        warn "Could not parse hash from checksum file -- skipping verification."
    else
        ACTUAL_HASH=$(sudo sha256sum "$ISO_PATH" | awk '{print $1}')
        if [[ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]]; then
            sudo rm -f "$ISO_PATH"
            error "Checksum mismatch! ISO may be corrupt.\nExpected: ${EXPECTED_HASH}\nActual:   ${ACTUAL_HASH}"
        fi
        info "Checksum verified OK."
    fi
fi

# -----------------------------------------------------------------------------
# CREATE VIRTUAL DISK
# -----------------------------------------------------------------------------
if [[ -f "$VM_DISK_PATH" ]]; then
    warn "Disk image already exists at ${VM_DISK_PATH}. Reusing it."
else
    info "Creating ${VM_DISK_GB}GB qcow2 disk image at ${VM_DISK_PATH}..."
    sudo qemu-img create -f qcow2 "$VM_DISK_PATH" "${VM_DISK_GB}G" \
        || error "Failed to create disk image."
    info "Disk image created."
fi

# -----------------------------------------------------------------------------
# CREATE THE VM
# -----------------------------------------------------------------------------
info "Creating VM '${VM_NAME}'..."
info "  vCPUs : ${VM_VCPUS}"
info "  RAM   : ${VM_RAM_MB} MiB"
info "  Disk  : ${VM_DISK_GB} GB  ->  ${VM_DISK_PATH}"
info "  ISO   : ${ISO_PATH}"
info "A virt-viewer window will open with the Fedora installer."
echo ""

# --cdrom boots the ISO directly.
# --graphics spice opens virt-viewer automatically on your desktop.
sudo virt-install \
    --name="${VM_NAME}" \
    --os-variant=fedora43 \
    --vcpus="${VM_VCPUS}" \
    --memory="${VM_RAM_MB}" \
    --disk "path=${VM_DISK_PATH},format=qcow2,bus=virtio" \
    --cdrom="${ISO_PATH}" \
    --network network=default,model=virtio \
    --graphics spice \
    --wait=-1

# -----------------------------------------------------------------------------
# DONE
# -----------------------------------------------------------------------------
echo ""
info "VM '${VM_NAME}' created successfully!"
echo ""
echo "  Connect to console : virsh console ${VM_NAME}"
echo "  Start the VM       : virsh start ${VM_NAME}"
echo "  Stop the VM        : virsh shutdown ${VM_NAME}"
echo "  Open GUI console   : virt-viewer ${VM_NAME}"
echo "  Delete VM + disk   : virsh undefine ${VM_NAME} --remove-all-storage"
echo ""
info "Tip: After installing, eject the ISO with:"
echo "  virsh change-media ${VM_NAME} --path ${ISO_PATH} --eject"
