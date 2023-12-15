# Ask for the Flutter project name
$projectName = Read-Host "Enter the name for your Flutter project"
$projectName = $projectName.ToLower().Replace(" ", "_")

# Create a new Flutter project
flutter create $projectName

# Change directory to the new project
Set-Location $projectName

# Ask for the base package name with a default option
$basePackageName = Read-Host "Enter the base package name (default: com.example)"
if ([string]::IsNullOrWhiteSpace($basePackageName)) {
    $basePackageName = "com.example"
}

# Generate the complete package name
$packageName = $basePackageName + "." + $projectName

# Activate and use the rename package
flutter pub global activate rename
rename setBundleId --targets android --value $packageName

# Setup Firebase using flutterfire CLI
flutterfire configure

# Print the package name for Firebase setup
Write-Host "Use this package name to set up your Firebase project: $packageName"

# Instruct the user to place google-services.json in the project directory
Write-Host "Please place your google-services.json file in the project directory and press Enter to continue..."
Read-Host -Prompt "Press Enter after you have placed the file"

# Copy google-services.json to the correct location
$googleServicesPath = Join-Path -Path $PWD.Path -ChildPath "google-services.json"
if (Test-Path $googleServicesPath) {
    Copy-Item -Path $googleServicesPath -Destination "android/app/google-services.json"
} else {
    Write-Host "google-services.json not found. Please make sure the file is in the project directory and try again."
    exit
}
# Optional: Initialize Git repository
git init
git add .
git commit -m "Initial project setup with script"

# End of the script
Write-Host "Flutter project setup is complete!"
