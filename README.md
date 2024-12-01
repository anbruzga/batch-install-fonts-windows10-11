<h1>Font Installation Script - PowerShell (PS1)</h1>

<h2>Purpose</h2>
<p>
    This PowerShell script installs fonts on a Windows system by copying them into the system fonts directory and updating the Windows registry.
</p>

<h2>Steps to Run:</h2>

<h3>1. Prepare the Font Folder</h3>
<ul>
    <li>Create a folder and place all the fonts you want to install inside it.</li>
    <li>Ensure the fonts are <strong>not nested in subfolders</strong>. If needed, you can use the flattening script (bash) to help with this process.</li>
</ul>

<h3>2. Edit Paths in the Script</h3>
<p>
    Open the script and update the following paths to match your system:
</p>
<pre><code>
$fontsPath = "C:\Scripts\FontsToInstall"
$logFile = "C:\FontInstallLog.txt"
</code></pre>
<ul>
    <li><strong>$fontsPath</strong>: This should be the folder where your font files are stored.</li>
    <li><strong>$logFile</strong>: This will be the file where the installation logs are saved.</li>
</ul>

<h3>3. Run the Script with Administrator Privileges</h3>
<p>
    This script must be run with <strong>Administrator rights</strong> because it modifies system files and the registry.
</p>

<h3>4. Address Execution Policy Issues (if any)</h3>
<p>If you encounter issues with script execution policies, follow these steps:</p>
<ol>
    <li>Temporarily change the execution policy to allow scripts to run:
        <pre><code>Set-ExecutionPolicy Unrestricted</code></pre>
    </li>
    <li>Press <strong>Y</strong> to confirm.</li>
    <li>After running the script, revert the execution policy back to its original setting:
        <pre><code>Set-ExecutionPolicy Restricted</code></pre>
    </li>
    <li>Press <strong>Y</strong> to confirm.</li>
</ol>

<h3>5. Font Installation Process</h3>
<p>When you run the script, it will:</p>
<ul>
    <li><strong>Check if each font is already installed</strong> on your system.</li>
    <li><strong>Copy the font files</strong> to the system fonts directory if they aren't already installed.</li>
    <li><strong>Update the Windows registry</strong> with font installation details.</li>
    <li><strong>Log the process</strong> in the specified log file.</li>
    <li><strong>Prioritise .otf over .ttf </strong> - both arial.otf and arial.ttf can be present in folder, script will pick up .otf and ignore .ttf</li>
</ul>

<h3>6. Optional: Font Uninstallation Logic</h3>
<p>The script contains logic for uninstalling fonts <strong>(untested!)</strong>, it is currently commented out. If you need to uninstall fonts, you can:</p>
<ul>
    <li><strong>Uncomment the uninstallation section</strong> to enable this functionality.</li>
    <li>It’s recommended to test this functionality in a safe environment before using it on a production system.</li>
</ul>

<h2>Important Notes:</h2>
<ul>
    <li>The script modifies the <strong>Windows registry</strong>, which can have unintended consequences if used improperly. Although the install part has been tested and worked correctly, <strong>use at your own risk</strong>.</li>
    <li>If you want to install more fonts in the future, simply add them to the font folder. There’s no need to delete previously installed fonts, as the script will not install same fonts twice.</li>
</ul>

<h2>Troubleshooting</h2>
<p>If you face any issues while running the script:</p>
<ol>
    <li>Ensure you are running the script as <strong>Administrator</strong>.</li>
    <li>Verify that the paths for <code>$fontsPath</code> and <code>$logFile</code> are correct.</li>
    <li>If you encounter any restrictions due to execution policies, adjust the execution policy as mentioned above.</li>
</ol>

<br>
<br>
<hr>
<hr>
<h1>Unzip and Flatten Script - Bash</h1>

<h2>Purpose</h2>
<p>
    This script unzips all `.zip` files recursively in a given directory and its subdirectories, then flattens and copies all the files into the current working directory with unique names.
</p>

<h2>Steps to Run:</h2>

<h3>1. Put the Script in the Folder with ZIP Files</h3>
<ul>
    <li>Place the script in the directory that contains the `.zip` files you want to unzip.</li>
    <li>Run the script in a terminal, such as Git Bash, or any other shell that supports bash scripts.</li>
</ul>

<h3>2. Unzip All `.zip` Files Recursively</h3>
<p>
    The script will search for all `.zip` files within the directory and its subdirectories, and unzip them in place.
</p>

<h3>3. Flatten and Copy Files with Unique Naming</h3>
<p>
    After unzipping the files, the script will flatten the directory structure and copy the unzipped files into the current working directory. Each file will be renamed with a unique prefix based on its original folder name.
</p>

<h3>4. Optional: Delete Original `.zip` Files</h3>
<p>
    There is an optional section in the script that can delete the original `.zip` files after extraction. This is currently commented out, but if you wish to delete the `.zip` files after extracting, simply uncomment the following line:
</p>
<pre><code># rm "$zip_file"</code></pre>

<h2>How It Works:</h2>
<ul>
    <li><strong>Unzip Recursively</strong>: The script uses the <code>find</code> command to locate all `.zip` files within the specified directory and its subdirectories and then unzips each one to its corresponding directory.</li>
    <li><strong>Flatten and Copy</strong>: For each subdirectory, the script uses the <code>basename</code> function to extract the folder name and add it as a prefix to each file. This ensures that files with the same name from different directories do not overwrite each other.</li>
    <li><strong>Delete `.zip` Files (Optional)</strong>: The script includes an optional line to delete the original `.zip` files after extraction, which can be enabled by uncommenting the line.</li>
</ul>

<h2>Important Notes:</h2>
<ul>
    <li>The script does not overwrite files in the destination directory. If a file with the same name already exists, the new file will be renamed with a unique prefix.</li>
    <li>If the directory contains a large number of `.zip` files or very large files, the script may take some time to complete.</li>
    <li>Ensure that you have write permissions in the destination directory for copying and renaming files.</li>
</ul>

<h2>Example Usage</h2>
<p>To run the script, navigate to the directory containing the `.zip` files and execute the script:</p>
<pre><code>./unzip_script.sh</code></pre>

<h2>Troubleshooting</h2>
<p>If you encounter any issues, here are a few things to check:</p>
<ol>
    <li>Ensure that the script has execution permissions by running:
        <pre><code>chmod +x unzip_script.sh</code></pre>
    </li>
    <li>Check if there are any errors during the unzip process related to file permissions or file corruption.</li>
    <li>If you enable the deletion of `.zip` files, ensure the script has permission to delete files in the directory.</li>
</ol>



