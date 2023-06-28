source cellxgene_env/bin/activate
export CELLXGENE_DATA="cellxgene_datasets"
export CELLXGENE_LOCATION="cellxgene_env/bin/cellxgene"
sleep 1 && open http://127.0.0.1:5005/filecrawl.html &
cellxgene-gateway
source cellxgene_env/bin/deactivate
