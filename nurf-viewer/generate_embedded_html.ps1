# PowerShell script to generate HTML with embedded base64 images
param(
    [string]$ScreenshotsPath = "screenshots",
    [string]$OutputFile = "embedded_viewer.html"
)

Write-Host "Generating HTML with embedded screenshots..."

# Get all PNG files from screenshots directory
$pngFiles = Get-ChildItem -Path $ScreenshotsPath -Filter "*.png" | Sort-Object Name

if ($pngFiles.Count -eq 0) {
    Write-Error "No PNG files found in $ScreenshotsPath directory"
    exit 1
}

Write-Host "Found $($pngFiles.Count) screenshot files"

# Function to convert image to base64
function Convert-ImageToBase64 {
    param([string]$ImagePath)
    $imageBytes = [System.IO.File]::ReadAllBytes($ImagePath)
    return [System.Convert]::ToBase64String($imageBytes)
}

# Define campaign categories
$categories = @{
    "M365OpenLinks Managed Banners" = @(
        "M365OpenLinks_ManagedBanner",
        "M365OpenLinks_TeamsManagedBanner"
    )
    "M365OpenLinks Inform Variants" = @(
        "M365OpenLinks_InformVariant1",
        "M365OpenLinks_InformVariant2", 
        "M365OpenLinks_InformVariant3",
        "M365OpenLinks_InformVariant4",
        "M365OpenLinks_TeamsInformPrompt"
    )
    "M365OpenLinks OptOut Variants (Flyout)" = @(
        "M365OpenLinks_OptOutVariant1",
        "M365OpenLinks_OptOutVariant2",
        "M365OpenLinks_OptOutVariant3", 
        "M365OpenLinks_OptOutVariant4",
        "M365OpenLinks_OptOutLastFlyOutBingVariant"
    )
    "M365OpenLinks Sidebar OptOut Variants" = @(
        "M365OpenLinks_OptOutSidebarAlwaysShow",
        "M365OpenLinks_OptOutSidebarAutoHide",
        "M365OpenLinks_OptOutSidebarAlwaysShowLast",
        "M365OpenLinks_OptOutSidebarAutoHideLast"
    )
    "M365OpenLinks OptOut Banner Variants" = @(
        "M365OpenLinks_OptOutBannerVariant1",
        "M365OpenLinks_OptOutBannerVariant2",
        "M365OpenLinks_OptOutBannerVariant3",
        "M365OpenLinks_OptOutBannerVariant4"
    )
    "M365OpenLinks OptOut Modal Variants" = @(
        "M365OpenLinks_OptOutModalVariant1",
        "M365OpenLinks_OptOutModalVariant2",
        "M365OpenLinks_OptOutModalVariant4"
    )
    "M365OpenLinks Teams OptOut Variants" = @(
        "M365OpenLinks_TeamsOptOutVariant1",
        "M365OpenLinks_TeamsOptOutVariant2",
        "M365OpenLinks_TeamsOptOutVariant3"
    )
    "M365OpenLinks Teams OptOut Banner Variants" = @(
        "M365OpenLinks_TeamsOptOutBannerVariant1",
        "M365OpenLinks_TeamsOptOutBannerVariant2",
        "M365OpenLinks_TeamsInformBanner"
    )
    "M365OpenLinks Inform Banner Variants" = @(
        "M365OpenLinks_InformBannerVariant1",
        "M365OpenLinks_InformBannerVariant2",
        "M365OpenLinks_InformBannerVariant3",
        "M365OpenLinks_InformBannerVariant4"
    )
}

