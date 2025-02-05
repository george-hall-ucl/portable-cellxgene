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

# Need conda-pack installed

ENV_NAME=$1
conda create -y -n "$ENV_NAME" python=3.11

# Activate new conda env
eval "$(conda shell.bash hook)"
conda activate "$ENV_NAME"

# Install modified version of CELLxGENE-Gateway
pip install --no-cache-dir git+https://github.com/george-hall-ucl/modified_cellxgene_gateway.git
patch $CONDA_PREFIX/lib/python3.11/site-packages/server/common/compute/estimate_distribution.py < estimate_distribution_jit_removal_patch.txt

conda deactivate

conda activate conda_pack
conda-pack --output "${ENV_NAME}".tar.gz --name "${ENV_NAME}"
conda deactivate

# Upload .tar.gz file to
# https://github.com/george-hall-ucl/Portable-CELLxGENE-assets/releases
