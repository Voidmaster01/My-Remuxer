:: If you are using this file to automate your recordings you will need to change some things
:: First change the input ["V:\Before Remux\01.mkv"] to be where you record your OBS VODs to 
:: I recommend changing the setting in obs to write files to only one name and have that in the folder with this batch file

:: For File HUB users *Note hub users use hubs to temporarily store their files while remuxing them
:: change ["M:\1 REMUX HUB\%newname%.mp4"]to be ["x:\YourFolder\%newname%.mp4"]
:: where x=drive extension and \YourFolder\=the subfolder of your choice

:: For Non-HUB users
:: Add {set /p path=Enter the output file path:} after line __ 
:: Change ["M:\1 REMUX HUB\%newname%.mp4"] to {"%path%\%newname%.mp4"}


@Echo off
set /p newname=Enter new file name:
ffmpeg -i "V:\Before Remux\01.mkv" & :: this command adds the input for the remux
-c copy -map 0 "M:\1 REMUX HUB\%newname%.mp4" &:: this is the output with the name of the video set
goto :Premeiere

:Premiere &:: this command line starts premiere pro and waits 1 minute to allow it to start
start "" "C:\Program Files\Adobe\Adobe Premiere Pro 2024\Adobe Premiere Pro.exe"
TIMEOUT /T 60 goto :choice

:choice &:: This asks user to check using premiere pro or other editing sofware for corruption/file failure
set /P c=Does the final file work as intended[Y/N]?
if /I "%c%" == "N" goto :Redo &:: this will send them to Redo the remux
if /I "%c%" == "Y" goto :Delete &:: if no failure/corruption is found and user confirms this will send them to :Delete

:Redo &:: This command line re-remuxes the original video then asks the question again
ffmpeg -i "V:\Before Remux\01.mkv" -c copy -map 0 "M:\1 REMUX HUB\%newname%%%.mp4"
goto :choice2

:Delete &:: This area deletes the original file to allow obs to write the next one without issue
Del "V:\Before Remux\01.mkv"
echo This video is now remuxed please edit it 
echo OBS is primed for next stream!!
pause
exit

:choice2 &:: This asks the user again just in case
set /P c2=Does this one work? If not check for corruption in original file!!![Y/N]
if /I "%c2%" == "N" goto :corrupted
if /I "%c2%" == "Y" goto :Delete

:corrupted &:: if FFmpeg fails both times user is asked to check for corruption and does not delete the original file
@Echo check for corruption
pause
exit