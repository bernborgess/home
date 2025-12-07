# The 32 Bit Desktop Situation
What are the options for a desktop OS for a 32 bit machine in 2025?

## Debian :no_entry_sign:
Debian 12 (Bookworm) is the last version of debian that will support
the 32 bit architecture i386. In this sense, we can install it from
the [12.12.0 iso](https://get.debian.org/images/archive/12.12.0/i386/iso-cd/)
from the official website, and get support as Debian LTS until 30 Jun 2028.

> [Read more in "Debian preps ground to drop 32-bit x86 as separate edition"](https://www.theregister.com/2023/12/19/debian_to_drop_x86_32/)
> There are also some non-Debian based distros that still offer 32-bit editions, including openSUSE Tumbleweed, Alpine Linux, Mageia, Gentoo, and Void Linux… and we suspect that NetBSD isn't going to drop i386 any time soon either

## openSUSE Tumbleweed :goat:
Find at [tumbleweed](https://get.opensuse.org/tumbleweed/), just pick the
Offline Image or Network Image at **Intel or AMD 32-bit desktops, laptops, and servers (i686)**. It's a rolling release, so better long term support.

## Alpine Linux
Find at [downloads](https://www.alpinelinux.org/downloads/), in the _STANDARD_ pick the
[x86 green button](https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86/alpine-standard-3.23.0-x86.iso)


## Mageia
Get it in [downloads](https://www.mageia.org/en/downloads/), Picking _Classic Installation_, _32 bit_ and _BitTorrent_, the iso is 3GiB.

## Gentoo
Seriously? Well, if you want to compile your own packages with less than 4 gigabytes of ram, it's your time... get it [here](https://www.gentoo.org/downloads/#x86), ships also with [xfce](https://repo-default.voidlinux.org/live/current/void-live-i686-20250202-xfce.iso)

## Void Linux
Gotta learn more about this one. It's available [here](https://voidlinux.org/download/#i686)

## FreeBSD :no_entry_sign:
Stepping outside of the linux world for a change, but the DEs are the same old _KDE Plasma_, _Gnome_, _MATE_, _Cinnamon_ ... The version **FreeBSD 14.3** is the last one with
i386 support, check the [where](https://www.freebsd.org/where/) page for the [installer](https://download.freebsd.org/releases/i386/i386/ISO-IMAGES/14.3/) or the [VM](https://download.freebsd.org/releases/VM-IMAGES/14.3-RELEASE/i386/Latest/), so it offers Security Support until [30 Jun 2026](https://endoflife.date/freebsd)

## NetBSD :goat:
Based on FreeBSD, but [actively supported](https://endoflife.date/netbsd) x86_32 for
version 10. Right from the [home](https://www.netbsd.org/) you can see the [i386](https://wiki.netbsd.org/ports/i386/) option

> Check [robo nuggie for FreeBSD Videos](https://www.youtube.com/@RoboNuggie0)


