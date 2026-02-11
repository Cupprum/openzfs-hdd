# OpenZFS on HDD used by Linux and Mac

## Installation:

Change the device which should be used
```
sudo zpool create \
    -m /mnt/openzfs \
    -O encryption=on \
    -O keyformat=passphrase \
    SharedFilesBackup /dev/sda2
```

Verify that the drive works: `zpool status SharedFilesBackup`
