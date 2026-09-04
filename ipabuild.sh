#!/bin/bash

set -e

cd "$(dirname "$0")"

WORKING_LOCATION="$(pwd)"
APPLICATION_NAME=AnimeGen

echo "==> Preparing build directory..."
rm -rf build
mkdir -p build
cd build

echo "==> Resolving Swift package dependencies..."
xcodebuild -resolvePackageDependencies -project "$WORKING_LOCATION/$APPLICATION_NAME.xcodeproj"

echo "==> Building $APPLICATION_NAME with xcodebuild..."
xcodebuild -project "$WORKING_LOCATION/$APPLICATION_NAME.xcodeproj" \
    -scheme "$APPLICATION_NAME" \
    -configuration Release \
    -derivedDataPath "$WORKING_LOCATION/build/DerivedDataApp" \
    -destination 'generic/platform=iOS' \
    build \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"

DD_APP_PATH="$WORKING_LOCATION/build/DerivedDataApp/Build/Products/Release-iphoneos/$APPLICATION_NAME.app"

if [ ! -d "$DD_APP_PATH" ]; then
    echo "Error: Build artifact $DD_APP_PATH not found!"
    exit 1
fi

TARGET_APP="$WORKING_LOCATION/build/$APPLICATION_NAME.app"
cp -R "$DD_APP_PATH" "$TARGET_APP"

echo "==> Cleaning signatures..."
codesign --remove "$TARGET_APP" 2>/dev/null || true
rm -rf "$TARGET_APP/_CodeSignature"
rm -rf "$TARGET_APP/embedded.mobileprovision"

echo "==> Packaging IPA..."
mkdir -p Payload
cp -R "$TARGET_APP" Payload/"$APPLICATION_NAME.app"

zip -qr "$APPLICATION_NAME.ipa" Payload
rm -rf "$TARGET_APP"
rm -rf Payload

echo "==> IPA build complete: $(pwd)/$APPLICATION_NAME.ipa"
ls -lh "$APPLICATION_NAME.ipa"