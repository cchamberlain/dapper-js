$BIN_PATH = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_PATH = (get-item $BIN_PATH).parent.FullName


function CleanUp()
{
    $nupkgFiles = @(Get-ChildItem $ROOT_PATH -Filter *.nupkg)

    if ($nupkgFiles.Count -gt 0)
    {
        "Found " + $nupkgFiles.Count + " *.nupkg files. Lets delete these first..."

        foreach($nupkgFile in $nupkgFiles)
        {
            $combined = Join-Path $ROOT_PATH $nupkgFile
            "... Removing $combined."
            Remove-Item $combined
        }
        
        "... Done!"
    }
}

function PackageTheSpecifications()
{
	echo "$ROOT_PATH"
    ""
    "Getting all *.nuspec files to package"

    $files = Get-ChildItem $ROOT_PATH -Filter *.nuspec

    if ($files.Count -eq 0)
    {
        ""
        "**** No nuspec files found in project directory"
        "Terminating process."
        throw;
    }

    "Found: " + $files.Count + " files :)"

    foreach($file in $files)
    {
        &nuget pack $file

        ""
    }
}

function PushThePackagesToNuGet()
{
    ""
    "Getting all *.nupkg's files to push to nuget"

    $files = Get-ChildItem $ROOT_PATH -Filter *.nupkg

    if ($files.Count -eq 0)
    {
        ""
        "**** No nupkg files found in the directory: $destination"
        "Terminating process."
        throw;
    }

    "Found: " + $files.Count + " files :)"

    foreach($file in $files)
    {
		echo (Join-Path $ROOT_PATH $file)
        &nuget push $file

        ""
    }
}

pushd $ROOT_PATH

CleanUp
PackageTheSpecifications
PushThePackagesToNuGet

popd