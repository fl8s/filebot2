#!/bin/bash
mkdir -p /app/lib/native/linux-amd64

wget -qO- https://get.filebot.net/filebot/FileBot_4.9.1/FileBot_4.9.1-portable.tar.xz | tar xJ -C /tmp
cp -r /tmp/jar/* /app/lib/
cp -r /tmp/lib/Linux-x86_64/* /app/lib/native/linux-amd64/

wget https://repo1.maven.org/maven2/info/picocli/picocli/4.7.5/picocli-4.7.5.jar -O /app/lib/picocli.jar
