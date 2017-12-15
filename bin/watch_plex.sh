#! /usr/bin/env sh

for pid in $(ps aux | grep Plex | grep -v grep | awk '{print $2}'); do
    ps aux | grep "$pid"
done
