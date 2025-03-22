# SEDManager PBA

A pre-boot authentication environment for unlocking self-encrypting drives. Based on [SEDManager](https://github.com/petiaccja/sed-manager-rs) and [Alpine Linux](https://alpinelinux.org/).

## Usage

### Pre-boot authentication explained

When you lock a self-encrypting drive, all of its data becomes inaccessible. This includes the partition table and all the contents of the disk partitions, including the operating system's bootloader and the operating system's files. Consequently, it is not possible to boot your operating system from a locked drive.

TCG-compliant (Opal, Opalite, Pyrite, and Ruby) SEDs may come with a so-called *shadow MBR*. This is a small partition (128 MiB) that is visible even when the drive is otherwise locked. You can therefore upload special software on the shadow MBR that unlocks the rest of the drive using your password. This special software is called the pre-boot authentication environment.

After unlocking the drive with the PBA environment, your main operating system can boot as usual. This happens either directly (in case of an UEFI PBA) or after rebooting the computer (in case of a Linux-based PBA, like this one).

### Getting the PBA image

You can grab `sed-manager-pba.iso` from the [releases](https://github.com/petiaccja/sed-manager-pba/releases) page or [build](#building) it yourself.

### Flashing the PBA image to your SED

You can flash the PBA image to your self-encrypting drive's shadow MBR using SEDManager. You can also use any other tool for flashing.

### Configuring your motherboard firmware

After flashing the PBA and locking your drive, your motherboard's firmware will detect the PBA environment as a boot option. You need to configure the system to boot into the PBA environment on startup. Note that your usual operating system will disappear from the boot list once you enable MBR shadowing, and will only reappear once you unlock the drive using the PBA.

### Compatibility with other software & hardware

#### Operating systems

This PBA is completely independent of the operating system you use. You can boot Windows, Mac OS, Linux, or anything else.

#### Motherboards & disks

Both BIOS and UEFI motherboards are supported. For disk support, see SEDManager's documentation.

#### [SEDUtil](https://sedutil.com/)

While you can flash this PBA with SEDUtil, or you can flash SEDUtil's PBA with SEDManager, you cannot use SEDManager's PBA with a SEDUtil-configured drive, and vice versa. The reason for this is that SEDUtil hashes and salts your passwords before setting them on the drive, whereas SEDManager doesn't.

## Building

1. `git clone https://github.com/petiaccja/sed-manager-pba.git`
2. `cd sed-manager-pba`
3. `./make.sh`

`make.sh` creates a Docker container, copies the files from this repo into the inside of the Docker container, runs the build process entirely in the container, and copies out the final ISO to `./build/*.iso`.

You need to have Docker installed and you need to run `make.sh` from the root directory, or else it won't be able to copy files.

## License

- **Source code**: The scripts and other source code in this repository is under the **MIT license**. You may find these scripts helpful when making your own Alpine Linux ISO, hence the permissive license.
- **PBA ISO image**: individual packages fall under their respective licenses:
  - **Linux kernel**: GPL2 with syscall exception
  - **Alpine Linux packages**: various licenses
  - **SEDManager**: please refer to SEDManager's licensing terms on SEDManager's page