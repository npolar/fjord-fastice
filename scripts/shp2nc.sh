#!/bin/bash

INDIR=/media/DataLocal/Projects/FjordIcePersistency/data
BINDIR=/media/DataLocal/Projects/FjordIcePersistency/scripts
TEMPLATEFILE=/media/DataLocal/Projects/FjordIcePersistency/templates/svalbard_template.tif

function shp2nc {
    YEAR=$1
    for SHPFILE in ${INDIR}/icecharts-${YEAR}/ice${YEAR}0[45678]??.shp; do
        NCFILE=${SHPFILE%.*}.nc
	echo "$(date): Converting $SHPFILE --> $NCFILE"
	python -W ignore ${BINDIR}/rasterize_met_icecharts.py -i $SHPFILE -o $NCFILE -t $TEMPLATEFILE
    done
    OUTFILE=${INDIR}/icecharts-${YEAR}/merged-icecharts-${YEAR}.nc
    rm $OUTFILE
    cdo mergetime ${INDIR}/icecharts-${YEAR}/ice*nc $OUTFILE
    }

shp2nc $1
