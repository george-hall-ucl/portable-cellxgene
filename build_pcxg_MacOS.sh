# Copyright (C) 2024-2025 University College London
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

PARAMS=("<CONDA_ENV_TAR_GZ>" "<APP_TEMPLATE_PATH>" "<LAUNCH_CELLXGENE_SH>")
NUM_PARAMS="${#PARAMS[@]}"

if [ "$#" -ne "${NUM_PARAMS}" ]; then
  echo '"$0": incorrect number of arguments'
  echo 'usage: sh "$0" "${PARAMS[*]}"'
  exit 1
fi

CONDA_ENV_TAR_GZ=$1
APP_TEMPLATE_PATH=$2
LAUNCH_CELLXGENE_SH=$3
APP_NAME="Portable-CELLxGENE.app"
cp -r "${APP_TEMPLATE_PATH}" "${APP_NAME}"

# Download latest packed conda environment from
# https://github.com/george-hall-ucl/Portable-CELLxGENE-assets/releases
CONDA_ENV_NAME="pcxg_conda_env_MacOS"
CONDA_ENV_PATH="${APP_NAME}/Contents/Resources/${CONDA_ENV_NAME}"
mkdir -p "${CONDA_ENV_PATH}" && tar --directory "${CONDA_ENV_PATH}" -xzvf "${CONDA_ENV_TAR_GZ}"

echo "Copying launch script"
LAUNCH_CELLXGENE_SH_PATH_IN_APP="${APP_NAME}/Contents/Resources/script"
cp "${LAUNCH_CELLXGENE_SH}" "${LAUNCH_CELLXGENE_SH_PATH_IN_APP}"
chmod +x "${LAUNCH_CELLXGENE_SH_PATH_IN_APP}"

echo "Build completed successfully!"
echo "To release, sign and bundle the .app into a .dmg (only main developers)."
