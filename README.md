# Consent
Chemoinformatics software for Ligand-Based Virtual Screening (LBVS)
using consensus queries.

# Usage

    ./consent -s {sing|oppo|opti|real|know} -q queries.{sdf|mol2|csv|ecfp4} -db candidates.{sdf|mol2|csv|ecfp4}

      -s <strat> consensus strategy {sing|oppo|opti|real|know} (mandatory)
      -q <filename> queries file (known actives; mandatory)
      -db <filename> database to rank order (mandatory)
      -o <filename> where to write scores (can be combined with -top)
      -n <int> consensus size; #known actives used to create query (optional; default=all molecules in query file)
      -top <int> how many top scoring molecules to write out (optional; default=all; must be combined with -o)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1006728.svg)](https://doi.org/10.5281/zenodo.1006728)
