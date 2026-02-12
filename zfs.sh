#!/usr/bin/env bash

POOL="SharedFilesBackup"

case "$1" in
  connect)
    sudo zpool import $POOL
    sudo zfs load-key $POOL

    MOUNTPOINT=""
    case "$(uname)" in
      Darwin)
        MOUNTPOINT="/Users/$USER/openzfs"
        ;;
      Linux)
        MOUNTPOINT="/mnt/openzfs"
        ;;
    esac

    sudo zfs mount -o mountpoint="$MOUNTPOINT" $POOL || exit 1
    echo "- $POOL is now unlocked and mounted in folder $MOUNTPOINT."
    ;;
  disconnect)
    sudo zpool export $POOL || exit 1
    echo "- $POOL safely exported and locked."
    ;;
  setup-group)
    echo "- Creating zfs-share group..."
    case "$(uname)" in 
      Darwin)
        sudo dscl . create /Groups/zfs-share
        sudo dscl . create /Groups/zfs-share PrimaryGroupID 2000
        sudo dscl . append /Groups/zfs-share GroupMembership $USER
        ;;
      Linux)
        sudo groupadd -g 2000 zfs-share
        sudo usermod -aG zfs-share $USER
        ;;
      *)
        echo "Invalid system: $(uname)"
        exit 1
        ;;
    esac
    ;;
  initialize)
    echo "- Initializing openzfs..."

    if [[ $2 != *"/dev/sd"* ]]; then
      echo "- Invalid device, use: $0 initialize /dev/sdXY"
      exit 1
    fi

    sudo zpool create \
      -m none \
      -O encryption=on \
      -O keyformat=passphrase \
      SharedFilesBackup /dev/sda2
    ./zsh.sh setup-group
    sudo chown "$USER:zfs-share" .
    echo "- Finished setting up openzfs"
    ;;
  *)
    echo "Usage: $0 {connect|disconnect|setup-group,initialize} [dev]"
    exit 1
    ;;
esac
