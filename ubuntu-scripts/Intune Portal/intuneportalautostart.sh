#!/bin/bash

FILE=/etc/xdg/autostart/intune-portal.desktop
if ! test -f "$FILE"; then
    cp /usr/share/applications/intune-portal.desktop /etc/xdg/autostart/intune-portal.desktop
fi