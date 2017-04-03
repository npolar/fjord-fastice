#!/usr/bin/env python
# coding: utf-8

import netCDF4 as nc
from matplotlib import pyplot as plt
import numpy as np
from netcdftime import utime
import os
import rasterio
import shutil
import argparse
import logging

logging.basicConfig(loglevel=logging.info)
LOG = logging.getLogger()

def count_fastice_days(ifile, ofile, template_tif=None):
    """ Count consecutive fast ice days
    Args:
      ifile (str) : input NetCDF file
      ofile (str) : ouput geotiff file
    NB: Adjustmet for 5 days per week charting:
        Background: MET can only produce charts during weekdays
        Therefore there are gaps on weekends. We assume weeks are 5 days long
        Since we count continuos fast ice presence the largest uncertainty
        cannot exceed one day
       """
    fname = nc.Dataset(ifile)
    fastice_dst = fname['ice_concentration'][:].astype(np.bool)

    tsmp = fname['time']
    cdftime = utime(tsmp.units)
    timestamps = cdftime.num2date(tsmp[:])

    count= np.zeros(fastice_dst.shape[1::])
    mask = np.ones(count.shape, dtype=np.bool)
    switch = np.ones(count.shape)

    for i in range(fastice_dst.shape[0]):
        switch *= fastice_dst[i]
        count += switch
    count = np.where(count<=1, 0, count)

    shutil.copyfile(template_tif, ofile)

    with rasterio.open(template_tif, 'r') as template_dst:
        meta = template_dst.meta
        meta.update({'driver': 'GTiff'})
        with rasterio.open(ofile, 'w', **meta) as dst:
                dst.write((count/5.*7.).astype(rasterio.uint8), 1)

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("--input_file", "-i")
    parser.add_argument("--output_tif_file", "-o", required=True)
    parser.add_argument("--template_tif_file", "-t", required=True)
    args = parser.parse_args()

    ifile = args.input_file
    ofile = args.output_tif_file
    template_tif = args.template_tif_file

    if os.path.exists(ifile):
        count_fastice_days(ifile, ofile, template_tif=template_tif)
    else:
        raise IOError('Correct input_file option has to be provided')

if __name__ == "__main__":
    main()

