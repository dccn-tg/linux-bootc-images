# Custom OCI bootc image

OCI bootc images for DCCN laptops, based on an atomic Fedora.

## OCI build

When the [Bluebuild recipes](recipes) are changed in this repository, OCI image build via the Bluebuild GitHub Action can be triggered either manually or by publishing a new GitHub release of the repository.

_optional:_ For a newly cloned GitHub repository, a setup is needed for signing the OCI image.  See [here](https://blue-build.org/how-to/cosign/) for the instruction.

## Creating installer ISO

Clone the repository on a local system with podman installed, and run the [isobuild.sh](isobuild.sh) script as root to create a installation ISO that uses Anaconda for unattended installation.  See [blueprint.toml](blueprint.toml) file for the customisation using the [blueprint](https://osbuild.org/docs/user-guide/blueprint-reference/).

The output ISO will be produced in the directory `output/bootiso`.

## Installation with ISO

__The following scenario was tested in GNOME Boxes__

- Flash the ISO to a USB drive
- Boot the system from the USB drive. After the kickstart finishes the installation, system is rebooted into GNOME for first-time setup.

## System upgrade with bootc

The system upgrade/rollback is done via bootc, see [here](https://bootc.dev/bootc/upgrades.html) for more information.
