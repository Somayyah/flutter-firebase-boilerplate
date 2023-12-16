#!/bin/bash

# Function to prompt for input with a default value
prompt_for_input() {
    local prompt_text=$1
    local default_value=$2
    local input

    while true; do
        read -p "$prompt_text" input
        if [[ -z "$input" ]] && [[ -n "$default_value" ]]; then
            input=$default_value
        fi
        if [[ -n "$input" ]]; then
            break
        fi
    done

    echo "$input"
}

# Get the project name
project_name=$(prompt_for_input "Enter the name for your Flutter project: " "")
project_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')

# Create Flutter project
flutter create "$project_name"
cd "$project_name" || exit

# Get the base package name
base_package_name=$(prompt_for_input "Enter the base package name (default: com.example): " "com.example")
package_name="${base_package_name}.${project_name}"

# Activate and rename package
flutter pub global activate rename
flutter pub global run rename --bundleId "$package_name"

# FlutterFire configuration
flutterfire configure

echo "Use this package name to set up your Firebase project: $package_name"

# Define the base directory (lib folder)
base_dir="./lib"

# Define and create the folder structure
folders=(
    "$base_dir/assets"
    "$base_dir/auth"
    "$base_dir/firestoredb"
    "$base_dir/pages"
    "$base_dir/theming"
    "$base_dir/widgets"
)

for folder in "${folders[@]}"; do
    mkdir -p "$folder"
done

# GitHub repository base URL for raw content
repo_base_url="https://raw.githubusercontent.com/Somayyah/flutter-firebase-boilerplate/main/lib/"

# Function to fetch file content from GitHub and write to the local file
populate_file_from_github() {
    local local_file_path=$1
    local github_file_path=$2
    local full_github_path="${repo_base_url}${github_file_path}"

    echo "Attempting to download from: $full_github_path"
    curl -o "$local_file_path" "$full_github_path"
}

# File paths (relative to the lib directory) to populate
file_paths=(
    "auth/signin.dart"
    "auth/signup.dart"
    "firestoredb/user_repository.dart"
    "pages/dashboard.dart"
    "pages/feedback-support.dart"
    "pages/mainscreen.dart"
    "pages/onboarding.dart"
    "pages/payment.dart"
    "pages/settings.dart"
    "pages/signin-up.dart"
    "pages/splash.dart"
    "theming/borders.dart"
    "theming/colors.dart"
    "theming/fonts.dart"
    "theming/icons.dart"
    "widgets/app_settings.dart"
    "widgets/buttons.dart"
    "widgets/card.dart"
    "widgets/user_profile.dart"
)

# Populate each file
for file_path in "${file_paths[@]}"; do
    local_file_path="${base_dir}/${file_path}"
    populate_file_from_github "$local_file_path" "$file_path"
done

# Git setup
git init
git add .
git commit -m "Initial project setup with script"

echo "Flutter project setup is complete!"
