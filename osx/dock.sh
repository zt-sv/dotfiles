#!/usr/bin/env bash

dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"
dockutil --no-restart --add "/System/Applications/System Preferences.app"

killall Dock
