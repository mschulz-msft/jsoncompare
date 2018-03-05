

param (
    [parameter(Mandatory=$true)][string]$directory
    )

$files = Get-ChildItem -R -path $directory\* -include *.json -exclude .* |select-string 'swagger'
$fileslink = $files.Path |out-string 
$fileslink | set-content $env:TEMP\files.txt

$temp = $env:TEMP

$f = echo $temp\files.txt
$list = get-content $f -Raw

foreach ($line in Get-Content $f) {

        if ($line -match $regex) {

         
         $jsonRaw = (get-content $line -Raw)

        }



$json = $jsonRaw | ConvertFrom-Json



$fileLocation = $jsonRaw.PSPath
Write-Host "File location (full path): " $fileLocation

$paths = $json.paths -split ";"


# Write-Host "Paths"
$paths | Format-LIst
 


#$i= 0

ForEach ($path in $paths) {

    $path = $path -replace "@{",""
    $path = $path -replace "@",""
    $path = $path -replace "=}",""
    $path = $path -replace "=",""
    $path = $path -replace " ",""


    Write-Host "Path: " $path
    
    $actions = ""

    foreach ($actions in $json.paths.$path) {
        
        $actionsClean = $actions -replace "@{",""
        $actionsClean = $actionsClean -replace "@",""
        $actionsClean = $actionsClean -replace "=",""
        $actionsClean = $actionsClean -replace "}",""
        $actionsClean = $actionsClean -replace " ",""
    
        $action = ""
        $tags = ""
        $operationId = ""
        $operationIds = ""

        foreach($action in ($actionsClean -split ";")) {
                      
            $tags = $json.paths.$path.$action.tags
            $operationId = $json.paths.$path.$action.operationId
            $operationIds = $operationId -split "_"

            if ($tags -ne ($operationIds[0])) {
                Write-Host "File: " $fileLocation
                add-content $env:TEMP\tempout.txt $filelocation
                Write-Host "Paths: " $path
                Write-Host "Action: " $action
                Write-Host "Tags: " $tags
                Write-Host "OperationId: " $operationId
                Write-Host "OperationId compare: " $operationIds[0]
            }

            
            Write-Host "Action: " $action
            Write-Host "Tags: " $tags
            Write-Host "OperationId: " $operationId
            

            #$i++
            #write-host $i
        }
    }
}
}

get-content $env:TEMP\tempout.txt | get-unique > $env:HOMEPATH\Documents\out.txt

Remove-Variable tags
Remove-Variable operationId
Remove-Variable operationIds
Remove-Variable actions
Remove-Variable actionsClean
Remove-Variable action
Remove-Variable path
Remove-Variable paths
Remove-Variable fileLocation
Remove-Variable json
Remove-Variable jsonRaw 
