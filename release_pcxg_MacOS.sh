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
#   * Platypus. Can be installed with `brew install --cask platypus`. The
#       commandline tools must then be installed via Platypus' settings menu.
#   * appdmg: Can be installed with `npm install -g appdmg`

PARAMS=("<BUILD_SCRIPT>" "SIGNING_SCRIPT" "<CONDA_ENV_DIR>" "<ICON_PATH>" "<LAUNCH_CELLXGENE_SH>" "<DMG_BACKGROUND_PNG>" "<NOTARYTOOL_KEYCHAIN_PROFILE>" "<DEV_ID_APP_CERT>")
NUM_PARAMS="${#PARAMS[@]}"

if [ "$#" -ne "${NUM_PARAMS}" ]; then
  echo '"$0": incorrect number of arguments'
  echo 'usage: sh "$0" "${PARAMS[*]}"'
  exit 1
fi

BUILD_SCRIPT="$1"
SIGNING_SCRIPT="$2"
CONDA_ENV_TAR_GZ="$3"
ICON_PATH="$4"
LAUNCH_CELLXGENE_SH="$5"
DMG_BACKGROUND_PNG="$6"
NOTARYTOOL_KEYCHAIN_PROFILE="$7"
DEV_ID_APP_CERT="$8"

UNIX_TIME=$(date +%s)

OUT_DIR="Portable_CELLxGENE_Build_Dir_${UNIX_TIME}"
if [ -d "${OUT_DIR}" ]; then
  echo "Directory '"${OUT_DIR}"' exists."
  echo "To prevent accidents, I won't delete it. You must rename or move it."
  echo "Build failed. Exiting."
  exit 1
fi

mkdir "${OUT_DIR}"
cd "${OUT_DIR}"

echo "RUNNING build_script_MacOS.sh"
sh ../"${BUILD_SCRIPT}" ../"${CONDA_ENV_TAR_GZ}" ../"${ICON_PATH}" ../"${LAUNCH_CELLXGENE_SH}"

echo "RUNNING sign_and_bundle_app.sh"
sh ../"${SIGNING_SCRIPT}" ../"${DMG_BACKGROUND_PNG}" "${NOTARYTOOL_KEYCHAIN_PROFILE}" "${DEV_ID_APP_CERT}"

echo "BUILD AND RELEASE PROCESS FINISHED."
