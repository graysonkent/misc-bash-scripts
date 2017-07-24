#!/bin/bash

# Script to see which commands can words out of their option flags
# https://grayson.sh/blog/find-which-linux-commands-can-make-words-with-their-options

# Pull in a list of common Linux commands
commandList=(tar grep find ssh sed awk vim diff sort export xargs ls pwd cd gzip bzip2 unzip ftp crontab service ps free top df du cp mv cat mount chmod chown mkdir ifconfig uname whereis whatis locate man tail less su apt yum rpm ping date finger wget);

# Pipe successful "$command -$option" pairs to 'an' to generate anagrams 
for command in ${commandList[@]} ; do
        (for option in {a..z} ; do
                if timeout -k 5 5 "$command" -$option &> /dev/null; then
                                printf $option
                fi
        done) | xargs an -w -d saneWordlist -m 3 2> /dev/null \
              | sed "s/^/ '$command' -/" >> commandOptions.log
done
