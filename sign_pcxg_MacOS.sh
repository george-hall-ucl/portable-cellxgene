# Copyright (C) 2024 University College London
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Prerequisites:
#   * appdmg: Can be installed with `npm install -g appdmg`

# Run from directory containing Portable-CELLxGENE.app

PARAMS=("<DMG_BACKGROUND_PNG>" "<NOTARYTOOL_KEYCHAIN_PROFILE>" "<DEV_ID_APP_CERT>")
NUM_PARAMS="${#PARAMS[@]}"

if [ "$#" -ne "${NUM_PARAMS}" ]; then
  echo '"$0": incorrect number of arguments'
  echo 'usage: sh "$0" "${PARAMS[*]}"'
  exit 1
fi

# The background png is in the images directory
DMG_BACKGROUND_PNG=$1

# Name of keychain profile with app-specific password for notarization (need to
# modify to match app-specific password)
NOTARYTOOL_KEYCHAIN_PROFILE=$2

# Name of Developer ID Application certificate
DEV_ID_APP_CERT="$3"

echo "Step 1: Signing the resources inside the app"
cd Portable-CELLxGENE.app/Contents/Resources/pcxg_conda_env_MacOS
find bin -type f | xargs -n1 codesign -f -o runtime --timestamp --entitlements ../../../../../entitlements.plist --sign "${DEV_ID_APP_CERT}"
find bin -type f | xargs -n1 codesign -f -o runtime --timestamp --entitlements ../../../../../entitlements.plist --sign "${DEV_ID_APP_CERT}"

echo ""

cd ../../../../

echo "Step 2: Signing the app itself"
codesign -f -o runtime --timestamp --entitlements ../entitlements.plist --sign "${DEV_ID_APP_CERT}" Portable-CELLxGENE.app

echo "Step 3: Turning the app into a .dmg for notarization"
cat << EOF > appdmg_config.json
{
  "title": "Install-Portable-CxG",
  "background": "${DMG_BACKGROUND_PNG}",
  "contents": [
    { "x": 220, "y": 100, "type": "file", "path": "Portable-CELLxGENE.app" },
    { "x": 410, "y": 100, "type": "link", "path": "/Applications" }
  ]
}
EOF

DMG_NAME="Install-Portable-CELLxGENE-MacOS.dmg"
rm -f "$DMG_NAME"
appdmg appdmg_config.json "$DMG_NAME"
rm -f appdmg_config.json

echo "Step 4: Signing the .dmg for notarization"
codesign -f --sign "${DEV_ID_APP_CERT}" --entitlements ../entitlements.plist --timestamp "$DMG_NAME" 2> /dev/null

echo "Step 5: Submitting for notarization"
xcrun notarytool submit "$DMG_NAME" --keychain-profile ${NOTARYTOOL_KEYCHAIN_PROFILE} --wait

echo "Step 6: Stapling ticket to .dmg"
xcrun stapler staple "$DMG_NAME"

echo "Step 7: Verifying notarization of .dmg"
spctl -a -vv -t install "$DMG_NAME"
