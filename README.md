# Docspell on a Raspberry Pi

This repository contains scripts and notes to automate most of
creating a raspberry pi with docspell on it.

This is a poor-mans replacement for automatically generating images…
which may come later.

## Basics

The RPIs run [DietPi](https://github.com/Fourdee/dietpi) linux
distribution (which is based on raspbian).

- Docspell is installed via the provided DEB files
- The config is changed such that both (joex + restserver) use the
  same file
- PostgreSQL is installed
- Apache SOLR is installed
- Docspell is started with a default config suitable for "in-house"
  setups – when exposing to the internet *some more steps should be
  taken!*


## Hardware

I'm using here the following (about 250€, summer 2020):

- Raspberry Pi Model 4, 8GB RAM (it is highly recommended to use the
  8G model, the 4G model should work, too though)
- Some flash card
- external 500GB USB SSD hard disk
- case + power supply

## Prepare the USB disk

The disk should be formatted already and a disk label should be set so
that it can be referenced no matter which usb port it is plugged in.
On your computer, run this:

``` shell
./scripts/prepare-disk.sh /dev/<usb-disk>
```

*Be aware that it will reformat the drive and everything on it will be
destroyed!*

## Installation

A new Pi needs to first install dietpi. Insert the SD Card and run:

```
scripts/flash.sh /dev/<sdcard>
```

It will download the dietpi image and copy it onto the card. When
sshing into the machine the first time, you will be guided through the
setup.

I choose the following Options:

- SSH Server: OpenSSH (needed for scp)
- Webserver: Nginx (only for the master-mpd)
- Samba server

Run „Install”.

Login again for final steps, then logout. Now it is ready to apply the
things from this repo.

## Customize

Go to `config/global` and check the settings. Every machine must be
configured with a name and an IP address. When everything looks ok,
run

```
./rpii setup <name>
```

This will run necessary commands on the machine configured with
`<name>`. Use special name `all` to run setup for all machines.
