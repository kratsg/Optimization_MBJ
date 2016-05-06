Optimization for MBJ Analyses
=============================

Hello! The point of this repository is to centralize all of the information needed to handle optimization for the MultiB Jet Analysis for ATLAS. This makes it easier to keep all of our information in one place for referencing.

The `.gitignore <.gitignore>`_ file will ignore the default directories made as a result of running the ``optimize.py`` script. It is suggested to only put in the bare minimum files needed to recreate or rerun a set of optimizations to produce plots. This way, you still need the appropriate files to do anything.

Submodule? WTF
--------------

To make this fun, I used a submodule to dictate the structure of how this repo works. A submodule is effectively just a symbolic link to an existing repository that git understands. In order to set it up correctly for the first time, you can do the following::

    git clone git@github.com:kratsg/Optimization_MBJ
    cd Optimization
    git submodule init
    git submodule update

or via a recursive clone::

    git clone --recursive git@github.com:kratsg/Optimization_MBJ

Read `the git docs <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_ on submodules for more information. To update the submodule, there are two ways::

    cd Optimization
    git fetch

or a shorter way (similar to recursive) via::

    git submodule update --remote

Generating Mass Windows
=======================

To generate the mass windows, run a command like the following::

    dq2-ls mc15_13TeV:mc15_13TeV.*.MGPy8EG_A14N_GG_bbn1_*.merge.DAOD_SUSY10.*p2559/  | cut -d '.' -f 2,3 | tr '.' "\t" | cut -d '_' -f 1,5-7 | sed -e 's/MGPy8EG_//g' | tr '_' "\t" | sort -k2 -n > massWindows_Gbb.txt
