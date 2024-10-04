
<h2>flatten script - bash.</h2>

<b>What it does:<br></b>
Step 0: put the script in the file that has a lot of ZIP's that you want to unzip, run it in Git Bash or somewhere else <br>
Step 1: Unzip all .zip files recursively in the current directory and its subdirectories<br>
Step 2: Flatten and copy all files into the current working directory with unique naming<br><br>
There is also commented out lines for deleting original zip. Uncomment if needed<br>


<h2>PowerShell script - ps1:</h2>

Runnable in Powershell with Admin Rights

<b>Prep:</b> <br>
Just create a folder and dump all the fonts you want to install in there, so that they are NOT nested in multiple folders. If needed, use unzip script to help with the process. <br> 
If you want to later install more fonts, there is no need to delete the old ones, can re-use the same file. <br>


<b>edit paths or replicate my folder tree paths:</b> <br>
$fontsPath = "C:\Scripts\FontsToInstall" <br>
$logFile = "C:\FontInstallLog.txt" <br>

<b>If upon running facing issues with restrictions:</b><br>
Set-ExecutionPolicy Unrestricted <br>
Y + Enter <br>
run script <br>
Set-ExecutionPolicy Restricted <br>
Y + Enter <br>

(Or google custom restriction solution if needed)<br>

There is also commented out unistall logic, but I did not need to use it, so use it at your own risk if needed.<br>
This script edits registry, and that is considered risky, even though I have tested it and it worked well for me, but use at your own risk.<br>

