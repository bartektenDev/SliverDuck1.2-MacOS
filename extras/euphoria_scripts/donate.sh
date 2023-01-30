#!/usr/bin/env bash

#set -e

#change script activated working directory to current directory
cd "$(dirname "$0")"


echo 'Donate...'

osascript -e 'display notification "Please consider donating!" with title "Donate?"'
