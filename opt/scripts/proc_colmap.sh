#!/bin/bash

# USAGE: bash proc_colmap.sh <dir of images>

echo "----" run_colmap
python run_colmap.py $1 ${@:2}

# echo "----" colmap2nsvf
# python colmap2nsvf.py $1/sparse/0

# echo "----" create_split
# python create_split.py -y $1
