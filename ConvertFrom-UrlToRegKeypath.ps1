Function ConvertFrom-UrlToRegistryUrl {

    
    [cmdletbinding()]
    param(
            [Parameter(Mandatory=$true)]
            [string]$rawUrl
         )
         
    Switch -Regex ($rawUrl){
        '^\*' {
            IF(($rawUrl -split '\.').Count -eq 3){
                $rawUrl
            }else{
                $wantedEleCount = ($rawUrl -split '\.').count -1
                $allDotSub = (($rawUrl -split '\.', 3)[0..1]) -join '.'
                $remDotSub = ($rawUrl -split '\.', 3)[2]
                $grpA = ($remDotSub -split '\.',$wantedEleCount)[0..($wantedEleCount - 2)]
                $loop = $wantedEleCount - 2
                $revGrpA = @()
                if($grpA.count -ne 2){
                    foreach ($ele in $grpA)
                    {
                        $revGrpA += $grpA[$loop]
                        $loop--
                    }
                }
                $baseUrl = ($rawUrl -split '\.',$wantedEleCount)[$wantedEleCount -1]
                $allEles = @()
                $allEles += $baseUrl
                $allEles += $revGrpA
                $allEles += $allDotSub
                $newRegUrl = $allEles -join '\'
                $newRegUrl
            }
        }
        default {
            IF(($rawUrl -split '\.').count -eq 2){
                $rawUrl
            } else{
                $wantedEleCount = ($rawUrl -split '\.').count -1
                $grpA = ($rawUrl -split '\.',$wantedEleCount)[0..($wantedEleCount - 2)]
                $loop = $wantedEleCount - 2
                $revGrpA = @()
                    foreach ($ele in $grpA)
                {
                    $revGrpA += $grpA[$loop]
                    $loop--
                }
                $baseUrl = ($rawUrl -split '\.',$wantedEleCount)[$wantedEleCount -1]
                $allEles = @()
                $allEles += $baseUrl
                $allEles += $revGrpA
                $newRegUrl = $allEles -join '\'
                $newRegUrl
            } #else
        } #default
    } #switch
} #function
