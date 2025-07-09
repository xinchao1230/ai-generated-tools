@echo off
echo Starting Window Viewer...
python window_viewer.py
if errorlevel 1 (
    echo.
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.x from https://www.python.org/
    pause
)