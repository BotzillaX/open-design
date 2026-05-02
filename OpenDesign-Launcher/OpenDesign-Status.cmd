@echo off
title Open Design - Status
cd /d "C:\Users\Dictator\Documents\open-design"
call "%~dp0_pnpm.cmd" status
echo.
pause
