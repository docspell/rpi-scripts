# Docspell on a Raspberry Pi

This repository contains scripts and notes to automate most of
creating a raspberry pi with docspell on it.

*Note: This is a poor-mans way, instead of e.g. generating images that
can be dd-ed onto a sd card… which may come later. Any help here is
much appreciated! So don't hesitate to submit issues and/or pull
requests :-)*

The advantage of this method, however, is that you can pick what to
install, e.g. only install docspell + solr to an raspberry pi that
already has postgres running (which requires a raspbian or
raspbian-based system).

## Basics

The RPIs run [DietPi](https://github.com/Fourdee/dietpi) linux
distribution (which is based on raspbian).

- Docspell is installed via the provided DEB files
- The config is changed such that both (joex + restserver) use the
  same file
- PostgreSQL is installed
- Apache SOLR is installed
- Docspell is started with a default config suitable for "in-house"
  setups (i.e. *not* exposed to the internet)


## Hardware

I'm using here the following (about 250€, summer 2020):

- Raspberry Pi Model 4, 8GB RAM (the 4G model should work, too, but
  the 8G model is recommended)
- Some flash card, using a 64G here, but a 8G one would be enough
- external 500GB USB SSD hard disk: this stores the postgres data,
  solr, backups and incoming files
- case + power supply

## Prepare the USB disk

The disk should be formatted already and a disk label should be set so
that it can be referenced no matter which usb port it is plugged in.
This is done by the following script. On your computer, run this:

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
sshing into the machine (default password is `dietpi`) the first time,
you will be guided through the setup.

Choose the following Options:

- SSH Server: OpenSSH (instead of Dropbear, needed for scp)
- Webserver: Nginx (used as reverse proxy)
- Samba server

Run „Install”.

Login again for final steps, then logout. Now it is ready to apply the
things from this repo.


## Customize

This will install everything required to run docspell. Additionally
samba is installed and exposes the following directories:

- "Incoming" (german: "Eingehend"): the folder that is watched to
  import files in docspell. You can mount/access it from a remote
  computer and drop files in there to be processed.
- "Config": the folder containing the docspell configuration file. You
  still must restart the app(s) manually after making changes.
- "Backups": a folder with daily database backups. You can copy them
  to some other place.

Go to `config/global` and check the settings. Every machine must be
configured with a name and an IP address. When everything looks ok,
run

```
./rpii setup <name>
```

This will run necessary commands on the machine configured with
`<name>`. Use special name `all` to run setup for all machines.


## Limitations

- currently, docx files don't seem to work here, because libreoffice
  crashes (not really sure what happens exactly…). This might be
  mitigated by using a different base image (e.g. raspbian)
