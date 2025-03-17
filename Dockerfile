FROM alpine:edge

# Install tools necessary for mkimage
RUN apk add alpine-sdk alpine-conf syslinux xorriso squashfs-tools grub grub-efi doas

# Install additional tools for EFI
RUN apk add mtools dosfstools grub-efi

# Install Rust
RUN apk add rust cargo

# Add a build user
RUN adduser build -G abuild --disabled-password && passwd -d build

# Add root-like permissions to the build user
RUN echo "permit nopass :abuild" >> /etc/doas.d/doas.conf

RUN su - build -c 'echo "" | abuild-keygen -i -a'
RUN su - build -c 'git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git'
RUN su - build -c 'mkdir sed-manager-rs'
RUN apk update

CMD sleep infinity