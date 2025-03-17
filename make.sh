# Build the docker image
docker build -t sed-manager-pba .

# Create container
docker create --name build-pba sed-manager-pba

# Copy development files to container
/bin/bash ./copy_files.sh

# Run build inside container
docker start build-pba
docker exec -t -u build -w /home/build/sed-manager-rs build-pba sh make_apk.sh
docker exec -t -u build -w /home/build build-pba sh make_iso.sh
docker stop build-pba

# Copy back images to host
mkdir -p ./build
docker cp build-pba:/home/build/iso/alpine-pba-edge-x86_64.iso ./build

# Delete container
docker rm build-pba

