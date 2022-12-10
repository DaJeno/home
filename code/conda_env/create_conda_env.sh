#!/bin/sh
set -x 
set -v

# Expand aliases
shopt -s expand_aliases
source ~/.cshrc

if [[ $# -eq 0 ]] ; then
    echo 'USAGE: $0 <env>'
    exit 1
fi

# Store environment
env=$1

# Recreate conda env
conda deactivate
conda remove -n $env --all -y
conda env create -n $env -f ${env}_environment.yml --force
if [ $? -=ne 0]; then
    echo "Failed to create conda environment"
    exit 1
fi

# export the environment details to a text file
export_file="${env}_environment_export.txt"
conda env export -n $env > $export_file
if [ $? -ne 0 ]; then
    echo "Failed to dump environment details to $export_file"
    exit 1
fi
