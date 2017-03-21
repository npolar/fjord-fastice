#!/usr/bin/env python

import argparse

import geopandas as gpd
import rasterio
import fiona
from rasterio import features
import os
from datetime import datetime as dt

def rasterize(convert_to_rast, out_rast, meta, field):
    with rasterio.open(out_rast, 'w', **meta) as out:
        out_arr = out.read(1)
        # this is where we create a generator of geom, value pairs to use in rasterizing
        shapes = ((geom,value) for geom, value in zip(convert_to_rast.geometry, convert_to_rast[field]))
        burned = features.rasterize(shapes=shapes, fill=0, out=out_arr, transform=out.transform)
        import ipdb; ipdb.set_trace()
        out.write_band(1, burned)       
                
if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("--ifile", "-i")
    parser.add_argument("--ofile", "-o")
    parser.add_argument("--template", "-t")
    args = parser.parse_args()

    ifile = args.ifile
    ofile = args.ofile
    tif_template = args.template

    start = dt.now()
    rst = rasterio.open(tif_template)
    convert_to_rast = gpd.read_file(ifile) 
    convert_to_rast = convert_to_rast.loc[convert_to_rast['ICE_TYPE'] == 'Fast Ice']
    convert_to_rast['Junk'] = 1    
    if rst.crs != convert_to_rast.crs:
        convert_to_rast = convert_to_rast.to_crs(rst.crs)
    meta = rst.meta.copy()
    meta.update(compress='lzw')    
    out_rast = ofile
    rasterize(convert_to_rast, out_rast, meta, field='Junk')
    print dt.now() - start
