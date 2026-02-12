# OpenZFS on HDD used by Linux and Mac

## Installation:

Format the drive and find under which device its located: `lsblk`.

Execute the `./zfs.sh initialize /dev/sdXY` shell script, change the sdXY to something valid.

Verify that the drive works: `zpool status SharedFilesBackup`

## Connect / Disconnect to the ZFS

Execute the `zfs.sh connect|disconnect` shell script.
The Filesystem should be visible under `/mnt/openzfs`

## Create group on the other machine

Execute the `./zfs.sh setup-group` shell script.
