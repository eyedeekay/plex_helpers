#! /usr/bin/env sh
echo "" | tee plex.mk
echo "plex-install:" | tee -a plex.mk
for f in $(find plexmediaserver/usr/lib -type d | tr ' ' '_' ); do
    mv "$(echo $f | tr '_' ' ')" "$f"
    echo "\tinstall -d \"$(echo $f | sed 's|plexmediaserver||')\"" | tee -a plex.mk
done
for f in $(find plexmediaserver/usr/lib -type f | tr ' ' ':'); do
    mv "$(echo $f | tr ':' ' ')" "$f"
    echo "\tinstall -D \"$(echo $f)\" \"$(echo $f | tr ':' ' ' |sed 's|plexmediaserver||')\"" | tee -a plex.mk
done
echo "" | tee -a plex.mk
