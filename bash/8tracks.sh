#!/bin/bash

# Script to export your favorited tracks from 8tracks.com
# Supply your username as the first argument
# Recommended Tools: jq, curl

apiPull() {
    if hash curl 2>/dev/null; then
        curl --silent "https://8tracks.com/users/$1/favorite_tracks?per_page=300&format=jsonh" | jsonParse
    elif hash wget 2>/dev/null; then
        wget --quiet -O - "https://8tracks.com/users/$1/favorite_tracks?per_page=300&format=jsonh" | jsonParse
    else
        printf "No standard HTTP transfer tool found. Please install one (curl|wget|etc.)"
    fi
}

jsonParse() {
    if hash jq 2>/dev/null; then
        jq -r '.favorite_tracks[] | .name + " - " + .performer'
    else
        grep -Po '"name":.*?[^\\]"' | awk -F':' '{print $2}'
    fi
}

if [[ $# -eq 0 ]]; then
    printf "Usage: supply your 8tracks.com username as the argument to retrieve your favorited tracks\\nRecommended Tools: jq, curl (sudo apt-get install jq curl)\\nFeedback: grayson@linux.com\\n"
    exit 1
else
    apiPull "$@"
fi
