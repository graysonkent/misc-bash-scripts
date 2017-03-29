#!/bin/bash
#
# Find anagrams of default options for a list of commands
# Commentary: http://bit.ly/2ogpOJA

# Pull in a list of common Linux commands
commandList=( $( 
  curl 'http://www.thegeekstuff.com/2010/11/50-linux-commands/' 2> /dev/null \
    | grep -o '<h3>\([0-9].*[a-z][a-z][a-z].*\)</h3>' \
    | awk '{ print $(NF-2) }' \
    | sed -nr '/rm|wget|less|shutdown|<h3>/!p'
) ); 

# Pipe successful "$command -$option" pairs to 'an' to generate anagrams 
for command in ${commandList[@]} ; do 
	(for option in {a..z} ; do
		timeout -k 5 5 "$command" -"$option" > /dev/null 2>&1;
			if (($? == 0)); then
				printf "$option" | tr -d '\n'
			else
        			:
			fi
	done) | xargs an -w -d saneWordlist -m 3 2> /dev/null \
              | sed 's/^/\ '$command' -/' >> commandOptions.log
done
