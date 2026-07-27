#!/usr/bin/env bash

images=(fedora-silverblue fedora-kinoite) 

mkdir -p ./output

for image in ${images[@]}; do
    podman pull ghcr.io/dccn-tg/${image}:latest &&
    podman run \
        --network=host \
        --rm -it --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v ./blueprint.toml:/config.toml:ro \
        -v ./output:/output \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        ghcr.io/osbuild/bootc-image-builder:latest \
          -v --log-level debug \
          --type anaconda-iso \
          --rootfs xfs \
          ghcr.io/dccn-tg/${image}:latest &&
    mv ./output/bootiso/install.iso ./output/bootiso/${image}.iso
done
