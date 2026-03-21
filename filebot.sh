#!/usr/bin/env bash

# Setup environment
export FILEBOT_HOME="/app/dist"
export APP_DATA="/app/data"

export LIBRARY_PATH="$FILEBOT_HOME/lib/native/linux-amd64"

java \
    -Dunixfs=false \
    -DuseExtendedFileAttributes=true \
    -DuseCreationDate=false \
    -Djava.net.useSystemProxies=true \
    -Djna.nosys=true \
    -Djna.nounpack=true \
    --illegal-access=permit \
    -Djna.boot.library.path="$LIBRARY_PATH" \
    -Djna.library.path="$LIBRARY_PATH" \
    -Djava.library.path="$LIBRARY_PATH" \
    -Dapplication.dir="$APP_DATA" \
    -Dapplication.cache="$APP_DATA/cache" \
    -Djava.io.tmpdir="$APP_DATA/tmp" \
    -Dfile.encoding="UTF-8" \
    -Dsun.jnu.encoding="UTF-8" \
    -Dnet.filebot.AcoustID.fpcalc="fpcalc" \
    --module-path /usr/share/openjfx/lib \
    --add-modules ALL-MODULE-PATH \
    -cp "$FILEBOT_HOME/lib/*" \
    net.filebot.Main "$@"
