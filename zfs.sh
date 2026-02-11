#!/usr/bin/env bash

POOL="SharedFilesBackup"

case "$1" in
  connect)
    sudo zpool import $POOL
    sudo zfs load-key $POOL
    sudo zfs mount $POOL || exit 1
    echo "- $POOL is now unlocked and mounted."
    ;;
  disconnect)
    sudo zpool export $POOL || exit 1
    echo "- $POOL safely exported and locked."
    ;;
  *)
    echo "Usage: $0 {connect|disconnect}"
    exit 1
    ;;
esac
