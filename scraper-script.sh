#!/bin/bash

baseURL=https://mfit-release.storage.googleapis.com/
#Pull Everything.
curl "${baseURL}" > all-data.xml

#Pull all the versions and delete unused files.
grep -oE '<Key>[^<]*</Key>' all-data.xml > all-versions.xml
rm all-data.xml

#Grab and put different versions into their own file.
grep -E 'linux-collect.sh</Key>' all-versions.xml > linux-collect-versions.txt
grep -E 'mfit-windows-collect.ps1</Key>' all-versions.xml > windows-collect-versions.txt

#Clean-up version files.
sed -i "s/<Key>//g" linux-collect-versions.txt
sed -i "s/\.sh.*/.sh/" linux-collect-versions.txt
sed -i "s/<Key>//g" windows-collect-versions.txt
sed -i "s/\.ps1.*/.ps1/" windows-collect-versions.txt


#Make version-dilineated folder hierarchy.
input_file="linux-collect-versions.txt"
n=1
while read -r line;
do
  folder="${line%/*}"
  file="${line#*/}"
  mkdir "$folder"
  touch "$folder/$file"
  #sed "${n}s|^|${baseURL}" linux-collect-versions.txt
  #loot="$(awk "NR==${n}{ print; }" linux-collect-versions.txt)"
  #curl -o "$folder/$file" "$loot"
  loot="$(echo "${line}" | sed "s|^|${baseURL}|" linux-collect-versions.txt)"
  curl -o "${folder}/${file}" "${loot}"
  n=$((n + 1))

done < $input_file

# url to everything / curl / put contents in a file within the versioned directory tree
#sed -i -e "s|^|"${baseURL}"|" linux-collect-versions.txt
#sed -i -e "s|^|"${baseURL}"|" windows-collect-versions.txt
















##stage after acquisition that creates a new directory (if it doesn't exist) then do a git init on the directory - starting with the loweset
##version number to highest, populate the git directory with the assets (strippeed of the version number) - then do a 
##git commit with all files that have been put in there (git /commit etc)

##copy sets of 3 git /git commit with version number and then git tag the version number (do this basically 8 times - once for each version directory)

##the goal of this is to be able to see what's changed between versions of the collection script

#create directory tree that has all the versions and within each version directory should be 3 files (mfit/linux collect/microsoft collect)
#create a separate directory that will serve as the repo (git init on this directory). From this directory, copy over the 3 assets
#Once the files are cop

#there are some tools that can help use bash to store the xml as one 'variable'

#If i wanted to be fancy - I could use grep against the variable to parse out and pick out the pices I want