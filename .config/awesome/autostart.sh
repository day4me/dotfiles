#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM
# If you would like to run a command *once* on login,
# you can use ~/.xprofile

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# Enable numlock on login
# Required numlockx to be installed
run numlockx
