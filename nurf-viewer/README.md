# M365 NURF UI Viewer

This project helps you capture and view screenshots of Microsoft 365 NURF (nurturing) notification interfaces for different campaign IDs.

## Files Overview

- `index.html` - Main preview page to view all captured screenshots organized by category
- `capture_screenshots.ps1` - PowerShell script for automated screenshot capture
- `capture_screenshots.bat` - Batch script for automated screenshot capture (recommended)
- `screenshots/` - Directory where captured screenshots are stored

## How to Use

### Method 1: Automated Capture (Recommended)

1. **Run the batch script:**
   ```cmd
   capture_screenshots.bat
   ```
   
   This will:
   - Launch Microsoft Edge with each campaign ID automatically
   - Wait for the NURF interface to appear
   - Capture a screenshot
   - Save it to the `screenshots/` directory
   - Move to the next campaign ID

2. **View the results:**
   Open `index.html` in any web browser to see all screenshots organized by category.

### Method 2: Manual Capture

If you prefer manual control or the automated script doesn't work:

1. **Manually launch Edge with each campaign ID:**
   ```cmd
   msedge.exe --nurturing-show-notification-for-testing=M365OpenLinks_ManagedBanner
   ```

2. **Take screenshots manually** when the NURF interface appears

3. **Save screenshots** in the `screenshots/` directory with the naming format: `{CampaignID}.png`

4. **Open `index.html`** to view the results

## Campaign Categories

The screenshots are organized into the following categories:

### M365OpenLinks Managed Banners
- M365OpenLinks_ManagedBanner
- M365OpenLinks_TeamsManagedBanner

### M365OpenLinks Inform Variants
- M365OpenLinks_InformVariant1
- M365OpenLinks_InformVariant2
- M365OpenLinks_InformVariant3
- M365OpenLinks_InformVariant4
- M365OpenLinks_TeamsInformPrompt

### M365OpenLinks OptOut Variants (Flyout)
- M365OpenLinks_OptOutVariant1
- M365OpenLinks_OptOutVariant2
- M365OpenLinks_OptOutVariant3
- M365OpenLinks_OptOutVariant4
- M365OpenLinks_OptOutLastFlyOutBingVariant

### M365OpenLinks Sidebar OptOut Variants
- M365OpenLinks_OptOutSidebarAlwaysShow
- M365OpenLinks_OptOutSidebarAutoHide
- M365OpenLinks_OptOutSidebarAlwaysShowLast
- M365OpenLinks_OptOutSidebarAutoHideLast

### M365OpenLinks OptOut Banner Variants
- M365OpenLinks_OptOutBannerVariant1
- M365OpenLinks_OptOutBannerVariant2
- M365OpenLinks_OptOutBannerVariant3
- M365OpenLinks_OptOutBannerVariant4

### M365OpenLinks OptOut Modal Variants
- M365OpenLinks_OptOutModalVariant1
- M365OpenLinks_OptOutModalVariant2
- M365OpenLinks_OptOutModalVariant4

### M365OpenLinks Teams OptOut Variants
- M365OpenLinks_TeamsOptOutVariant1
- M365OpenLinks_TeamsOptOutVariant2
- M365OpenLinks_TeamsOptOutVariant3

### M365OpenLinks Teams OptOut Banner Variants
- M365OpenLinks_TeamsOptOutBannerVariant1
- M365OpenLinks_TeamsOptOutBannerVariant2
- M365OpenLinks_TeamsInformBanner

### M365OpenLinks Inform Banner Variants
- M365OpenLinks_InformBannerVariant1
- M365OpenLinks_InformBannerVariant2
- M365OpenLinks_InformBannerVariant3
- M365OpenLinks_InformBannerVariant4

## Features

- **Organized Display**: Screenshots are categorized and clearly labeled
- **Responsive Grid**: Automatically adjusts to screen size
- **Click to Enlarge**: Click any screenshot to view it in full size
- **Loading Indicators**: Shows loading status while screenshots are being loaded
- **Error Handling**: Displays "Screenshot not available" for missing images

## Troubleshooting

- **Edge doesn't launch**: Make sure Microsoft Edge is installed and accessible via command line
- **No NURF interface appears**: Some campaign IDs might not be active or available in your environment
- **Screenshots are blank**: Try increasing the wait time in the scripts (currently set to 8 seconds)
- **Permission issues**: Run the command prompt as Administrator if needed

## Notes

- The automated scripts will close existing Edge instances before launching with each campaign ID
- Screenshots are saved as PNG files in full screen resolution
- The HTML viewer works offline and doesn't require internet connection