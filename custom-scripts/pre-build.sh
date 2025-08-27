#!/bin/sh
HOST=`hostname -I | awk '{print $1}'`
cat $BASE_DIR/../custom-scripts/network-config | sed 's/\[IP-DO-HOST\]/'"$HOST"'/g' > $BASE_DIR/../custom-scripts/S41network-config
cp $BASE_DIR/../custom-scripts/S41network-config $BASE_DIR/target/etc/init.d
chmod +x $BASE_DIR/target/etc/init.d/S41network-config

cp $BASE_DIR/../custom-scripts/S50hello $BASE_DIR/target/etc/init.d
chmod +x $BASE_DIR/target/etc/init.d/S41network-config
$HOST_CC $$HOST_CC ${BASE_DIR}/apps/hello.c -O2 -o ${BASE_DIR}/apps/hello
cp ${BASE_DIR}/apps/hello ${TARGET_DIR}/usr/bin/
cp ${BASE_DIR}/custom-scripts/S50hello ${TARGET_DIR}/etc/init.d/
chmod +x ${TARGET_DIR}/usr/bin/hello
chmod +x ${TARGET_DIR}/etc/init.d/S50hello

cp board/labsisop/linuxstatus.py output/target/usr/bin/
chmod +x output/target/usr/bin/linuxstatus.py
chmod +x output/target/etc/init.d/S50linuxstatus