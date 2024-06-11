#!/bin/bash

# Check if the script is run in the correct folder
if [ ! -f *.pi ]; then
    echo "Error: No spectra files (.pha or .pi) found in the current directory."
    echo "Make sure you are in the folder containing your spectra files."
    exit 1
fi

# Display a warning and prompt to continue
read -p "This script will process all .pha and .pi files in the current directory. Continue? (y/n): " choice

# Check the user's choice
if [ "$choice" != "y" ]; then
    echo "Script aborted."
    exit 1
fi

# Loop through all the spectra files in the folder
for spectrum_file in *.{pha,pi}; do
    # Check if the file is a regular file and does not have "_bkg" before the extension
    if [ -f "$spectrum_file" ] && [[ "$spectrum_file" != *_bkg.* ]] && [[ "$spectrum_file" != *_grouped.* ]]; then
        echo "Processing $spectrum_file"
        
        # Extract filename and extension
        filename=$(basename -- "$spectrum_file")
        extension="${filename##*.}"
        filename_noext="${filename%.*}"

        # Define output file name with "_grouped" added before the extension
        output_spectrum="${filename_noext}_grouped.$extension"

        # Define response file name based on spectrum file
        response_file="${filename_noext}.rmf"
        
        # Define background file name based on spectrum file
        background_file="${filename_noext}_bkg.pi"

        # Launch XSPEC and run commands
        xspec <<EOF
            ftgrouppha infile=$spectrum_file outfile=$output_spectrum backfile=$background_file respfile=$response_file grouptype=min groupscale=10 clobber=true
            #ftgrouppha infile=$spectrum_file outfile=$output_spectrum backfile=$background_file respfile=$response_file grouptype=snmin groupscale=10 clobber=true
            exit
EOF

        echo "Grouped spectrum saved as $output_spectrum"
    fi
done
