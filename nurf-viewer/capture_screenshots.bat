@echo off
echo Starting NURF screenshot capture process...
echo.

:: Create screenshots directory if it doesn't exist
if not exist "screenshots" mkdir screenshots

:: Set campaign IDs
set campaigns=M365OpenLinks_ManagedBanner M365OpenLinks_TeamsManagedBanner M365OpenLinks_InformVariant1 M365OpenLinks_InformVariant2 M365OpenLinks_InformVariant3 M365OpenLinks_InformVariant4 M365OpenLinks_TeamsInformPrompt M365OpenLinks_OptOutVariant1 M365OpenLinks_OptOutVariant2 M365OpenLinks_OptOutVariant3 M365OpenLinks_OptOutVariant4 M365OpenLinks_OptOutLastFlyOutBingVariant M365OpenLinks_OptOutSidebarAlwaysShow M365OpenLinks_OptOutSidebarAutoHide M365OpenLinks_OptOutSidebarAlwaysShowLast M365OpenLinks_OptOutSidebarAutoHideLast M365OpenLinks_OptOutBannerVariant1 M365OpenLinks_OptOutBannerVariant2 M365OpenLinks_OptOutBannerVariant3 M365OpenLinks_OptOutBannerVariant4 M365OpenLinks_OptOutModalVariant1 M365OpenLinks_OptOutModalVariant2 M365OpenLinks_OptOutModalVariant4 M365OpenLinks_TeamsOptOutVariant1 M365OpenLinks_TeamsOptOutVariant2 M365OpenLinks_TeamsOptOutVariant3 M365OpenLinks_TeamsOptOutBannerVariant1 M365OpenLinks_TeamsOptOutBannerVariant2 M365OpenLinks_TeamsInformBanner M365OpenLinks_InformBannerVariant1 M365OpenLinks_InformBannerVariant2 M365OpenLinks_InformBannerVariant3 M365OpenLinks_InformBannerVariant4

:: Process each campaign
for %%i in (%campaigns%) do (
    echo.
    echo Processing campaign: %%i
    
    :: Close any existing Edge processes
    taskkill /f /im msedge.exe >nul 2>&1
    timeout /t 2 /nobreak >nul
    
    :: Launch Edge with campaign ID
    echo Launching Edge with --nurturing-show-notification-for-testing=%%i
    start "" msedge.exe --nurturing-show-notification-for-testing=%%i
    
    :: Wait for NURF interface to appear
    echo Waiting 8 seconds for NURF interface to appear...
    timeout /t 8 /nobreak >nul
    
    :: Take screenshot using built-in Windows tool
    echo Taking screenshot...
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height; $graphics = [System.Drawing.Graphics]::FromImage($bmp); $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size); $bmp.Save('screenshots\%%i.png', [System.Drawing.Imaging.ImageFormat]::Png); $graphics.Dispose(); $bmp.Dispose()"
    
    echo Screenshot saved: screenshots\%%i.png
    
    :: Close Edge
    taskkill /f /im msedge.exe >nul 2>&1
    
    :: Brief pause between campaigns
    timeout /t 2 /nobreak >nul
)

echo.
echo Screenshot capture completed!
echo Screenshots saved in: screenshots\
echo You can now open index.html to view all screenshots.
echo.
pause