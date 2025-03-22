#-------------------------------------------------------------------------------
# Copyright © 2025 Péter Kardos
# SPDX-License-Identifier: MIT
#
# This file may contain non-trivial parts from the original `aports` sources at
# https://gitlab.alpinelinux.org/alpine/aports. Please reach out if you have
# issues with this file being licensed under the MIT license.
#-------------------------------------------------------------------------------

#!/bin/sh -e

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$tmp"
}

makefile() {
	OWNER="$1"
	PERMS="$2"
	FILENAME="$3"
	cat > "$FILENAME"
	chown "$OWNER" "$FILENAME"
	chmod "$PERMS" "$FILENAME"
}

rc_add() {
	mkdir -p "$tmp"/etc/runlevels/"$2"
	ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/world <<EOF
alpine-base
agetty
sed-manager-rs
EOF

makefile root:root 0644 "$tmp"/etc/inittab <<EOF
# /etc/inittab

::sysinit:/sbin/openrc sysinit > /dev/null
::sysinit:/sbin/openrc boot > /dev/null
::wait:/sbin/openrc default > /dev/null

# Set up a couple of getty's
#tty1::respawn:/sbin/agetty --autologin root tty1 linux
tty1::respawn:/bin/ash -c "sed-manager-unlock && reboot"
#tty1::respawn:/sbin/sed-manager-unlock
tty2::respawn:/sbin/getty 38400 tty2

# Stuff to do for the 3-finger salute
::ctrlaltdel:/sbin/reboot

# Stuff to do before rebooting
::shutdown:/sbin/openrc shutdown > /dev/null
EOF

rc_add devfs sysinit
rc_add dmesg sysinit
rc_add mdev sysinit
rc_add hwdrivers sysinit
rc_add modloop sysinit

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz
