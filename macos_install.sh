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

# Package this script with Platypus with the following options:
#   Script Type: /bin/bash
#   Interface: Progress Bar

TMP_DIR="$(mktemp -d -t Portable-CELLxGENE_Installation)"
ARCHITECTURE="$(arch)"

if [[ "${ARCHITECTURE}" == "arm"* ]]; then
    ARCH_SUFFIX="apple-silicon"
else
    ARCH_SUFFIX="intel"
fi
DOWNLOAD_URL="https://github.com/george-hall-ucl/portable-cellxgene/releases/latest/download/Install-Portable-CELLxGENE-MacOS-${ARCH_SUFFIX}.dmg"
DMG_NAME="Install-Portable-CELLxGENE-MacOS.dmg"
DOWNLOADED_PATH="${TMP_DIR}/${DMG_NAME}"
curl -L --progress-bar ${DOWNLOAD_URL} -o ${DOWNLOADED_PATH} && open ${DOWNLOADED_PATH}
