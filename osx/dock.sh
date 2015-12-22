#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Mail.app"
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "$HOME/Applications/Google Chrome.app"
dockutil --no-restart --add "$HOME/Applications/Firefox.app"
dockutil --no-restart --add "$HOME/Applications/Sublime Text.app"
dockutil --no-restart --add "$HOME/Applications/WebStorm.app"
dockutil --no-restart --add "$HOME/Applications/SourceTree.app"
dockutil --no-restart --add "$HOME/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/iTunes.app"
dockutil --no-restart --add "/Applications/Utilities/Activity Monitor.app"
dockutil --no-restart --add "/Applications/System Preferences.app"

killall Dock