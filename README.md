# My-Remuxer
This .bat file automates a tedious process for me and figured id share it


If you are using this file to automate your recordings you will need to change some things
First change the input ["V:\Before Remux\01.mkv"] to be where you record your OBS VODs to 
I recommend changing the setting in obs to write files to only one name and have that in the folder with this batch file

## For File HUB users
*Note hub users use hubs to temporarily store their files while remuxing them
- change ["M:\1 REMUX HUB\%newname%.mp4"]to be ["x:\YourFolder\%newname%.mp4"]
- where x=drive extension and \YourFolder\=the subfolder of your choice

## For Non-HUB users
- Add {set /p path=Enter the output file path:} after line __ 
- Change ["M:\1 REMUX HUB\%newname%.mp4"] to {"%path%\%newname%.mp4"}

## File Moving
- I have added the feature to automatically move your file to a new one and even create a directory if the folder does not exist
- after you test the mp4 file it will ask where the final file will go
- if the directory exists the file will go into there
- if the directory does not exist the code will automatically make the folder then add the file into the folder
