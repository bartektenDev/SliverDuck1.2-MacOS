#!/usr/bin/env bash

#set -e

#change script activated working directory to current directory
cd "$(dirname "$0")"

osascript -e 'display notification "Successful Bypass!" with title "SliverDuck"'
