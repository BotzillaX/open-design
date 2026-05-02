@echo off
rem Helper: ruft `pnpm tools-dev` mit allen Argumenten auf.
rem Faellt auf den User-npm-Pfad zurueck, falls pnpm nicht im PATH ist.

where pnpm >nul 2>&1
if %ERRORLEVEL%==0 (
  call pnpm tools-dev %*
  exit /b %ERRORLEVEL%
)

if exist "%APPDATA%\npm\pnpm.cmd" (
  call "%APPDATA%\npm\pnpm.cmd" tools-dev %*
  exit /b %ERRORLEVEL%
)

echo [Fehler] pnpm nicht gefunden. Bitte installieren mit:
echo   npm install -g pnpm@10.33.2
exit /b 1
