#!/bin/bash

# Ask for the Flutter project name
read -p "Enter the name for your Flutter project: " projectName
# Convert to lowercase and replace spaces with underscores
projectName=$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Create a new Flutter project
flutter create $projectName

# Change directory to the new project
cd $projectName

# Setup Firebase using flutterfire CLI
flutterfire configure

# Modify project-level build.gradle
projectBuildGradle="android/build.gradle"
sed -i '/classpath "com.android.tools.build:gradle:.*/a \ \ \ \ classpath "com.google.gms:google-services:4.4.0"\n\ \ \ \ classpath "com.google.firebase:firebase-crashlytics-gradle:2.9.9"\n\ \ \ \ classpath "com.google.firebase:firebase-appdistribution-gradle:4.0.1"\n\ \ \ \ classpath "com.google.firebase:perf-plugin:1.4.2"' $projectBuildGradle

# Modify app-level build.gradle
appBuildGradle="android/app/build.gradle"
sed -i '/id "com.android.application"/a \ \ \ \ id "com.google.gms.google-services"\n\ \ \ \ id "com.google.firebase.appdistribution"\n\ \ \ \ id "com.google.firebase.crashlytics"\n\ \ \ \ id "com.google.firebase.firebase-perf"' $appBuildGradle

# Ask the user to paste the contents of google-services.json
echo "Please paste the contents of your google-services.json file here, then press Ctrl-D:"
cat > android/app/google-services.json

# Define the base directory (lib folder)
baseDir="./lib"

# Define and create the folder structure
folders=(
    "$baseDir/assets"
    "$baseDir/auth"
    "$baseDir/firestoredb"
    "$baseDir/pages"
    "$baseDir/theming"
    "$baseDir/widgets"
)

for folder in "${folders[@]}"; do
    mkdir -p $folder
done

# GitHub repository base URL for raw content
repoBaseURL="https://raw.githubusercontent.com/Somayyah/flutter-firebase-boilerplate/main"

# Function to fetch file content from GitHub and write to the local file
populate_file_from_github() {
    localFilePath=$1
    githubFilePath=$2
    curl -s $repoBaseURL$githubFilePath -o $localFilePath
}

# File paths (relative to the lib directory) to populate
filePaths=(
    "/pages/mainscreen.dart"
    "/auth/signin.dart"
    "/auth/signup.dart"
    "/firebase_options.dart"
    "/firestoredb/user_repository.dart"
    "/functionality.dart"
    "/main.dart"
    "/pages/dashboard.dart"
    "/pages/feedback-support.dart"
    "/pages/onboarding.dart"
    "/pages/payment.dart"
    "/pages/settings.dart"
    "/pages/signin-up.dart"
    "/pages/splash.dart"
    "/theming/borders.dart"
    "/theming/colors.dart"
    "/theming/fonts.dart"
    "/theming/icons.dart"
    "/widgets/application.dart"
    "/widgets/app_settings.dart"
    "/widgets/buttons.dart"
    "/widgets/card.dart"
    "/widgets/user_profile.dart"
)

# Populate each file
for filePath in "${filePaths[@]}"; do
    localFilePath="$baseDir${filePath//\//\/}"
    githubFilePath="/lib$filePath"
    populate_file_from_github $localFilePath $githubFilePath
done

# Optional: Initialize Git repository
git init
git add .
git commit -m "Initial project setup with script"

# End of the script
echo "Flutter project setup is complete!"
