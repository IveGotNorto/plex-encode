#!/bin/bash
  
# Handbrake CLI directory location
hb_loc="./HandBrake/build/HandBrakeCLI" 
# Handbrake CLI options (consult online docs)
hb_opt='--preset "Fast 1080p30" --all-subtitles --subname "Default, Secondary" --subtitle-forced' 

# General Declarations
input_dir=""
output_dir=""
file_ext=""

if [[ $# -lt 2 ]] || [[ $# -gt 3 ]]; then
	echo "Usage: $0 input_dir file_extension \"handbrake options\""
elif [[ $# -eq 3  ]]; then
	hb_opt=$3
fi

input_dir=$1
file_ext=$2
output_dir=$(realpath "$input_dir")

if [ -d "$input_dir" ]; then
	# Don't allow symbolic links
	if [ ! -L "$input_dir" ]; then

    # Put encodings in inner folder
    # -- make sure it exists
    output_dir="${output_dir}/encodes"
    if [ ! -d "$output_dir" ]; then
      mkdir "$output_dir"      
    fi

    for file in "$input_dir"/*; do
      output_name=""
      if [ -f "$file" ]; then
        output_name="${output_dir}/${file##*/}"
        $("$hb_loc" -i "$file" -o "${output_name%.*}.${file_ext}" "'$hb_opt'" &> "${output_dir}/encode.log" &)
      fi
    done   
  else
    echo "Detected symbolic link as input directory...exiting"
	fi
else
  echo "Invalid input directory...exiting"
fi
