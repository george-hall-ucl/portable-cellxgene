#! /bin/sh

CSV_PATH=$(echo $@ | grep -o "\S*csv")
CSV_PATH_NO_EXT=${CSV_PATH%????}
ANNOTATIONS_FILE_NAME=$CSV_PATH_NO_EXT"_annotations.csv"
NEW_CMD="cellxgene_portable_conda_env/bin/cellxgene ""${@//--annotations-file/--annotations-file $ANNOTATIONS_FILE_NAME --gene-sets-file}"
$NEW_CMD
