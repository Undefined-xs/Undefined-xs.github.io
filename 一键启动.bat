@echo off
chcp 65001 >nul 2>&1
title ClipLens

echo ============================================
echo   ClipLens - One Click Start
echo ============================================
echo.

echo Cleaning up old processes...
:: Kill all python processes running uvicorn
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
:: Kill all node processes running vite
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 2 /nobreak >nul

echo Starting backend (port 8000)...
cd /d "%~dp0backend"
start "ClipLens Backend" python -m uvicorn app:app --host 127.0.0.1 --port 8000

echo Waiting for backend...
timeout /t 3 /nobreak >nul

echo Starting frontend (port 5173)...
cd /d "%~dp0frontend"
start "ClipLens Frontend" npx vite --host

echo Waiting for frontend...
timeout /t 5 /nobreak >nul

echo.
echo Opening browser...
start "" http://localhost:5173

echo.
echo ============================================
echo   ClipLens is running!
echo   Backend: http://localhost:8000
echo   Frontend: http://localhost:5173
echo ============================================
echo.
pause
