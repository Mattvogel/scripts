#!/bin/bash
curl -Is https://en.wikipedia.org/wiki/Special:Random |grep location |awk -F'/' '{ print tolower($5) }'|sed 's/_//g' | sed 's/[^a-zA-Z]//g'
