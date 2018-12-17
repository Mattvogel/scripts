#!/usr/bin/env python3
import requests

r = requests.get('http://en.wikipedia.org/wiki/Special:Random')

print(r.json)
