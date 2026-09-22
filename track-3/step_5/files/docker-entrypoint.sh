#!/bin/sh
set -e

mkdir -p /run/sshd
ssh-keygen -A

/usr/sbin/sshd -t
/usr/sbin/sshd -e

exec dockerd \
    --host=unix:///var/run/docker.sock \
    --insecure-registry=192.168.58.10:5000 \
    "$@"