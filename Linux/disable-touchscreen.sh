#!/bin/sh

# call this script from ~/.profile

screen_input=$(xinput --list | grep -iPo 'touchscreen.*id=\K([0-9]+)')
xinput disable $screen_input
