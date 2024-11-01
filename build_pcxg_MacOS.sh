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
#   * conda-pack. Can be installed with `conda install conda-pack`.
#   * Platypus. Can be installed with `brew install --cask platypus`. The
#       commandline tools must then be installed via Platypus' settings menu.

PARAMS=("<CONDA_ENV_DIR>" "<ICON_PATH>" "<LAUNCH_CELLXGENE_SH>")
NUM_PARAMS="${#PARAMS[@]}"

if [ "$#" -ne "${NUM_PARAMS}" ]; then
  echo '"$0": incorrect number of arguments'
  echo 'usage: sh "$0" "${PARAMS[*]}"'
  exit 1
fi

CONDA_ENV_TAR_GZ=$1
ICON_PATH=$2
LAUNCH_CELLXGENE_SH=$3

APP_NAME="Portable-CELLxGENE"
echo "Building ${APP_NAME}"

# Download latest packed conda environment from
# https://github.com/george-hall-ucl/Portable-CELLxGENE-assets/releases and set
# PACKED_CONDA_ENV_NAME to the base filename (i.e. the part before ".tar.gz").
PACKED_CONDA_ENV_NAME="pcxg_conda_env_MacOS"
mkdir "${PACKED_CONDA_ENV_NAME}" && tar --directory "${PACKED_CONDA_ENV_NAME}" -xzvf "${CONDA_ENV_TAR_GZ}"

echo "Copying launch script"
cp "${LAUNCH_CELLXGENE_SH}" launch_cellxgene.sh

VERSION=$(cat "${PACKED_CONDA_ENV_NAME}/lib/python3.7/site-packages/cellxgene_gateway/static/js/version_number.js")
VERSION=$(echo "${VERSION}" | cut -c 17- | rev | cut -c 4- | rev)

echo "Building .app with Platypus"
platypus \
    --name="${APP_NAME}" \
    --interface-type="Droplet" \
    --file-prompt \
    --app-icon="${ICON_PATH}" \
    --bundle-identifier="org.georgehall.portable-cellxgene" \
    --author="George Hall (University College London)" \
    --app-version="${VERSION}" \
    --droppable \
    --uniform-type-identifiers="public.folder" \
    --bundled-file="${PACKED_CONDA_ENV_NAME}" \
    launch_cellxgene.sh

echo "Build completed successfully!"
echo "To release, sign and bundle the .app into a .dmg (only main developers)."
