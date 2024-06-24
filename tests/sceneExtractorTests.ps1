
$counter=0


../src/sceneExtractor.ps1 ./somethingthatdoesntexist 10 | Out-Null
if($ERRORLEVEL -eq 0){
    echo "TEST 1 FAILED: Accepted Filepath That Doesn't Exist"
}
else{
    echo "TEST 1 PASSED"
    $counter=$counter + 1
}

../src/sceneExtractor.ps1 ./2024_05_3019_16_48.mkv .1 | Out-Null
if($ERRORLEVEL -eq 0){
    echo "TEST 2 FAILED: Accepted Invalid Percentage" 
}
else{
    echo "TEST 2 PASSED"
    $counter=$counter + 1
}

../src/sceneExtractor.ps1 ./2024_05_3019_16_48.mkv 1000 | Out-Null
if($ERRORLEVEL -eq 0){
    echo "TEST 3 FAILED: Accepted Invalid Percentage" 
}
else{
    echo "TEST 3 PASSED"
    $counter=$counter + 1
}

../src/sceneExtractor.ps1 ./2024_05_3019_16_48.mkv 10 | Out-Null
if($ERRORLEVEL -eq 1){
    echo "TEST 4 FAILED: Script Failed To Run Through Successfully" 
}
else{
    echo "TEST 4 PASSED"
    $counter=$counter + 1
}

if(!(Get-Item -Path ./2024_05_3019_16_48)){ 
    echo "TEST 5 FAILED: Directory Not Created" 
}
else{
    echo "TEST 5 PASSED"
    $counter=$counter + 1
}

if(!(Get-Item -Path ./2024_05_3019_16_48/frame#001.png) -or !(Get-Item -Path ./2024_05_3019_16_48/frame#013.png)){
    echo "TEST 6 FAILED: Amount Of Frames Created Is Incorrect" 
}
else{
    echo "TEST 6 PASSED"
    $counter=$counter + 1
}

if($counter -eq 6){
    echo "ALL TESTS PASSED"
}

exit 0
