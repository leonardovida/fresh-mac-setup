# fresh-mac-setup

Opinionated setup of a fresh new Mac machine.

## Introduction

This repository is used to setup a new machine from scratch.
It is highly opinionated and is tailored to my needs, but it can be used as a starting point for your own setup.

## Prerequisites

- Be a root user
- Know how to use the terminal (or at least be able to follow instructions)
- Have a working internet connection

> Note: Always read the scripts before running them. You should know what they do before executing them.

## How to and what will be installed

On a terminal, run the following command to use the setup.sh

- sudo ./setup.sh

On a high level, this is what will be installed:
  
- An SSH will be generated, please follow the instructions on the terminal
- [Homebrew](https://brew.sh/)
- Many useful apps and packages will be installed using Homebrew 
- Mackup will be used to restore previous settings (I use iCloud so save, but you can use Dropbox or Google Drive).
  Please remember to configure it!
- [Oh My Zsh](https://ohmyz.sh/) will be installed and configured
- Some useful mac settings will be applied