
param(
    [string]$inputFilename, 
    [int]$vidPercent
)

$sampleRate=5


if($inputFilename.Equals("help")){
    echo "Usage: ./sceneExtractor.ps1 <Filename> <Percentage>"
        echo "  <Filename>: input filename"
        echo "  <Percentage>: percentage of the input to be sampled starting from the beginning"
        exit 0
}

if($inputFilename.Equals("")){
    echo "File Name Missing"
    exit 1
}


if($vidPercent -eq 0){
    echo "Vid Percent Missing"
    exit 1
}

if($vidPercent -lt 0 -or $vidPercent -gt 100){
    echo "Invalid Percentage"
    exit 1
}

if(!(Get-Command ffprobe -errorAction SilentlyContinue)){
    echo "FFprobe Is Missing"
    exit 1
}
if(!(Get-Command ffmpeg -errorAction SilentlyContinue)){
    echo "FFmpeg Is Missing"
    exit 1
}

$filename=resolve-path $inputFilename | select -ExpandProperty Path

if(!($filename) -or !(Get-Item -Path $filename)){
    echo $filename
        echo "Input Does Not Exist"
        Exit 1
}

$duration=ffprobe -i "$filename" -show_entries format=duration -v quiet -of csv="p=0"
$duration = [double]$duration

$resolution=ffprobe -i "$filename" -show_entries stream=width,height -v quiet -of csv=s=x:"p=0"

$dirName=[System.IO.Path]::GetFileNameWithoutExtension("$filename")
$runLocation=$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.\') 
$dirName= -join($runLocation, "\", $dirName)

echo $dirName
mkdir $dirName 2> $null

$outputName="$dirName\frame#"
$frameAmount=$(($duration * ($vidPercent/100)) * $sampleRate)
$frameAmount=[Math]::Floor($frameAmount)

ffmpeg -loglevel error -i $filename -r $sampleRate -s $resolution -q:v 1 -vframes $frameAmount $outputName%03d.png 





