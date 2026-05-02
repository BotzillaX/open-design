@echo off
title Open Design - Stop
cd /d "C:\Users\Dictator\Documents\open-design"
call "%~dp0_pnpm.cmd" stop
timeout /t 3 >nul
