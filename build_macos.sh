#!/bin/zsh

# Generate Xcode project from Package.swift
swift package generate-xcodeproj

# Build the app for Release
xcodebuild -project IronApp.xcodeproj \
  -scheme IronAppScheme \
  -configuration Release \
  -derivedDataPath build/xcode

# The .app will appear under:
# build/xcode/Build/Products/Release/YourApp.app
