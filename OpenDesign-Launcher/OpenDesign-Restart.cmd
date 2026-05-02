@echo off
title Open Design - Restart
cd /d "C:\Users\Dictator\Documents\open-design"
call "%~dp0_pnpm.cmd" restart web
timeout /t 5 >nul
