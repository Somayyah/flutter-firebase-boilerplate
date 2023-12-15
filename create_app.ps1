# Ask for the Flutter project name
$projectName = Read-Host "Enter the name for your Flutter project"
$projectName = Prompt-ForInput -PromptText "Enter the name for your Flutter project" -DefaultValue ""
$projectName = $projectName.ToLower().Replace(" ", "_")

flutter create $projectName

Set-Location $projectName

$basePackageName = Prompt-ForInput -PromptText "Enter the base package name (default: com.example)" -DefaultValue "com.example"
$packageName = $basePackageName + "." + $projectName

# Setup Firebase using flutterfire CLI
flutterfire configure

Write-Host "Use this package name to set up your Firebase project: $packageName"

Write-Host "Please place your google-services.json file in the project directory and press Enter to continue..."
Read-Host -Prompt "Press Enter after you have placed the file"

$googleServicesPath = Join-Path -Path $PWD.Path -ChildPath "google-services.json"
if (Test-Path $googleServicesPath) {
    Copy-Item -Path $googleServicesPath -Destination "android/app/google-services.json"
} else {
    Write-Host "google-services.json not found. Please make sure the file is in the project directory and try again."
    exit
}

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

# GitHub repository base URL for raw content
$repoBaseURL = "https://raw.githubusercontent.com/Somayyah/flutter-firebase-boilerplate/main"

# Function to fetch file content from GitHub and write to the local file
function PopulateFileFromGitHub($localFilePath, $githubFilePath) {
    $fullGitHubPath = $repoBaseURL + $githubFilePath
    $content = Invoke-WebRequest -Uri $fullGitHubPath -UseBasicParsing
    $content.Content | Out-File -FilePath $localFilePath
}

# File paths (relative to the lib directory) to populate
$filePaths = @(
    "/pages/mainscreen.dart",
    "/auth/signin.dart",
    "/auth/signup.dart",
    "/firebase_options.dart",
    "/firestoredb/user_repository.dart",
    "/functionality.dart",
    "/main.dart",
    "/pages/dashboard.dart",
    "/pages/feedback-support.dart",
    "/pages/onboarding.dart",
    "/pages/payment.dart",
    "/pages/settings.dart",
    "/pages/signin-up.dart",
    "/pages/splash.dart",
    "/theming/borders.dart",
    "/theming/colors.dart",
    "/theming/fonts.dart",
    "/theming/icons.dart",
    "/widgets/application.dart",
    "/widgets/app_settings.dart",
    "/widgets/buttons.dart",
    "/widgets/card.dart",
    "/widgets/user_profile.dart"
)

# Populate each file
foreach ($filePath in $filePaths) {
    $localFilePath = Join-Path $baseDir $filePath.Replace('/', '\')
    $githubFilePath = "/lib" + $filePath

    PopulateFileFromGitHub -localFilePath $localFilePath -githubFilePath $githubFilePath
}

# Optional: Initialize Git repository
git init
git add .
git commit -m "Initial project setup with script"

# End of the script
Write-Host "Flutter project setup is complete!"
