@echo off
echo Installing PyInstaller...
pip install -r requirements-build.txt

echo.
echo Building executables...
python build_exe.py

echo.
echo Build complete! Check the 'dist' folder for:
echo   - WindowViewer.exe
echo   - WindowViewerDemo.exe
pause