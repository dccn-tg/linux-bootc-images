#!/usr/bin/env bash

images=(fedora-silverblue fedora-kinoite fedora-sway)

echo "setting password for the initial user 'dccntg' to be provisioned via kickstart"
PASSWORD_HASH=$(openssl passwd -6)

sed "s|@PASSWORD@|${PASSWORD_HASH}|" blueprint-template.toml > /tmp/blueprint.toml

mkdir -p ./output

for image in ${images[@]}; do
    podman pull ghcr.io/dccn-tg/${image}:latest &&
    podman run \
        --network=host \
        --rm -it --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v /tmp/blueprint.toml:/config.toml:ro \
        -v ./output:/output \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        ghcr.io/osbuild/bootc-image-builder:latest \
          -v --log-level debug \
          --type anaconda-iso \
          --rootfs xfs \
          ghcr.io/dccn-tg/${image}:latest &&
    mv ./output/bootiso/install.iso ./output/bootiso/${image}.iso
done

[ -f /tmp/blueprint.toml ] && rm -f /tmp/blueprint.toml
