#THIS SHOULD RUN FINE BY ITSELF. Just do .\magicnumbers.ps1
#You need to have siglist.txt and all other files in the ps directory as extracted from the zip.

#This is a dirty hack because
#Idiot windows powershell does not know .\, needs full dirs
$Dir = Get-Location 
$Where = Join-Path -Path $Dir -ChildPath  "\ps\"
$Sigwhere = Join-Path -Path $Where  -ChildPath "\siglist.txt"

# file path , ignoring subdirs because script tries to run format-hex on a dir
$Path = Get-ChildItem -Path $Where -recurse | Where-Object { !$_.PSisContainer } | Select-Object FullName

#modified filesig list to get acceptable fileendings
$fileSignatures = Import-Csv $Sigwhere -header Filetype,HEX,LastHEX,Fileending -Delimiter ";"
$fileSignatures

#last function in chain, either file is valid or rogue
function VerifyFile ($status,$File,$Filetyp) {
    $hashFromFile = Get-FileHash -Path $File
            if($status -eq 1)
            {
                if ($Filetyp.LastHEX) { $HEX = $Filetyp.HEX + "," + $Filetyp.LastHEX } else { $HEX = $Filetyp.HEX }
                Write-Host `n$File "`nGENUINE" $Filetyp.Filetype "Matched HEX:" $HEX "`nFile SHA256 hash:" $hashFromFile.Hash
            }
            else
            {
                Write-Host `n$File "`nROGUE FILE PRETENDING TO BE" $Filetyp.Filetype "`nFile SHA256 hash:" $hashFromFile.Hash "`nFile HEX:" $Filetype.HEX
            }     
}

#check if file has correct extensions
function VerifyEnding ($File,$Filetyp) {
    $fileending = [System.IO.Path]::GetExtension($File)
    $allowedendings = $Filetyp.Fileending -split ","
    $match = 0
    foreach($i in $allowedendings) {
        if ($fileending -contains $i) {
            $match = 1
            VerifyFile -status 1 -File $File -Filetyp $Filetyp
        }
    }
    if ($match -eq 0) {
        Write-Host "Error: " $fileending " filetype " $Filetype
        VerifyFile -status 0 -File $File -Filetyp $Filetyp
    }
}

#check if hex of file matches our known hex
function VerifyHEX ($File) {
    $first = (Format-hex -Path $File | Select-Object -First 1 -Expand Bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ''
    $last = (Format-hex -Path $File | Select-Object -Last 1 -Expand Bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ''
    $match = 0
    foreach($Filetype in $fileSignatures) {
        if (($first -match $Filetype.HEX) -Or ($Filetype.LastHEX -And $last -match $Filetype.LastHEX)) { 
            $match = 1
            VerifyEnding -File $File -Filetyp $Filetype
    }
 }
 if ($match -eq 0) {
    $hashFromFile = Get-FileHash -Path $File
     Write-Output "`n$File`nnot in signature list`nFile SHA256 hash:" $hashFromFile.Hash
 }
}

#for each file in path
foreach ($filePath in $Path) {
    if (Test-Path $filePath.FullName) {
        #start process
        VerifyHEX -File $filePath.FullName 
    } else {
        Write-Output $filePath.FullName + "not found!"
    }
}
