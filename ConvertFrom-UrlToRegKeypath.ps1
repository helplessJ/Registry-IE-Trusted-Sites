Function ConvertTo-RegKeyFormat {
    
    
    param($rawUrl)
    
    $urlllElements = ($rawUrl -split '\.').count
    $baseDomain = ($rawUrl -split '\.',($urlllElements -1))[($urlllElements - 2)..($urlllElements - 1)]
    $urlllSubDomains = ($rawUrl -split '\.')[0..($urlllElements -3)]
    $urlllSubDomains = $urlllSubDomains -join '.'
    
    $recontructedUrl = @()
    $recontructedUrl += $baseDomain
    $recontructedUrl += $urlllSubDomains
    $newRegUrl = $recontructedUrl -join '\'
    $newRegUrl
}


Function Assert-Url {

    param($rawUrl='error')
    
    $url = $rawUrl
    $approvedDomainSuffixes = '.com|.net|.org'
    
    if($url[($url.Length -4)..($url.Length - 1)] -join '' -match $approvedDomainSuffixes){
        $true
    } else {
        Throw 'The supplied does not end with .com ; .net ; or .org'; break
    }

}

function Convert-UrlToRegistryPath
{
<#
	.SYNOPSIS
		Send a web domain url and an IE trusted site domain key is returned.
	
	.DESCRIPTION
		For use with IE trusted sites management.  This function will return the key equivelent for a given url.  RawUrl must not contain http or https and must end in .com .net or .org.  To add domain suffixes, modify $approvedDomainSuffixes in Assert-Url function.  This does not create registry keys, simply the key path that you would append the the HKLM or HKCU registry path.
	
	.PARAMETER rawUrl
		The url to convert to a registry key name.
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding()]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateScript({ Assert-Url -rawUrl $_ })]
		[string]$rawUrl
	)
	
	$startsWithAsterisk = '^\*'
	$startsWithHttp = '^http'
	
	Switch -Regex ($rawUrl)
	{
		
		$startsWithHttp { Throw 'HTTP and HTTPS are not allowed'; break }
		
		$startsWithAsterisk {
			IF (($rawUrl -split '\.').Count -eq 3)
			{
				$rawUrl
			}
			else
			{
				ConvertTo-RegKeyFormat -rawUrl $rawUrl
			}
			break
		}
		
		default
		{
			IF (($rawUrl -split '\.').count -eq 2)
			{
				$rawUrl
			}
			else
			{
				ConvertTo-RegKeyFormat -rawUrl $rawUrl
			}
		}
	}
}
