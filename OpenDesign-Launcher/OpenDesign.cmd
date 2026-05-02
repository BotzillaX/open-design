@echo off
setlocal
title Open Design Server

set "REPO=C:\Users\Dictator\Documents\open-design"
set "LAUNCHER=%~dp0"

if not exist "%REPO%\package.json" (
  echo [Fehler] Repo nicht gefunden unter: %REPO%
  pause
  exit /b 1
)

cd /d "%REPO%"

:menu
cls
echo ==========================================
echo   Open Design - Server Steuerung
echo   Repo: %REPO%
echo ==========================================
echo.
echo   [1] Starten   (daemon + web, Hintergrund)
echo   [2] Stoppen
echo   [3] Neustart
echo   [4] Status
echo   [5] Logs anzeigen
echo   [6] Im Vordergrund starten (run web)
echo   [7] Check (Status + Logs + Diagnose)
echo   [8] Starten MIT Desktop-Shell (Electron)
echo   [9] Web-URL im Browser oeffnen
echo   [0] Beenden
echo.
set /p choice="Auswahl: "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto stop
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto status
if "%choice%"=="5" goto logs
if "%choice%"=="6" goto runfg
if "%choice%"=="7" goto check
if "%choice%"=="8" goto startdesktop
if "%choice%"=="9" goto openbrowser
if "%choice%"=="0" exit /b 0
goto menu

:start
echo.
echo Starte Open Design (daemon + web)...
call "%LAUNCHER%_pnpm.cmd" start web
echo.
pause
goto menu

:stop
echo.
echo Stoppe Open Design...
call "%LAUNCHER%_pnpm.cmd" stop
echo.
pause
goto menu

:restart
echo.
echo Neustart...
call "%LAUNCHER%_pnpm.cmd" restart web
echo.
pause
goto menu

:status
echo.
call "%LAUNCHER%_pnpm.cmd" status
echo.
pause
goto menu

:logs
echo.
call "%LAUNCHER%_pnpm.cmd" logs
echo.
pause
goto menu

:runfg
echo.
echo Starte im Vordergrund (Strg+C zum Beenden)...
call "%LAUNCHER%_pnpm.cmd" run web
echo.
pause
goto menu

:check
echo.
call "%LAUNCHER%_pnpm.cmd" check
echo.
pause
goto menu

:startdesktop
echo.
echo Starte mit Desktop-Shell (Electron)...
call "%LAUNCHER%_pnpm.cmd"
echo.
echo Hinweis: Falls "desktop did not expose status in time" erscheint,
echo laufen daemon + web trotzdem. Mit [4] Status pruefen.
echo.
pause
goto menu

:openbrowser
echo.
echo Hole Web-URL...
for /f "tokens=*" %%u in ('call "%LAUNCHER%_pnpm.cmd" status --json ^| findstr /C:"\"url\":" ^| findstr /C:"http"') do (
  echo %%u
)
echo.
echo Oeffne Status zum Heraussuchen der Port-Nummer:
call "%LAUNCHER%_pnpm.cmd" status
echo.
echo Oeffne URL manuell oder mit: start http://127.0.0.1:PORT
pause
goto menu
