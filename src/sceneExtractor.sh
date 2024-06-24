#!/bin/bash

#set -x

# how many frames per second to sample
framerate=5

#read -p "Input File: " input
input=$1

# this is going to be a pos integer representing the percentage
vidPercent=$2

if [[ $input == "help" ]];
then  
    echo "Usage: ./sceneExtractor.sh <Filename> <Percentage>"
    echo "<Filename>: input filename"
    echo "<Percentage>: percentage of the input to be sampled starting from the beginning"
    exit 0
fi

if [[ $vidPercent == .* ]]
then
    echo "Invalid Percentage"
    exit 1
fi

if [[ $vidPercent -gt 100 || $vidPercent -lt 1 ]]
then 
    echo "Invalid Video Sample Percentage"
    exit 1
fi

# check if ffmpeg and ffprobe exist 
if ! command -v ffprobe &> /dev/null 
then 
    echo "ffprobe missing"
    exit 1
fi 

if  ! command -v ffmpeg &> /dev/null 
then 
    echo "ffmpeg missing"
    exit 1
fi 

if ! command -v bc &> /dev/null
then 
    echo "bc missing"
    exit 1
fi

# expand ~
filename="${input/#~/${HOME}}"

# expand .
if [[ $filename == .* ]]; 
then  
    currDir=$(pwd) 
    filename="${input/#./$currDir}"
fi

if [ ! -f $filename ]
then 
    echo "Input Does Not Exist"
    exit 1
fi 

# uses no metadata (but expensive) 
#ffmpeg -i "$input" -f NULL - 

#uses metadata

# get duration as an integer
printf -v duration '%.*f\n' 0 "$(ffprobe -i "$filename" -show_entries format=duration -v quiet -of csv="p=0")"
printf -v duration '%d' "$duration" 2> /dev/null 

resolution=$(ffprobe -i "$filename" -show_entries stream=width,height -v quiet -of csv=s=x:"p=0")


# extract filename without extension
dirName=$(basename $filename)
dirName=$(echo $dirName | cut -d'.' -f1)

mkdir -p $dirName

outputName="./"$dirName"/frame#"

# convert percentage to a float and calculate the amount of frames to be extracted
printf -v frameAmount '%d' "$(echo "($duration * ($vidPercent/100))*$framerate" | bc -l)" 2>/dev/null


#ffmpeg -i <input file> -r 10 -s $resolution -q:v <qual number (1[highest]-2[lowest])> -vframes <number of frames to extract> frame%03d.jpg
ffmpeg -loglevel error -i $filename -r $framerate -s $resolution -q:v 1 -vframes $frameAmount $outputName%03d.png

exit 0



