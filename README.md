# Consent
Chemoinformatics software for Ligand-Based Virtual Screening (LBVS)
using consensus queries.

# Command line help

    ./consent -s {sing|oppo|opti|real|know}
              -q queries.{sdf|mol2|csv|ecfp4}
              -db candidates.{sdf|mol2|csv|ecfp4}

      -s <strat> consensus strategy {sing|oppo|opti|real|know} (mandatory)
      -q <filename> queries file (known actives; mandatory)
      -db <filename> database to rank order (mandatory)
      -o <filename> where to write scores (can be combined with -top)
      -n <int> consensus size; #known actives used to create query (optional;
               default=all molecules in query file)
      -top <int> how many top scoring molecules to write out (optional;
           default=all; must be combined with -o)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1006728.svg)](https://doi.org/10.5281/zenodo.1006728)

# Usage recommendation

The opportunist consensus policy (-s oppo) is recommended.
It works well with any fingerprint and is usually the best performing
method.

However, if you really need to go faster, here are some recommendations:

- MACCS fingerprint (166 bits): use the realistic policy (-s real); it will
  average the MACCS fingerprints of your known actives.

- ECFP4 fingerprint (2048 bits; folded; uncounted):
  use the optimist policy (-s opti); it will
  do a logical union of the fingerprints of your known actives.

- UMOP2D (unfolded MOLPRINT2D; uncounted): same as for ECFP4, use -s opti.

# How to encode your molecules

FBR: TODO; MACCS, ECFP4, UMOP2D

# How to create a consensus query

FBR: TODO; MACCS, ECFP4, UMOP2D

# How to query with a consensus query

FBR: TODO; MACCS, ECFP4, UMOP2D
