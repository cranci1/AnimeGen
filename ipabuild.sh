#!/bin/bash

set -e

WORKING_LOCATION="$(pwd)"
APPLICATION_NAME="AnimeGen"
BUILD_DIR="$WORKING_LOCATION/build"
DERIVED_DATA_DIR="$BUILD_DIR/DerivedDataApp"
DD_APP_PATH="$DERIVED_DATA_DIR/Build/Products/Release-iphoneos/$APPLICATION_NAME.app"
TARGET_APP="$BUILD_DIR/$APPLICATION_NAME.app"
PAYLOAD_DIR="$WORKING_LOCATION/Payload"

command -v xcodebuild >/dev/null 2>&1 || { echo >&2 "xcodebuild is required but it's not installed. Aborting."; exit 1; }
command -v codesign >/dev/null 2>&1 || { echo >&2 "codesign is required but it's not installed. Aborting."; exit 1; }
command -v zip >/dev/null 2>&1 || { echo >&2 "zip is required but it's not installed. Aborting."; exit 1; }

mkdir -p "$BUILD_DIR"

xcodebuild -project "$WORKING_LOCATION/$APPLICATION_NAME.xcodeproj" \
    -scheme "$APPLICATION_NAME" \
    -configuration Release \
    -derivedDataPath "$DERIVED_DATA_DIR" \
    -destination 'generic/platform=iOS' \
    clean build \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED=NO

cp -r "$DD_APP_PATH" "$TARGET_APP"

codesign --remove "$TARGET_APP"
rm -rf "$TARGET_APP/_CodeSignature" "$TARGET_APP/embedded.mobileprovision"

mkdir -p "$PAYLOAD_DIR"
cp -r "$TARGET_APP" "$PAYLOAD_DIR/$APPLICATION_NAME.app"

strip "$PAYLOAD_DIR/$APPLICATION_NAME.app/$APPLICATION_NAME"

zip -vr "$WORKING_LOCATION/$APPLICATION_NAME.ipa" "$PAYLOAD_DIR"

rm -rf "$TARGET_APP" "$PAYLOAD_DIR"

echo "IPA creation completed successfully: $WORKING_LOCATION/$APPLICATION_NAME.ipa"