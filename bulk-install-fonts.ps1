# Script: Font Installation and Management
# Purpose: Install and manage fonts on a Windows system
# Author: [Your Name]
# Date: [Current Date]
# Version: 2.1

# Define paths and log file
$fontsPath = "C:\Scripts\FontsToInstall"
$fontDest = "$env:SystemRoot\Fonts"
$logFile = "C:\FontInstallLog.txt"

# Start transcript for comprehensive logging
Start-Transcript -Path $logFile -Append

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Write-Output $logMessage
    # Note: We're not using Add-Content here as Start-Transcript handles file writing
}

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Log-Message "This script requires administrative privileges. Please run as administrator."
    Stop-Transcript
    exit
}

# Function to check if a font is already installed
function Is-FontInstalled {
    param (
        [string]$fontName,
        [string]$fontType
    )
    $fonts = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    foreach ($font in $fonts.PSObject.Properties) {
        if ($font.Name -match [regex]::Escape($fontName) -and $font.Value -like "*.$fontType") {
            return $true
        }
    }
    return $false
}

# Function to install a font
function Install-Font {
    param (
        [string]$fontFile
    )
    $fontName = [System.IO.Path]::GetFileNameWithoutExtension($fontFile)
    $fontType = [System.IO.Path]::GetExtension($fontFile).TrimStart('.')

    # Check if the font is already installed with the same type
    if (-not (Is-FontInstalled -fontName $fontName -fontType $fontType)) {
        try {
            # Copy the font file to the Fonts directory
            Copy-Item -Path $fontFile -Destination $fontDest -Force

            $fontRegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            $fontValue = [System.IO.Path]::GetFileName($fontFile)

            # Handle potential special cases for registry value format
            $registryName = if ($fontType -eq "ttf") { "$fontName (TrueType)" } else { $fontName }

            New-ItemProperty -Path $fontRegistryKey -Name $registryName -Value $fontValue -PropertyType String -Force
            Log-Message "Installed font: $fontName (Type: $fontType)"

            # Verify installation
            if (Verify-FontInstallation -fontName $fontName -fontType $fontType) {
                Log-Message "Verified installation of font: $fontName (Type: $fontType)"
            } else {
                Log-Message "Warning: Font installation verification failed for $fontName (Type: $fontType)"
            }
        } catch {
            Log-Message "Failed to install font: $fontName (Type: $fontType). Error: $_"
        }
    } else {
        Log-Message "Font already installed: $fontName (Type: $fontType)"
    }
}

# Function to verify font installation
function Verify-FontInstallation {
    param (
        [string]$fontName,
        [string]$fontType
    )
    $registryName = if ($fontType -eq "ttf") { "$fontName (TrueType)" } else { $fontName }
    $installedFont = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $registryName -ErrorAction SilentlyContinue
    return $null -ne $installedFont
}


# Function to get all unique font names with priority to .otf files
function Get-UniqueFonts {
    param (
        [string]$fontsPath
    )

    $fontFiles = Get-ChildItem -Path $fontsPath -Recurse -Include *.ttf, *.otf -File
    $fontDict = @{}

    foreach ($fontFile in $fontFiles) {
        $fontName = $fontFile.BaseName
        $fontType = $fontFile.Extension.TrimStart('.')
        $key = "$fontName-$fontType"
       
        if (-not $fontDict.ContainsKey($key)) {
            $fontDict[$key] = $fontFile.FullName
        } elseif ($fontType -eq "otf" -and $fontDict[$key].EndsWith(".ttf")) {
            # Prioritize .otf over .ttf
            $fontDict[$key] = $fontFile.FullName
        }
    }
    return $fontDict.Values
}

# Function to uninstall fonts
function Uninstall-Fonts {
    param (
        [string]$fontsPath
    )
    $fontFiles = Get-ChildItem -Path $fontsPath -Recurse -Include *.ttf, *.otf -File

    foreach ($fontFile in $fontFiles) {
        $fontName = [System.IO.Path]::GetFileNameWithoutExtension($fontFile)
        $fontType = [System.IO.Path]::GetExtension($fontFile).TrimStart('.')
        $fontRegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

        # Determine the correct registry name
        $registryName = if ($fontType -eq "ttf") { "$fontName (TrueType)" } else { $fontName }

        # Remove font registry entry
        Remove-ItemProperty -Path $fontRegistryKey -Name $registryName -ErrorAction SilentlyContinue


        # Remove font file from Fonts directory
        $installedFontFile = "$fontDest\$($fontFile.Name)"
        if (Test-Path -Path $installedFontFile) {
            Remove-Item -Path $installedFontFile -Force -ErrorAction SilentlyContinue
            Log-Message "Uninstalled font: $fontName (Type: $fontType)"
        } else {
            Log-Message "Font file not found for uninstallation: $fontName (Type: $fontType)"
        }
    }
}

# Function to display progress
function Show-Progress {
    param (
        [int]$current,
        [int]$total
    )
    $percentComplete = [math]::Round(($current / $total) * 100)
    Write-Progress -Activity "Installing Fonts" -Status "$percentComplete% Complete" -PercentComplete $percentComplete
}

# Main execution block
try {
    Log-Message "Starting font installation process..."

    # Check if fonts directory exists
    if (-not (Test-Path -Path $fontsPath)) {
        throw "Fonts directory not found: $fontsPath"
    }

    # Get all unique font files with priority to .otf
    $fontFiles = Get-UniqueFonts -fontsPath $fontsPath

    if ($fontFiles.Count -eq 0) {
        Log-Message "No font files found in the specified directory."
    } else {
        $totalFonts = $fontFiles.Count
        $currentFont = 0

        foreach ($fontFile in $fontFiles) {
            $currentFont++
            Show-Progress -current $currentFont -total $totalFonts
            Install-Font -fontFile $fontFile
        }
    }

    Log-Message "Font installation process completed."

    # Uncomment the following lines to enable font uninstallation
    # $uninstall = Read-Host "Do you want to uninstall the fonts? (Y/N)"
    # if ($uninstall -eq "Y") {
    #     Log-Message "Starting font uninstallation process..."
    #     Uninstall-Fonts -fontsPath $fontsPath
    #     Log-Message "Font uninstallation process completed."
    # }

} catch {
    Log-Message "An error occurred during script execution: $_"
} finally {
    # Clear the progress bar
    Write-Progress -Activity "Installing Fonts" -Completed
    Stop-Transcript

}

