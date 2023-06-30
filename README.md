This is a guide to sharing `cellxgene` instances (possibly for multiple
datasets) between MacOS users with minimal effort for the end user.

## How to run `portable-cellxgene`

1. Download `portable-cellxgene.app.zip`.
2. Double click on the downloaded file to extract its contents. It should
   contain a single file: `portable-cellxgene.app`. Move it to a sensible
   location, right click on it and select "Open".
3. A drag and drop window will open along with a file browser. Select the
   folder containing the .h5ad files you want to analyse.
4. A page listing the datasets should open in your browser. If it does not open
   after a minute or two, then navigate to
   `http://127.0.0.1:5005/filecrawl.html` yourself.
5. Click on the "New" next to the name of the dataset that you want to analyse.
   Enter a name to save your annotations and gene sets.
6. This will load a page saying that it is loading the dataset. In our
   experience (on a standard MacBook Pro) the loading process takes ~1 minute
   for every 10,000 cells in the dataset. If it crashes, click "Reload", or
   restart the app.
7. You will eventually be redirected to a screen with a UMAP of the cells.  You
   are now in the main `cellxgene` window. We give a brief introduction to this
   program below. You can navigate back to the dataset selection page with your
   browser's back button. The datasets stay loaded in memory for as long as you
   leave the main app running, so they will load faster the second time you
   load them. If you want to return to a dataset and re-use annotations/gene
   sets that you created before, click on the name that you gave them (ignore
   the additional names with "\_annotations" at the end.
8. Once you are finished, close the `cellxgene` browser tab(s) and click
   "Cancel" and "Quit" on the app window.

## Distributing your data

To distribute your data using this app, simply create a folder containing .h5ad
files of the datasets of interest. The recipient needs to download the
portable-cellxgene app and run it using the above guide.

### Converting Seurat objects to `.h5ad` files

By default, the `.h5ad` files created by the standard Seurat -> Anndata
conversion process (detailed
[here](https://mojaveazure.github.io/seurat-disk/articles/convert-anndata.html))
contain only the highly variable genes, and therefore other genes cannot be
annotated in `cellxgene`. This can be fixed by replacing the data stored in the
`scale.data` slot of the Seurat object with the entire gene expression matrix.
This object can then be converted to a `.h5ad` file using the guide linked
above. Namely:

```{r}
# For each Seurat object you want to include in portable-cellxgene:
# Assume Seurat object is called "cells"
library(Seurat)
library(SeuratDisk)
cells@assays$RNA@scale.data <- as.matrix(GetAssayData(cells))
SaveH5Seurat(object = cells, filename = "cells.h5Seurat")
Convert(source = "cells.h5Seurat", dest = "h5ad")
```

## How to use `cellxgene`

TODO. Relatively complete guides are available online, e.g.
[here](https://icbi-lab.github.io/cellxgene-user-guide/).

## Licence

Copyright (C) 2023 University College London

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
