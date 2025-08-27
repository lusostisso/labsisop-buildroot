#!/bin/sh

HOST=`hostname -I | awk '{print $1}'`

# Network config copies
cp $BASE_DIR/../custom-scripts/S41network-config $BASE_DIR/target/etc/init.d
chmod +x $BASE_DIR/target/etc/init.d/S41network-config

# Hello world app copies
cp $BASE_DIR/../custom-scripts/S50hello $BASE_DIR/target/etc/init.d
chmod +x $BASE_DIR/target/etc/init.d/S41network-config

# Linux status copies
cp $BASE_DIR/../custom-scripts/linuxstatus.py $BASE_DIR/target/usr/bin
cp $BASE_DIR/../custom-scripts/S50linuxstatus $BASE_DIR/target/etc/init.d
chmod +x $BASE_DIR/target/etc/init.d/S50linuxstatus # set file permission
