@echo off
echo M365 NURF Campaign Launcher
echo.

if "%1"=="" (
    echo Usage: %0 ^<CampaignID^>
    echo.
    echo Examples:
    echo   %0 M365OpenLinks_ManagedBanner
    echo   %0 M365OpenLinks_InformVariant1
    echo   %0 M365OpenLinks_OptOutVariant1
    echo.
    echo Available Campaign IDs:
    echo   M365OpenLinks_ManagedBanner
    echo   M365OpenLinks_TeamsManagedBanner
    echo   M365OpenLinks_InformVariant1
    echo   M365OpenLinks_InformVariant2
    echo   M365OpenLinks_InformVariant3
    echo   M365OpenLinks_InformVariant4
    echo   M365OpenLinks_TeamsInformPrompt
    echo   M365OpenLinks_OptOutVariant1
    echo   M365OpenLinks_OptOutVariant2
    echo   M365OpenLinks_OptOutVariant3
    echo   M365OpenLinks_OptOutVariant4
    echo   M365OpenLinks_OptOutLastFlyOutBingVariant
    echo   M365OpenLinks_OptOutSidebarAlwaysShow
    echo   M365OpenLinks_OptOutSidebarAutoHide
    echo   M365OpenLinks_OptOutSidebarAlwaysShowLast
    echo   M365OpenLinks_OptOutSidebarAutoHideLast
    echo   M365OpenLinks_OptOutBannerVariant1
    echo   M365OpenLinks_OptOutBannerVariant2
    echo   M365OpenLinks_OptOutBannerVariant3
    echo   M365OpenLinks_OptOutBannerVariant4
    echo   M365OpenLinks_OptOutModalVariant1
    echo   M365OpenLinks_OptOutModalVariant2
    echo   M365OpenLinks_OptOutModalVariant4
    echo   M365OpenLinks_TeamsOptOutVariant1
    echo   M365OpenLinks_TeamsOptOutVariant2
    echo   M365OpenLinks_TeamsOptOutVariant3
    echo   M365OpenLinks_TeamsOptOutBannerVariant1
    echo   M365OpenLinks_TeamsOptOutBannerVariant2
    echo   M365OpenLinks_TeamsInformBanner
    echo   M365OpenLinks_InformBannerVariant1
    echo   M365OpenLinks_InformBannerVariant2
    echo   M365OpenLinks_InformBannerVariant3
    echo   M365OpenLinks_InformBannerVariant4
    echo.
    pause
    exit /b 1
)

echo Launching Microsoft Edge with campaign ID: %1
echo Command: msedge.exe --nurturing-show-notification-for-testing=%1
echo.

:: Close any existing Edge processes
taskkill /f /im msedge.exe >nul 2>&1

:: Launch Edge with the specified campaign ID
start "" msedge.exe --nurturing-show-notification-for-testing=%1

echo Edge launched. Look for the NURF notification interface.
echo Press any key to close this window...
pause >nul