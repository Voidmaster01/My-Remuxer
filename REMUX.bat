@Echo off
:: I recommend following this video on how to install FFmpeg in order to use this file https://www.youtube.com/watch?v=EyIIvctDhYc&t=201s
set /p IPath=Enter the Path of the file you wish to remux from (use "Copy as path" option and keep the Quotations): 
set /p M=what is the first letter of the Directory of your new file?(do not include the semicolon(:))
set /p NewPath=Enter the Path + Extension of your temporary storage (Please do not use Quotations or directory letter):
set /P f=have you accidentally closed the process?[y/N] Please note this will skip the remuxing process and take you through the rest of the code:
if /I "%f%" == "N" goto :FFmpeg
if /I "%f%" == "Y" goto :Premiere

:FFmpeg
ffmpeg -i "%IPath%"  -c copy -map 0 "%M%:\%NewPath%"
goto :Premiere &:: This command takes inputs from the previous lines and sets up to remux files

:Premiere &:: this command line starts the preferred editor and waits 30 seconds to allow it to start
set /p EDITOR=Enter the .exe file for your prefered editor should look like: 'Adobe Premiere Pro.exe':
echo Starting Process. . . Please Wait
Start "" "%EDITOR%"
pause
:: The next couple of lines test for the editor to see if it opened or not
TASKLIST | FINDSTR /I "%EDITOR%"
if %ERRORLEVEL% == 1 (
        echo could not start process 
        goto :FailEditor
) Else (
        echo Process completed, next question
        goto :choice
)


:FailEditor &:: this will tell the user to open the editor if the above process does not work
set /P g= Please start Editor manually!!! then type Y:
if /I "%g%" == "Y" goto :choice

:choice &:: This asks user to check using the preferred editor for corruption/file failure
set /P c=Does the final file work as intended[Y/N]?
if /I "%c%" == "N" goto :Redo &:: this will send them to Redo the remux
if /I "%c%" == "Y" goto :Foldercreation &:: if no failure/corruption is found and user confirms this will send them to :Delete

:Redo &:: This command line re-remuxes the original video then asks the question again
ffmpeg -i "%IPath%"  -c copy -map 0 "%M%:\%NewPath%"
goto :choice2

:Foldercreation &:: This section asks the user which folder it should be stored in
set /P Folder=Which folder should this go in?
echo Checking if exists directory "%M%:\%Folder%" ...
if exist "%M%:\%Folder%" (
   echo Directory already exists.
   goto :Move
) else (
   echo Directory doesn't exist, creating...
   md "%M%:\%Folder%"
   goto :Foldercreation
)

:Move &:: Moves File from temporary storage to final destination ready for editing
move "%M%:\%NewPath%" "%M%:\%Folder%\"
set /P c3=Did the file go to the correct folder?[Y/N]
if /I "%c3%" == "Y" goto :Delete
if /I "%c3%" == "N" goto :Foldercreation

:Delete &:: This area deletes the original file to allow obs to write the next one without issue
Del "%IPath%"
echo This video is now remuxed please edit it 
echo your streaming software is primed for next stream!!
pause
exit

:choice2 &:: This asks the user again just in case
set /P c2=Does this one work? If not check for corruption in original file!!![Y/N]
if /I "%c2%" == "N" goto :corrupted
if /I "%c2%" == "Y" goto :Foldercreation

:corrupted &:: if FFmpeg fails both times user is asked to check for corruption and does not delete the original file
@Echo check for corruption
pause
exit

