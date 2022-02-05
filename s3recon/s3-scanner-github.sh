#!/bin/bash

curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/search/code?q=s3.amazonaws.com+org:$1" -s | jq "[.items] | .[] | .[] | .html_url" | sed 's/"$//' | sed 's/"//' |while read url; do curl -s $url | grep -i "s3\.amazonaws\.com";done
