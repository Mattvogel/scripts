#!/bin/bash
curl -Is https://en.wikipedia.org/wiki/Special:Random | grep Location | awk -F'/' '{ print tolower() }' | sed 's/_//g' | sed 's/[^a-zA-Z]//g'
