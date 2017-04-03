#!/bin/bash
#
# USAGE:
# ./shp2nc.sh YEAR
#
# EXAMPLE:
# ./shp2nc.sh 2015
#
# NOTES:
# Assume that the original data is in $INDIR/icecharts-$YEAR
# Requires Climate Data Operators (cdo) for nc files concatenation


INDIR=/media/DataLocal/Projects/FjordIcePersistency/data
BINDIR=/media/DataLocal/Projects/FjordIcePersistency/scripts

function shp2nc {
    YEAR=$1
    for SHPFILE in ${INDIR}/icecharts-${YEAR}/ice${YEAR}0[45678]??.shp; do
        NCFILE=${SHPFILE%.*}.nc
	echo "$(date): Converting $SHPFILE --> $NCFILE"
	python -W ignore ${BINDIR}/rasterize_fastice.py -i $SHPFILE -o $NCFILE
    done
    OUTFILE=${INDIR}/icecharts-${YEAR}/merged-icecharts-${YEAR}.nc
    rm $OUTFILE
    cdo mergetime ${INDIR}/icecharts-${YEAR}/ice*nc $OUTFILE
    }

shp2nc $1
