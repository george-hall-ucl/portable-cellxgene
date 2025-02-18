if [ $# -eq 0 ]
then
    echo "Drop a folder here..."
    exit 0
fi

DATA_DIR=$1

source pcxg_conda_env_MacOS/bin/activate

export CELLXGENE_DATA="$DATA_DIR"
export CELLXGENE_LOCATION="pcxg_conda_env_MacOS/bin/cellxgene"
export GATEWAY_ENABLE_ANNOTATIONS=1
export GATEWAY_ENABLE_GENE_SETS=1
export GATEWAY_LOG_LEVEL="WARNING" # Decrease verbosity

sleep 2 && open http://127.0.0.1:5005/portable_home.html &
cellxgene-gateway

source pcxg_conda_env_MacOS/bin/deactivate
