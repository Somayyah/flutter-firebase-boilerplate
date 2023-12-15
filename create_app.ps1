# Ask for the Flutter project name
$projectName = Read-Host "Enter the name for your Flutter project"
$projectName = $projectName.ToLower().Replace(" ", "_")

# Ask for the base package name
$basePackageName = Read-Host "Enter the base package name (default: com.example)"
if ([string]::IsNullOrWhiteSpace($basePackageName)) {
    $basePackageName = "com.example"
}

# Generate the complete package name
$packageName = $basePackageName + "." + $projectName

# Create a new Flutter project
flutter create $projectName

# Change directory to the new project
Set-Location $projectName

# Setup Firebase using flutterfire CLI
flutterfire configure

# Update AndroidManifest.xml
$androidManifestPath = "android/app/src/main/AndroidManifest.xml"
(Get-Content $androidManifestPath) -replace 'package="com.example.appname"', "package=`"$packageName`"" | Set-Content $androidManifestPath

# Update build.gradle
$buildGradlePath = "android/app/build.gradle"
(Get-Content $buildGradlePath) -replace 'applicationId "com.example.appname"', "applicationId `"$packageName`"" | Set-Content $buildGradlePath

# Print the package name for Firebase setup
Write-Host "Use this package name to set up your Firebase project: $packageName"

# Wait for the user to paste google-services.json content
echo "Please paste the contents of your google-services.json file here, then press Enter:"
$googleServicesJson = Read-Host
$googleServicesJson | Out-File "android/app/google-services.json"

# Optional: Initialize Git repository
git init
git add .
git commit -m "Initial project setup with script"

# End of the script
Write-Host "Flutter project setup is complete!"