#!/bin/bash

# Remove 'src' from filename
for file in *_src*; do
    mv "$file" "${file//_src/}"
done

# Loop through each file number
for ((num = 1; num <= 9999; num++)); do
    # Form the file names
    srcflux_file="srcflux_$(printf "%04d" $num).pi"
    bkg_file="srcflux_$(printf "%04d" $num)_bkg.pi"
    resp_file="srcflux_$(printf "%04d" $num).rmf"
    ancr_file="srcflux_$(printf "%04d" $num).arf"
    bkg_resp_file="srcflux_$(printf "%04d" $num)_bkg.rmf"
    bkg_ancr_file="srcflux_$(printf "%04d" $num)_bkg.arf"
    
    # Run dmhedit command
    dmhedit "$srcflux_file" none add BACKFILE "$bkg_file"
    dmhedit "$srcflux_file" none add RESPFILE "$resp_file"
    dmhedit "$srcflux_file" none add ANCRFILE "$ancr_file"
    dmhedit "$bkg_file" none add RESPFILE "$bkg_resp_file"
    dmhedit "$bkg_file" none add ANCRFILE "$bkg_ancr_file"
done
