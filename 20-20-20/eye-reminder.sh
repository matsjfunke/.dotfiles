#!/bin/bash

# Zeige Start-Dialog
osascript -e 'display dialog "👀 Augenpause!\n\nSchaue jetzt für 20 Sekunden auf etwas 6 Meter entferntes.\n\nTimer läuft..." buttons {"OK"} default button 1 giving up after 20'

# Zeige Ende-Benachrichtigung
osascript -e 'display dialog "✅ Fertig!\n\nWeiter gehts!" buttons {"OK"} default button 1 giving up after 3'
