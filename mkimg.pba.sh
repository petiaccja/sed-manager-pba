#-------------------------------------------------------------------------------
# Copyright © 2025 Péter Kardos
# SPDX-License-Identifier: MIT
#-------------------------------------------------------------------------------

profile_pba() {
	profile_base
	profile_abbrev="pba"
	title="PBA"
	desc="Minimal profile for pre-boot authentication."
	image_ext="iso"
	arch="aarch64 armv7 x86 x86_64"
	output_format="iso"
	kernel_addons=
	kernel_flavors="virt"
	case "$ARCH" in
		arm*|aarch64)
			kernel_cmdline="console=tty0 console=ttyAMA0"
			;;
	esac
	syslinux_serial="0 115200"
	apks="alpine-base apk-cron busybox chrony e2fsprogs kbd-bkeymaps openssl agetty sed-manager-rs"
	apkovl="aports/scripts/genapkovl-pba.sh"
}
