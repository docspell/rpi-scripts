#!/usr/bin/env bash

set -e

date=$(date "+%Y-%m-%d")
out=/mnt/usb/backups
mkdir -p $out

echo "Getting current version of docspell ..."

url=$(curl --HEAD -v "https://github.com/eikek/docspell/releases/latest" 2>&1 | sed $'s/\r//' | grep -i "< location:" | cut -d' ' -f3 | xargs)
current_version=$(basename $url | sed 's,^v,,g')

ds_version=$(dpkg -l |grep docspell | awk '{print $3}' | head -n1 | xargs)

if [ "$ds_version" == "$current_version" ]; then
    echo "Docspell is at newest version: $ds_version"
else
    echo "A new version is available: $current_version"
    echo "Upgrading from $ds_version" && echo

    echo "Downloading docspell binaries …"
    restserver_url="https://github.com/eikek/docspell/releases/download/v${current_version}/docspell-restserver_${current_version}_all.deb"
    joex_url="https://github.com/eikek/docspell/releases/download/v${current_version}/docspell-joex_${current_version}_all.deb"
    tools_url="https://github.com/eikek/docspell/releases/download/v${current_version}/docspell-tools-${current_version}.zip"

    restserver_deb="/tmp/docspell-restserver_${current_version}_all.deb"
    joex_deb="/tmp/docspell-joex_${current_version}_all.deb"

    curl -s -L -o "$restserver_deb" "$restserver_url"
    curl -s -L -o "$joex_deb" "$joex_url"

    echo "Stopping docspell …"
    systemctl stop docspell-restserver.service
    systemctl stop docspell-joex.service
    systemctl stop docspell-consumedir.service

    echo "Dump database …"
    /usr/local/bin/dumpdb.sh

    export DEBIAN_FRONTEND=noninteractive

    echo "Installing new packages…"
    apt install --yes "$restserver_deb" "$joex_deb"

    cd /etc/docspell-restserver && rm docspell-server.conf && \
        ln -snf /etc/docspell/docspell.conf docspell-server.conf
    cd /etc/docspell-joex && rm docspell-joex.conf && \
        ln -snf /etc/docspell/docspell.conf docspell-joex.conf

    echo "Installing new consumedir…"
    rm -rf /opt/docspell-tools-*
    curl -L -o "/opt/docspell-tools-${current_version}.zip" $tools_url
    cd /opt && unzip "docspell-tools-${current_version}.zip"
    chmod 755 /opt/docspell-tools-${current_version}/*.sh
    ln -sfn "/opt/docspell-tools-${current_version}" /opt/docspell-tools

    echo "Starting new services…"
    systemctl restart docspell-restserver.service
    systemctl restart docspell-joex.service
    systemctl restart docspell-consumedir.service
fi
echo "Docspell update done."
