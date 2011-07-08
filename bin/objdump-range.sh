#!/bin/bash

if [ "$#" != 3 ]; then
    echo "Usage: $0 OBJECT_FILE START_LABEL STOP_LABEL"
    exit 1
fi

# init args
OBJECT_FILE="$1"
if [ ! -r "$OBJECT_FILE" ]; then echo "Invalid file: $OBJECT_FILE"; exit 1; fi

CODE_START="$2"
CODE_END="$3"

# process
START_ADDRESS=$(objdump -d "$OBJECT_FILE" | grep "\<${CODE_START}\>" | cut -f1 -d' ' | sed '/^$/d')
if [ -z "$START_ADDRESS" ]; then echo "Invalid label: $CODE_START"; exit 1; fi
STOP_ADDRESS=$(objdump -d "$OBJECT_FILE" | grep "\<$CODE_END\>" | cut -f1 -d' ' | sed '/^$/d')
if [ -z "$STOP_ADDRESS" ]; then echo "Invalid label: $CODE_END"; exit 1; fi

objdump -d "$OBJECT_FILE" --start-address="0x${START_ADDRESS}" --stop-address="0x${STOP_ADDRESS}"
