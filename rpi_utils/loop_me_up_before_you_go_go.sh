#!/bin/bash
arecord -D hw:1,0 -M -r 48000 -c 2 -f S16_LE | aplay -D hw:1,0 -M
