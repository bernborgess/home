## **1. Install the required tools temporarily**

On NixOS:

```
nix-shell -p woeusb dosfstools
```

## **2. Identify the USB drive**

Run:

```
lsblk -o NAME,SIZE,MODEL,TRAN,FSTYPE,MOUNTPOINTS
```

From your earlier output, the USB was `/dev/sda` (SanDisk Cruzer Blade, 7.5 GB), but **verify it again** before proceeding.

Your internal SSD is `/dev/nvme0n1`. Do not select that!

## **3. Write Hiren's ISO to the USB**

Assuming the USB is still `/dev/sda` and the ISO is in `~/Downloads`:

```
sudo woeusb \
  --device ~/Downloads/HBCD_PE_x64.iso \
  /dev/sda \
  --target-filesystem FAT
```

Notice that we're using `FAT`, not `NTFS`.

This will erase the USB and create the bootable media. The ISO is approximately 3.06 GB, so it fits on your 7.5 GB USB.&#x20;

Wait until WoeUSB reports successful completion.

## **4. Safely eject the USB**

```
sync
sudo eject /dev/sda
```
