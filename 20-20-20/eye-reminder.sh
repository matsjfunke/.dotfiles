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

# Show countdown dialog (updates every second)
osascript <<'EOF'
set countdown to 20
set skipped to false
repeat while countdown > 0 and not skipped
    set result to display dialog "👀 Eye Break!" & return & return & "Look at something 20 feet (6 meters) away." & return & return & "⏱️ " & countdown & " seconds remaining..." buttons {"Skip"} default button 1 giving up after 1
    if button returned of result is "Skip" then
        set skipped to true
    else
        set countdown to countdown - 1
    end if
end repeat
display notification "Back to building! 🛠️" with title "✅ Done!" sound name "Glass"
EOF
