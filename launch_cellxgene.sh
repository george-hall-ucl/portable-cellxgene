if [ $# -eq 0 ]
then
    echo "Drop a folder here..."
    exit 0
fi

DATA_DIR=$1

source cellxgene_portable_conda_env/bin/activate

export CELLXGENE_DATA=$DATA_DIR
export CELLXGENE_LOCATION="./spoof_cmd.sh"
export GATEWAY_ENABLE_ANNOTATIONS=1
export GATEWAY_LOG_LEVEL="WARNING" # Decrease verbosity

sleep 1 && open http://127.0.0.1:5005/filecrawl.html &
cellxgene-gateway

source cellxgene_portable_conda_env/bin/deactivate
