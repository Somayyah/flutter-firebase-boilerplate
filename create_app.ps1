function Prompt-ForInput {
    param (
        [string]$PromptText,
        [string]$DefaultValue
    )
    do {
        $input = Read-Host -Prompt $PromptText
        if ([string]::IsNullOrWhiteSpace($input) -and -not [string]::IsNullOrWhiteSpace($DefaultValue)) {
            $input = $DefaultValue
        }
    }
    while ([string]::IsNullOrWhiteSpace($input))
    return $input
}

$projectName = Prompt-ForInput -PromptText "Enter the name for your Flutter project" -DefaultValue ""
$projectName = $projectName.ToLower().Replace(" ", "_")

flutter create $projectName

Set-Location $projectName

$basePackageName = Prompt-ForInput -PromptText "Enter the base package name (default: com.example)" -DefaultValue "com.example"
$packageName = $basePackageName + "." + $projectName

flutter pub global activate rename
flutter pub global run rename --bundleId $packageName

flutterfire configure

Write-Host "Use this package name to set up your Firebase project: $packageName"

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
$repoBaseURL = "https://raw.githubusercontent.com/Somayyah/flutter-firebase-boilerplate/main/lib/"

# Function to fetch file content from GitHub and write to the local file
function PopulateFileFromGitHub($localFilePath, $githubFilePath) {
    $fullGitHubPath = $repoBaseURL + $githubFilePath
    Invoke-WebRequest -Uri $fullGitHubPath -OutFile $localFilePath
}

# File paths (relative to the lib directory) to populate
$filePaths = @(
    "assets",
    "auth/signin.dart",
    "auth/signup.dart",
    "firebase_options.dart",
    "firestoredb/user_repository.dart",
    "pages/dashboard.dart",
    "pages/feedback-support.dart",
    "pages/mainscreen.dart",
    "pages/onboarding.dart",
    "pages/payment.dart",
    "pages/settings.dart",
    "pages/signin-up.dart",
    "pages/splash.dart",
    "theming/borders.dart",
    "theming/colors.dart",
    "theming/fonts.dart",
    "theming/icons.dart",
    "widgets/application.dart",
    "widgets/app_settings.dart",
    "widgets/buttons.dart",
    "widgets/card.dart",
    "widgets/user_profile.dart"
)

# Populate each file
foreach ($filePath in $filePaths) {
    $localFilePath = Join-Path $baseDir $filePath.Replace('/', '\')
    PopulateFileFromGitHub -localFilePath $localFilePath -githubFilePath $filePath
}

# Additional steps for handling google-services.json and Git setup
Write-Host "Please place your google-services.json file in the project directory and press Enter to continue..."
Read-Host -Prompt "Press Enter after you have placed the file"

$googleServicesPath = Join-Path -Path $PWD.Path -ChildPath "google-services.json"
if (Test-Path $googleServicesPath) {
    Copy-Item -Path $googleServicesPath -Destination "android/app/google-services.json"
} else {
    Write-Host "google-services.json not found. Please make sure the file is in the project directory and try again."
    exit
}

git init
git add .
git commit -m "Initial project setup with script"

Write-Host "Flutter project setup is complete!"