# macOS Simple KVM — Step‑by‑Step Setup (KVM/QEMU + virt‑manager) 
> Taken from https://gist.github.com/KitBaroness/60b1a8abab429550f4dddf4e207a2a33

This guide uses the files from `macOS-Simple-KVM` to install macOS on KVM/QEMU. It covers both **console** and **virt‑manager (GUI)** paths, plus fixes for common boot issues.
```bash
git clone https://github.com/KitBaroness/macOS-Simple-KVM
cd macOS-Simple-KVM
```

---

## 0) Prerequisites

* A Linux host with KVM support enabled (Intel VT‑x/VT‑d or AMD‑V/AMD‑Vi).
* Packages (names may vary by distro):

  ```bash
  sudo apt install qemu-system-x86 qemu-utils ovmf virt-manager libvirt-daemon-system libvirt-clients
  ```
* A user in the `libvirt` and `kvm` groups (log out/in after adding):

  ```bash
  sudo usermod -aG libvirt,kvm "$USER"
  ```

---

## 1) Repo layout (what each file does)

Inside `macOS-Simple-KVM/` you will typically see:

* **`jumpstart.sh`** — downloads Apple’s Recovery image (BaseSystem) for a chosen macOS version.
* **`basic.sh`** — launches a ready‑to‑run QEMU config for installation in a window.
* **`headless.sh`** — launches the same config headlessly (useful over SSH).
* **`make.sh`** — helper to generate a libvirt XML if desired.
* **`virtio.sh`** — optional script to add VirtIO devices.
* **`firmware/`** — OVMF firmware references.
* **`ESP.qcow2`** — small EFI system partition disk used by the scripts.
* **`BaseSystem.img`** — Apple Recovery image (created by `jumpstart.sh`).

You will **create** your main VM disk, e.g. `macOS.qcow2`.

---

## 2) Fetch the Apple Recovery image

From the repo folder:

```bash
chmod +x *.sh tools/*.sh 2>/dev/null || true
./jumpstart.sh --list           # shows available versions
./jumpstart.sh --os "Sequoia"   # downloads BaseSystem.img (use latest listed)
```

> If the newest macOS (e.g., Tahoe) is not yet listed, install Sequoia and upgrade in System Settings afterward.

---

## 3) Create the VM disk

```bash
qemu-img create -f qcow2 macOS.qcow2 120G
```

> 64G is an absolute minimum; 120G+ is recommended.

---

## 4A) Console install (with the provided scripts)

1. Run the installer VM:

   ```bash
   ./basic.sh
   ```
2. In macOS Recovery:

   * Open **Disk Utility** → View → **Show All Devices**.
   * Select the QEMU/virtio drive → **Erase** → Format **APFS**, Scheme **GUID**.
   * Quit Disk Utility → **Reinstall macOS** → select the formatted disk.
3. Let it reboot several times until you reach the macOS desktop.
4. Optional snapshots:

   ```bash
   qemu-img snapshot -c post-install macOS.qcow2
   ```
5. Upgrade to the latest macOS (e.g., Tahoe) in **System Settings → General → Software Update**.

---

## 4B) Virt‑manager (GUI) install

1. Open **Virtual Machine Manager** → **New VM** → **Import existing disk image**.
2. **Attach installer**:

   * Add storage **CD‑ROM** → file: `BaseSystem.img` → **Bus: SATA**.
3. **Attach target disk**:

   * Add storage **Disk** → file: `macOS.qcow2` → **Bus: SATA** (or **VirtIO**).
4. **Overview**:

   * **Chipset/Machine**: **Q35**.
   * **Firmware**: **UEFI (OVMF)**.
   * **OS type**: `macOS` or `Generic UEFI x86_64`.
5. **CPU & Memory** (reasonable defaults):

   * **vCPUs**: 4–6
   * **Memory**: 8–12 GB
   * **CPU mode**: **host‑passthrough**; topology 1 socket, N cores, 2 threads.
6. **Boot Options**:

   * Enable **Boot menu**.
   * Put the **SATA CDROM (BaseSystem.img)** above `macOS.qcow2`.
7. Start the VM → follow the same Recovery steps (Disk Utility → APFS/GUID → Install).
8. After installation completes and boots to desktop, **remove** the `BaseSystem.img` device or move it below the disk in Boot Order.

---

## 5) Networking, display, and input

* **Network**: `virtio` or `e1000e` both work. If Recovery doesn’t see the network, use `e1000e` for install, then switch to `virtio` later.
* **Display**: QXL or Virtio‑GPU is fine for installation and desktop use (no 3D acceleration expected).
* **Input**: Add a **USB Tablet** device for smooth pointer tracking.

---

## 6) Post‑install polish

* Take a snapshot:

  ```bash
  qemu-img snapshot -c clean macOS.qcow2
  ```
* Enable shared folders via **samba** or **virtio‑fs** (optional).
* If using libvirt XML, consider `host-passthrough` CPU and `kvm hidden` flags for compatibility.

---

## 7) Upgrading to the newest macOS (when the repo lags)

If the repo doesn’t yet list the newest release (e.g., Tahoe):

1. Install the latest available (e.g., Sequoia) using the steps above.
2. Inside macOS, go to **System Settings → General → Software Update** and upgrade to the newer release.
3. Snapshot after the upgrade:

   ```bash
   qemu-img snapshot -c post-upgrade macOS.qcow2
   ```

---

## 8) Troubleshooting

**Symptom: UEFI Shell appears (no Apple logo).**

* Cause: No bootable device found. The installer image isn’t attached or is on an unsupported bus.
* Fix: Ensure `BaseSystem.img` is added as **CD‑ROM, Bus = SATA**, and first in Boot Order. If in shell, try `Esc` → **Boot Manager**, or manually map with `fs0:` then run `System\Library\CoreServices\boot.efi`.

**Symptom: “unsupported configuration: IDE controllers are unsupported for this QEMU machine type.”**

* Cause: A disk or CD‑ROM is on **IDE** while using **Q35** machine type.
* Fix: Change bus to **SATA** or **VirtIO** for all storage devices.

**No network in Recovery.**

* Use **e1000e** for install, switch to **virtio-net** later.

**Very slow UI.**

* Allocate more vCPUs/RAM; keep display on QXL/Virtio. 3D acceleration is not expected.

**Black screen after install when BaseSystem still attached.**

* Move disk above CD‑ROM in Boot Order or remove the CD‑ROM device.

---

## 9) Optional: register VM in libvirt via XML

If you prefer XML, `make.sh` can emit one, or you can craft a minimal domain with:

* `<os firmware="efi">` using OVMF code/vars
* `<cpu mode="host-passthrough"/>`
* Disk `macOS.qcow2` on `sata` (or `virtio`)
* CD‑ROM `BaseSystem.img` on `sata`
* Network `e1000e` or `virtio`

Define it with:

```bash
virsh define /path/to/macos.xml
```

---

## 10) Resource sizing (quick reference)

* **RAM**: 8–12 GB for smooth use; 4–6 GB minimum for install.
* **vCPUs**: 4–6 typical; 2–4 minimum.

---

### Done

After installation, you should boot straight into macOS from `macOS.qcow2`. Keep `BaseSystem.img` detached for normal boots and take snapshots before major upgrades.
