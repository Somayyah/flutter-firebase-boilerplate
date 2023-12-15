#!/bin/bash

# Ask for the Flutter project name
read -p "Enter the name for your Flutter project: " projectName

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

# Define and create the folder structure
folders=(
    "lib/assets"
    "lib/auth"
    "lib/firestoredb"
    "lib/pages"
    "lib/theming"
    "lib/widgets"
)

for folder in "${folders[@]}"; do
    mkdir -p $folder
done

# Define and create the file structure
files=(
    "lib/auth/signin.dart"
    "lib/auth/signup.dart"
    "lib/firebase_options.dart"
    "lib/firestoredb/user_repository.dart"
    "lib/functionality.dart"
    "lib/main.dart"
    "lib/pages/dashboard.dart"
    "lib/pages/feedback-support.dart"
    "lib/pages/mainscreen.dart"
    "lib/pages/onboarding.dart"
    "lib/pages/payment.dart"
    "lib/pages/settings.dart"
    "lib/pages/signin-up.dart"
    "lib/pages/splash.dart"
    "lib/theming/borders.dart"
    "lib/theming/colors.dart"
    "lib/theming/fonts.dart"
    "lib/theming/icons.dart"
    "lib/widgets/application.dart"
    "lib/widgets/app_settings.dart"
    "lib/widgets/buttons.dart"
    "lib/widgets/card.dart"
    "lib/widgets/user_profile.dart"
)

for file in "${files[@]}"; do
    touch $file
done

# Optional: Initialize Git repository
git init
git add .
git commit -m "Initial project setup with script"

# End of the script
echo "Flutter project setup is complete!"
