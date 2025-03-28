#!/bin/bash
shopt -s globstar nullglob

for element in "$(pwd)"/**;
  do 
    if [[ -f $element ]]; then  
        extension="${element##*.}"

        if [[ $extension == "aux" ]] || [[ $extension == "fls" ]] ||
        [[ $extension == "log" ]] || [[ $extension == "toc" ]] || 
        [[ $extension == "gz" ]]|| [[ $extension == "fdb_latexmk" ]]; then 
            rm "$element"
        fi
      fi
  done