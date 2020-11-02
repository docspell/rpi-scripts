#!/usr/bin/env bash

set -e

date=$(date "+%Y-%m-%d")
out=/mnt/usb/backups
mkdir -p $out

export PGPASSWORD=docspell

echo "Running pg_dump ..."
pg_dump -h localhost -U docspell -d docspell -n public --format=custom -f "$out/docspell-$date.pgdmp"

if [ "$1" == "-d" ]; then
    echo "Deleting old backup"
    find "$out" -name "docspell-*.pgdmp" -not -name "docspell-$date.pgdmp" | sort -r | tail -n +3 | while read f; do rm "$f"; done
fi

echo "Backup Docspell DB done."
