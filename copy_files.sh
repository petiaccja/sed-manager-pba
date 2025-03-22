#-------------------------------------------------------------------------------
# Copyright © 2025 Péter Kardos
# SPDX-License-Identifier: MIT
#-------------------------------------------------------------------------------

# Copy development files to container
docker cp ./make_iso.sh build-pba:/home/build/
docker cp ./make_apk.sh build-pba:/home/build/sed-manager-rs
docker cp ./mkimg.pba.sh build-pba:/home/build/aports/scripts/
docker cp ./genapkovl-pba.sh build-pba:/home/build/aports/scripts/
docker cp ./sed-manager-rs/APKBUILD build-pba:/home/build/sed-manager-rs