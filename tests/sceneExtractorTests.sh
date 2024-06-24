#!/bin/sh

counter=0

if ../src/sceneExtractor.sh ./somethingthatdoesntexist 10 > /dev/null 
then 
    echo "TEST 1 FAILED: Accepted filepath that doesnt exist"
else
    echo "TEST 1 PASSED"
    counter=$((counter+1))
fi

if ../src/sceneExtractor.sh ./2024_05_3019_16_48.mkv .1 > /dev/null
then 
    echo "TEST 2 FAILED: Accepted invalid percentage"
else
    echo "TEST 2 PASSED"
    counter=$((counter+1))
fi 

if ../src/sceneExtractor.sh ./2024_05_3019_16_48.mkv 1000 > /dev/null
then 
    echo "TEST 3 FAILED: Accepted invalid percentage"
else
    echo "TEST 3 PASSED"
    counter=$((counter+1))
fi 

 
if  ! ../src/sceneExtractor.sh ./2024_05_3019_16_48.mkv 10 > /dev/null 
then 
    echo "TEST 4 FAILED: Accepted invalid percentage"
else
    echo "TEST 4 PASSED"
    counter=$((counter+1))
fi 

if [ ! -d ./2024_05_3019_16_48 ] 
then 
    echo "TEST 5 FAILED: Folder Was Not Created Properly"
else 
    echo "TEST 5 PASSED"
    counter=$((counter+1))
fi

if [ ! -e ./2024_05_3019_16_48/frame#001.png ] || [ ! -e ./2024_05_3019_16_48/frame#013.png ] 
then 
    echo "TEST 6 FAILED: Amount Of Frames Created Is Incorrect"
else 
    echo "TEST 6 PASSED"
    counter=$((counter+1))
fi

if [ $counter -eq 6 ] 
then 
    echo "ALL TESTS PASSED"
fi 

exit 0
