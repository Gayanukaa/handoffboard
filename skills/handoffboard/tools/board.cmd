@echo off
rem Windows wrapper for tools/board: runs it with Git Bash from PowerShell or cmd.
rem Usage: tools\board.cmd <command> [args]   (same commands as tools/board)
setlocal
set "BOARD_SH=%~dp0board"
set "GITBASH="
if exist "%ProgramFiles%\Git\bin\bash.exe" set "GITBASH=%ProgramFiles%\Git\bin\bash.exe"
if not defined GITBASH if exist "%ProgramW6432%\Git\bin\bash.exe" set "GITBASH=%ProgramW6432%\Git\bin\bash.exe"
if not defined GITBASH if exist "%LocalAppData%\Programs\Git\bin\bash.exe" set "GITBASH=%LocalAppData%\Programs\Git\bin\bash.exe"
if not defined GITBASH for /f "delims=" %%G in ('where git 2^>nul') do if not defined GITBASH if exist "%%~dpG..\bin\bash.exe" set "GITBASH=%%~dpG..\bin\bash.exe"
if not defined GITBASH (
  echo board: Git Bash not found. Install Git for Windows from https://git-scm.com/download/win 1>&2
  exit /b 1
)
"%GITBASH%" "%BOARD_SH%" %*
exit /b %ERRORLEVEL%
