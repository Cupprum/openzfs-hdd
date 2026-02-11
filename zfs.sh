#!/usr/bin/env bash

POOL="SharedFilesBackup"

case "$1" in
  connect)
    sudo zpool import $POOL
    sudo zfs load-key $POOL
    sudo zfs mount -o mountpoint=/Users/x42/openzfs $POOL || exit 1
    echo "- $POOL is now unlocked and mounted."
    ;;
  disconnect)
    sudo zpool export $POOL || exit 1
    echo "- $POOL safely exported and locked."
    ;;
  setup-group)
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
  *)
    echo "Usage: $0 {connect|disconnect|setup-group}"
    exit 1
    ;;
esac
