# To run this file you will need to open Powershell as administrator and first run:
# Set-ExecutionPolicy Unrestricted
# Then source this script by running:

$client = New-Object System.Net.WebClient

function InstallPythonMSI($installer) {
	$Arguments = @()
	$Arguments += "/i"
	$Arguments += "`"$installer`""
	$Arguments += "ALLUSERS=`"1`""
	$Arguments += "/passive"

	Start-Process "msiexec.exe" -ArgumentList $Arguments -Wait
}

function download_file([string]$url, [string]$d) {
	# Downloads a file if it doesn't already exist
	if(!(Test-Path $d -pathType leaf)) {
		# get the file
		write-host "Downloading $url to $d";
		$client.DownloadFile($url, $d);
	}
}


$save_dir=Resolve-Path ~/Downloads

write-host "Installing Python"
$msi_url = "https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi"
$save_path = '' + $save_dir + '\python-2.7.11.msi';
download_file $msi_url $save_path
InstallPythonMSI $save_path

write-host "Add Python to the PATH"
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Python27\;C:\Python27\Scripts\", "User")

write-host "Installing pip"
$setuptools_url = "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"
$save_path = '' + $save_dir + "\get_pip.py"
download_file $setuptools_url save_path
python $save_path


exit 0