# Start building HTML content
$htmlHeader = @'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M365 NURF Campaign Screenshots - Embedded Viewer</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 10px;
            font-size: 2.5em;
            font-weight: 300;
        }
        .subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 40px;
            font-size: 1.1em;
        }
        h2 {
            color: #34495e;
            border-left: 4px solid #3498db;
            padding-left: 15px;
            margin-top: 50px;
            margin-bottom: 25px;
            font-size: 1.4em;
        }
        .campaign-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .campaign-item {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            background: #fafafa;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .campaign-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border-color: #3498db;
        }
        .campaign-id {
            font-weight: 600;
            color: #2980b9;
            margin-bottom: 15px;
            font-size: 14px;
            padding: 8px 12px;
            background: #e3f2fd;
            border-radius: 6px;
            border-left: 3px solid #2196f3;
        }
        .screenshot-container {
            text-align: center;
            margin-top: 15px;
            position: relative;
        }
        .screenshot {
            max-width: 100%;
            height: auto;
            border: 2px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            max-height: 300px;
            object-fit: contain;
        }
        .screenshot:hover {
            transform: scale(1.02);
            border-color: #3498db;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }
        .no-screenshot {
            color: #e74c3c;
            font-style: italic;
            padding: 40px 20px;
            background: #ffeaea;
            border: 2px dashed #e74c3c;
            border-radius: 8px;
            font-size: 14px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.95);
            animation: fadeIn 0.3s ease;
        }
        .modal-content {
            margin: auto;
            display: block;
            max-width: 95%;
            max-height: 95%;
            margin-top: 2.5%;
            border-radius: 8px;
            animation: zoomIn 0.3s ease;
        }
        .close {
            position: absolute;
            top: 20px;
            right: 35px;
            color: #fff;
            font-size: 45px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10001;
            transition: color 0.3s ease;
        }
        .close:hover {
            color: #3498db;
        }
        .modal-caption {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            color: #fff;
            font-size: 16px;
            background: rgba(0,0,0,0.7);
            padding: 10px 20px;
            border-radius: 20px;
        }
        .stats {
            text-align: center;
            margin-bottom: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            color: #6c757d;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes zoomIn {
            from { transform: scale(0.8); }
            to { transform: scale(1); }
        }
        .category-summary {
            display: inline-block;
            background: #e8f5e8;
            color: #2e7d32;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>M365 NURF Campaign Screenshots</h1>
        <div class="subtitle">内嵌式截图查看器 - 所有图片已内嵌到页面中</div>
        
        <div class="stats">
            共收集了 <strong id="total-screenshots">0</strong> 个campaign的截图
        </div>
'@

$htmlContent = $htmlHeader

# Process each category
$totalScreenshots = 0
foreach ($categoryName in $categories.Keys) {
    $campaignIds = $categories[$categoryName]
    $availableScreenshots = 0
    
    # Count available screenshots for this category
    foreach ($campaignId in $campaignIds) {
        $imagePath = Join-Path $ScreenshotsPath "$campaignId.png"
        if (Test-Path $imagePath) {
            $availableScreenshots++
        }
    }
    
    $htmlContent += "`n        <h2>$categoryName <span class='category-summary'>$availableScreenshots/$($campaignIds.Count) available</span></h2>"
    $htmlContent += "`n        <div class='campaign-grid'>"

    foreach ($campaignId in $campaignIds) {
        $imagePath = Join-Path $ScreenshotsPath "$campaignId.png"
        
        $htmlContent += "`n            <div class='campaign-item'>"
        $htmlContent += "`n                <div class='campaign-id'>$campaignId</div>"
        $htmlContent += "`n                <div class='screenshot-container'>"

        if (Test-Path $imagePath) {
            Write-Host "Converting $campaignId to base64..."
            $base64 = Convert-ImageToBase64 -ImagePath $imagePath
            $totalScreenshots++
            
            $htmlContent += "`n                    <img class='screenshot' src='data:image/png;base64,$base64' alt='$campaignId' onclick='openModal(this.src, `"$campaignId`")'>"
        } else {
            $htmlContent += "`n                    <div class='no-screenshot'>Screenshot not available</div>"
        }
        
        $htmlContent += "`n                </div>"
        $htmlContent += "`n            </div>"
    }
    
    $htmlContent += "`n        </div>"
}

# Add modal and JavaScript
$htmlFooter = @"

    </div>

    <!-- Modal for full-size images -->
    <div id="imageModal" class="modal">
        <span class="close">&times;</span>
        <img class="modal-content" id="modalImage">
        <div class="modal-caption" id="modalCaption"></div>
    </div>

    <script>
        // Update total screenshots count
        document.getElementById('total-screenshots').textContent = '$totalScreenshots';
        
        // Modal functionality
        const modal = document.getElementById('imageModal');
        const modalImg = document.getElementById('modalImage');
        const modalCaption = document.getElementById('modalCaption');
        const span = document.getElementsByClassName('close')[0];

        // Function to open modal
        function openModal(imgSrc, campaignId) {
            modal.style.display = 'block';
            modalImg.src = imgSrc;
            modalCaption.textContent = campaignId;
        }

        // Close modal
        span.onclick = function() {
            modal.style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                modal.style.display = 'none';
            }
        });
    </script>
</body>
</html>
"@

$htmlContent += $htmlFooter

# Write HTML to file
try {
    $htmlContent | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-Host "HTML file generated successfully: $OutputFile"
    Write-Host "Total screenshots embedded: $totalScreenshots"
    Write-Host "File size: $([math]::Round((Get-Item $OutputFile).Length / 1MB, 2)) MB"
} catch {
    Write-Error "Failed to write HTML file: $_"
    exit 1
}