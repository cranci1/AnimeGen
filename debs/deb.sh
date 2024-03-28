#!/bin/bash

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

command -v xcodebuild >/dev/null 2>&1 || { error_exit "xcodebuild is required but not found. Please install Xcode command line tools."; }

read -p "Enter version number: " version

xcodebuild -project AnimeGen.xcodeproj -scheme AnimeGen -sdk iphoneos -configuration Release CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO -derivedDataPath build || error_exit "Failed to build the project."

package_dir="me.cranci.animegen_${version}_iphoneos-arm"
mkdir -p "$package_dir/DEBIAN"
mkdir -p "$package_dir/Applications"

cp -r "build/Build/Products/Release-iphoneos/AnimeGen.app" "$package_dir/Applications/" || error_exit "Failed to copy the built app."

control_file="$package_dir/DEBIAN/control"
cat << EOF > "$control_file" || error_exit "Failed to create control file."
Package: me.cranci.AnimeGen
Name: AnimeGen
Icon: https://github.com/cranci1/AnimeGen/blob/main/AnimeGen/Assets.xcassets/AppIcon.appiconset/04C0C479-EBC2-4BC3-98F4-89DA7AAEA2F5.png?raw=true
Depends: firmware (>= 13.0)
Architecture: iphoneos-arm
Section: Applications
Sileodepiction: https://repo.cranci.xyz/depictions/native/AG/me.cranci.animegen-rootless.json
Version: ${version}
Maintainer: cranci <cranci@null.net>
Author: cranci
Installed-Size: $(du -ks "$package_dir/Applications" | cut -f 1)
EOF

chmod -R 0755 "$package_dir/DEBIAN"

dpkg-deb --build "$package_dir" || error_exit "Failed to build .deb package."

ipa_dir="Payload"
mkdir -p "$ipa_dir"

cp -r "build/Build/Products/Release-iphoneos/AnimeGen.app" "$ipa_dir/" || error_exit "Failed to copy the app to Payload directory."

ipa_file="AnimeGen_${version}.ipa"
zip -r "$ipa_file" "$ipa_dir" || error_exit "Failed to create IPA file."

rm -rf build "$ipa_dir" "$package_dir"

echo "Build and packaging completed successfully: $ipa_file"
