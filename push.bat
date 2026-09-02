@echo off
setlocal
cd /d "%~dp0"

where git >nul 2>&1
if errorlevel 1 (
  echo.
  echo [x] Git is not installed.
  echo     Install Git for Windows first: https://git-scm.com/download/win
  echo.
  pause
  exit /b 1
)

if not exist ".git" (
  echo [*] First run - linking this folder to GitHub...
  git init -b main || goto :fail
  git remote add origin https://github.com/fyleo989-pixel/novel.git || goto :fail
  git fetch origin main || goto :fail
  git reset origin/main || goto :fail
)

git add -A
git diff --cached --quiet
if not errorlevel 1 (
  echo [=] Nothing changed. Reader site is already up to date.
  goto :done
)

git -c user.email=novel@local -c user.name=novel commit -m "update reader site" || goto :fail
git push origin main || goto :fail
echo.
echo [ok] Pushed. In a minute or two:
echo      https://fyleo989-pixel.github.io/novel/
goto :done

:fail
echo.
echo [x] FAILED. Screenshot this window and send it to Claude.

:done
if "%~1"=="" pause
endlocal