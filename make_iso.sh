#-------------------------------------------------------------------------------
# Copyright © 2025 Péter Kardos
# SPDX-License-Identifier: MIT
#-------------------------------------------------------------------------------

# This file is to be run in the container

# Build ISO
sh /home/build/aports/scripts/mkimage.sh\
    --tag edge\
    --outdir /home/build/iso\
    --arch x86_64\
    --repository https://dl-cdn.alpinelinux.org/alpine/edge/main\
    --repository https://dl-cdn.alpinelinux.org/alpine/edge/community\
    --repository /home/build/packages/build/\
    --profile pba