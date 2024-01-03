# Prerequisites:
# conda-pack. Can be installed with `conda install conda-pack`.
# Platypus. Can be installed with `brew install --cask platypus`. The
#   commandline tools must then be installed via Platypus' settings menu.

PARAMS=("<conda_env_dir>" "<icon_path>" "<launch_cellxgene.sh>")
NUM_PARAMS=${#PARAMS[@]}

if [ $# -ne ${NUM_PARAMS} ]; then
  echo "$0: not enough arguments"
  echo "usage: sh $0 ${PARAMS[*]}"
  exit 1
fi

CONDA_ENV_DIR=$(basename $1)
ICON_PATH=$2
LAUNCH_CELLXGENE_SH=$3

UNIX_TIME=$(date +%s)

OUT_DIR="Portable_CELLxGENE_Build_Dir_${UNIX_TIME}"
APP_NAME="Portable-CELLxGENE"
echo "Building ${APP_NAME} in ${OUT_DIR}"

if [ -d ${OUT_DIR} ]; then
  echo "Directory '${OUT_DIR}' exists."
  echo "To prevent accidents, I won't delete it. You must rename or move it."
  echo "Build failed. Exiting."
  exit 1
fi

mkdir ${OUT_DIR}
cd ${OUT_DIR}

conda-pack --ignore-missing-files --ignore-editable-packages --prefix ../${CONDA_ENV_DIR}

PACKED_CONDA_ENV_NAME="cellxgene_portable_conda_env"
mv "${CONDA_ENV_DIR}.tar.gz" "${PACKED_CONDA_ENV_NAME}.tar.gz"
mkdir ${PACKED_CONDA_ENV_NAME} && tar --directory ${PACKED_CONDA_ENV_NAME} -xzvf "${PACKED_CONDA_ENV_NAME}.tar.gz"

echo "Copying launch script"
cp ../${LAUNCH_CELLXGENE_SH} launch_cellxgene.sh

VERSION=$(cat "${PACKED_CONDA_ENV_NAME}/lib/python3.7/site-packages/cellxgene_gateway/static/js/version_number.js")
VERSION=$(echo ${VERSION} | cut -c 17- | rev | cut -c 4- | rev)

echo "Building .app with Platypus"
platypus \
    --name="${APP_NAME}" \
    --interface-type="Droplet" \
    --file-prompt \
    --app-icon="../${ICON_PATH}" \
    --bundle-identifier="org.georgehall.portable-cellxgene" \
    --author="George Hall (University College London)" \
    --app-version="${VERSION}" \
    --droppable \
    --uniform-type-identifiers="public.folder" \
    --bundled-file="${PACKED_CONDA_ENV_NAME}" \
    launch_cellxgene.sh

echo "Build completed successfully!"
echo "To release, sign and bundle the .app into a .dmg (only main developers)."
