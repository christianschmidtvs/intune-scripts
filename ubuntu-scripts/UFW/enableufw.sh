#!/bin/bash

if ! command -v "ufw status" | grep -q 'inaktiv'; then
    ufw enable
elif ! command -v "ufw status" | grep -q 'inactive'; then
    ufw enable
else
    echo "UFW is already enabled."
fi