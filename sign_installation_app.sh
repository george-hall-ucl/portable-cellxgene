# Copyright (C) 2025 University College London
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

NOTARYTOOL_KEYCHAIN_PROFILE=$1
DEV_ID_APP_CERT=$2

APP_NAME="Install-Portable-CELLxGENE.app"
ZIP_NAME="Install-Portable-CELLxGENE.zip"

echo "Signing .app"
codesign -f -o runtime --timestamp --sign "${DEV_ID_APP_CERT}" ${APP_NAME}

echo "Creating .zip"
ditto -c -k --keepParent ${APP_NAME} ${ZIP_NAME}

echo "Signing .zip"
codesign -f --timestamp --sign "${DEV_ID_APP_CERT}" ${APP_NAME}

echo "Submitting .zip for notarization"
xcrun notarytool submit ${ZIP_NAME} --keychain-profile ${NOTARYTOOL_KEYCHAIN_PROFILE} --wait
