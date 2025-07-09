# PowerShell script to capture NURF screenshots
param(
    [string]$EdgePath = "msedge.exe",
    [int]$WaitTime = 5
)

# Array of campaign IDs
$campaignIds = @(
    "M365OpenLinks_ManagedBanner",
    "M365OpenLinks_TeamsManagedBanner",
    "M365OpenLinks_InformVariant1",
    "M365OpenLinks_InformVariant2",
    "M365OpenLinks_InformVariant3",
    "M365OpenLinks_InformVariant4",
    "M365OpenLinks_TeamsInformPrompt",
    "M365OpenLinks_OptOutVariant1",
    "M365OpenLinks_OptOutVariant2",
    "M365OpenLinks_OptOutVariant3",
    "M365OpenLinks_OptOutVariant4",
    "M365OpenLinks_OptOutLastFlyOutBingVariant",
    "M365OpenLinks_OptOutSidebarAlwaysShow",
    "M365OpenLinks_OptOutSidebarAutoHide",
    "M365OpenLinks_OptOutSidebarAlwaysShowLast",
    "M365OpenLinks_OptOutSidebarAutoHideLast",
    "M365OpenLinks_OptOutBannerVariant1",
    "M365OpenLinks_OptOutBannerVariant2",
    "M365OpenLinks_OptOutBannerVariant3",
    "M365OpenLinks_OptOutBannerVariant4",
    "M365OpenLinks_OptOutModalVariant1",
    "M365OpenLinks_OptOutModalVariant2",
    "M365OpenLinks_OptOutModalVariant4",
    "M365OpenLinks_TeamsOptOutVariant1",
    "M365OpenLinks_TeamsOptOutVariant2",
    "M365OpenLinks_TeamsOptOutVariant3",
    "M365OpenLinks_TeamsOptOutBannerVariant1",
    "M365OpenLinks_TeamsOptOutBannerVariant2",
    "M365OpenLinks_TeamsInformBanner",
    "M365OpenLinks_InformBannerVariant1",
    "M365OpenLinks_InformBannerVariant2",
    "M365OpenLinks_InformBannerVariant3",
    "M365OpenLinks_InformBannerVariant4"
)

Write-Host "Starting NURF screenshot capture process..."
Write-Host "Total campaigns: $($campaignIds.Count)"

# Create screenshots directory if it doesn't exist
$screenshotsPath = Join-Path $PSScriptRoot "screenshots"
if (!(Test-Path $screenshotsPath)) {
    New-Item -ItemType Directory -Path $screenshotsPath -Force
    Write-Host "Created screenshots directory: $screenshotsPath"
}

# Function to take screenshot using Windows API
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Take-Screenshot {
    param([string]$FilePath)
    
    $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $screenshot = New-Object System.Drawing.Bitmap $screenBounds.Width, $screenBounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($screenshot)
    $graphics.CopyFromScreen($screenBounds.Location, [System.Drawing.Point]::Empty, $screenBounds.Size)
    $screenshot.Save($FilePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $screenshot.Dispose()
}

# Process each campaign ID
foreach ($campaignId in $campaignIds) {
    Write-Host "`nProcessing campaign: $campaignId"
    
    # Kill any existing Edge processes to ensure clean start
    try {
        Get-Process -Name "msedge" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    } catch {
        # Ignore errors if no Edge processes exist
    }
    
    # Launch Edge with the campaign ID
    $edgeArgs = "--nurturing-show-notification-for-testing=$campaignId"
    Write-Host "Launching Edge with args: $edgeArgs"
    
    try {
        $process = Start-Process -FilePath $EdgePath -ArgumentList $edgeArgs -PassThru
        
        # Wait for Edge to fully load and NURF interface to appear
        Write-Host "Waiting $WaitTime seconds for NURF interface to appear..."
        Start-Sleep -Seconds $WaitTime
        
        # Take screenshot
        $screenshotPath = Join-Path $screenshotsPath "$campaignId.png"
        Take-Screenshot -FilePath $screenshotPath
        Write-Host "Screenshot saved: $screenshotPath"
        
        # Close Edge
        if (!$process.HasExited) {
            $process.CloseMainWindow()
            Start-Sleep -Seconds 2
            if (!$process.HasExited) {
                $process.Kill()
            }
        }
        
    } catch {
        Write-Error "Failed to process $campaignId : $_"
    }
    
    # Small delay between campaigns
    Start-Sleep -Seconds 1
}

Write-Host "`nScreenshot capture completed!"
Write-Host "Screenshots saved in: $screenshotsPath"
Write-Host "You can now open index.html to view all screenshots."