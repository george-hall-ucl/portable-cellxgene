This repository is a guide on how to create and run a portable, standalone
MacOS app with cellxgene for multiple datasets. Called `portable-cellxgene`,
this app bundles the datasets and a `cellxgene` conda environment to make it
easier to share cellxgene instances between users.

`portable-cellxgene` uses
[`cellxgene`](https://github.com/chanzuckerberg/cellxgene) from the Chan
Zuckerberg Initiative and
[`cellxgene-gateway`](https://github.com/Novartis/cellxgene-gateway) from the
Novartis Institutes for BioMedical Research.

## How to run portable cellxgene

1. Download the portable-cellxgene.app.zip file (the datasets are bundled with
   it).
2. Double click on the downloaded zip file to extract its contents. It will
   contain just one file: an app called "portable-cellxgene". Move it to where
   you want it and double click to open it.
3. Wait for a window to open. Text will print and eventually display the
   message "Running on http://127.0.0.1:5005". This may take some minutes.
4. A page listing the datasets should open in your browser. If it does not open
   after a minute or two, then naviagate to
   "http://127.0.0.1:5005/filecrawl.html" yourself.
5. Click on the name of the dataset that you want to analyse.
6. This will load a page saying that it is loading the dataset. In my
   experience, the loading process takes ~1 minute for every 10k cells in the
   dataset.
7. You will eventually be redirected to a screen with a UMAP of the cells. A
   window will pop up asking you to enter a name for a "User Generated Data
   Directory". This is the location where you can save any annotations you
   make. Enter something here and click "Create user generated data directory".
8. You are now in the main cellxgene window. We give a brief introduction to
   its use below. You can navigate back to the dataset selection page with your
   browser's back button. The datasets stay loaded in memory for as long as you
   leave the main app running, so they will load faster if you reload them.
   Once you are finished, close the cellxgene browser window(s) and click
   "Cancel" and "Quit" on the app window.

## How to use cellxgene

More complete guides are available online, e.g.
[here](https://icbi-lab.github.io/cellxgene-user-guide/).

