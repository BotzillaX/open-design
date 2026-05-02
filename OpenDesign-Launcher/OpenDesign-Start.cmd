@echo off
title Open Design - Start
cd /d "C:\Users\Dictator\Documents\open-design"
call "%~dp0_pnpm.cmd" start web
echo.
echo Server laeuft im Hintergrund. Status mit OpenDesign-Status.cmd pruefen.
timeout /t 5 >nul
