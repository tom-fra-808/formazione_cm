#!/bin/sh
set -e

mkdir -p /run/sshd
ssh-keygen -A

#verifica sintassi file di configurazione sshd_config
/usr/sbin/sshd -t
#avvia daemon e redirecta errori bug in standard error 
/usr/sbin/sshd -e

exec dockerd \
    --host=unix:///var/run/docker.sock \
    --insecure-registry=192.168.58.10:5000 \
    "$@"