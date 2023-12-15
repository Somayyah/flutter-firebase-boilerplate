# Ask for the Flutter project name
$projectName = Read-Host "Enter the name for your Flutter project"

# Create a new Flutter project
flutter create $projectName

# Change directory to the new project
Set-Location $projectName

# Setup Firebase using flutterfire CLI
flutterfire configure

# Modify project-level build.gradle
$projectBuildGradle = "android/build.gradle"
$projectGradleContent = Get-Content $projectBuildGradle
$firebaseDependencies = @(
    "classpath 'com.google.gms:google-services:4.4.0'",
    "classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'",
    "classpath 'com.google.firebase:firebase-appdistribution-gradle:4.0.1'",
    "classpath 'com.google.firebase:perf-plugin:1.4.2'"
)
$projectGradleContent = $projectGradleContent -replace '(classpath "com.android.tools.build:gradle:.*)', ('$1' + [Environment]::NewLine + ($firebaseDependencies -join [Environment]::NewLine))
$projectGradleContent | Set-Content $projectBuildGradle

# Modify app-level build.gradle
$appBuildGradle = "android/app/build.gradle"
$appGradleContent = Get-Content $appBuildGradle
$firebasePluginIDs = @(
    "id 'com.google.gms.google-services'",
    "id 'com.google.firebase.appdistribution'",
    "id 'com.google.firebase.crashlytics'",
    "id 'com.google.firebase.firebase-perf'"
)
$appGradleContent = $appGradleContent -replace '(id "com.android.application")', ('$1' + [Environment]::NewLine + ($firebasePluginIDs -join [Environment]::NewLine))
$appGradleContent | Set-Content $appBuildGradle

# Ask the user to paste the contents of google-services.json
echo "Please paste the contents of your google-services.json file here, then press Enter:"
$googleServicesJson = Read-Host
$googleServicesJson | Out-File "android/app/google-services.json"

# Define the base directory (lib folder)
$baseDir = ".\lib"

# Define and create the folder structure
$folders = @(
    "$baseDir\assets",
    "$baseDir\auth",
    "$baseDir\firestoredb",
    "$baseDir\pages",
    "$baseDir\theming",
    "$baseDir\widgets"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force
}

# Define and create the file structure
$files = @{
    "$baseDir\auth\signin.dart" = $null;
    "$baseDir\auth\signup.dart" = $null;
    "$baseDir\firebase_options.dart" = $null;
    "$baseDir\firestoredb\user_repository.dart" = $null;
    "$baseDir\functionality.dart" = $null;
    "$baseDir\main.dart" = $null;
    "$baseDir\pages\dashboard.dart" = $null;
    "$baseDir\pages\feedback-support.dart" = $null;
    "$baseDir\pages\mainscreen.dart" = $null;
    "$baseDir\pages\onboarding.dart" = $null;
    "$baseDir\pages\payment.dart" = $null;
    "$baseDir\pages\settings.dart" = $null;
    "$baseDir\pages\signin-up.dart" = $null;
    "$baseDir\pages\splash.dart" = $null;
    "$baseDir\theming\borders.dart" = $null;
    "$baseDir\theming\colors.dart" = $null;
    "$baseDir\theming\fonts.dart" = $null;
    "$baseDir\theming\icons.dart" = $null;
    "$baseDir\widgets\application.dart" = $null;
    "$baseDir\widgets\app_settings.dart" = $null;
    "$baseDir\widgets\buttons.dart" = $null;
    "$baseDir\widgets\card.dart" = $null;
    "$baseDir\widgets\user_profile.dart" = $null;
}

foreach ($file in $files.Keys) {
    New-Item -ItemType File -Path $file -Force
}

# Optional: Initialize Git repository
git init
git add .
git commit -m "Initial project setup with script"

# End of the script
Write-Host "Flutter project setup is complete!"
