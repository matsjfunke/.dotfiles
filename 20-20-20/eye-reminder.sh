#!/bin/bash

# 20-20-20 Rule Eye Break Reminder
# Every 20 minutes, look at something 20 feet (6 meters) away for 20 seconds
#
# To run with cron (every 20 minutes):
# 1. Make executable: chmod +x eye-reminder.sh
# 2. Edit crontab: crontab -e
# 3. Add this line: */20 * * * * /Users/matsjfunke/.dotfiles/20-20-20/eye-reminder.sh
# 4. Save and exit
#
# To test manually: ./eye-reminder.sh
# To see running cronjobs: crontab -l

# Show start dialog with 20 second timer
osascript -e 'display dialog "👀 Eye Break!\n\nLook at something 20 feet (6 meters) away for 20 seconds.\n\nTimer running..." buttons {"OK"} default button 1 giving up after 20'

# Show completion message
osascript -e 'display dialog "✅ Done!\n\nBack to building!" buttons {"OK"} default button 1 giving up after 1'
