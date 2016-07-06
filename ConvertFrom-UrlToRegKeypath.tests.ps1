# this is a Pester test file

#region Further Reading
# http://www.powershellmagazine.com/2014/03/27/testing-your-powershell-scripts-with-pester-assertions-and-more/
#endregion
#region LoadScript
# load the script file into memory
# attention: make sure the script only contains function definitions
# and no active code. The entire script will be executed to load
# all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion
Describe 'ConvertFrom-UrlToRegistryUrl' {
    It 'Leaves "*.microsoft.com" domains as-is'   {
        ConvertFrom-UrlToRegistryUrl -rawUrl '*.microsoft.com' | Should Be '*.microsoft.com'
    }
    It 'Converts "www.microsoft.com" domain to "microsoft.com\www"' {
        ConvertFrom-UrlToRegistryUrl -rawUrl 'www.microsoft.com' | Should Be 'microsoft.com\www'
    }
    It 'Converts "*.sub.fanniemae.org" to "fanniemae.org\*.sub' {
        ConvertFrom-UrlToRegistryUrl -rawUrl '*.sub.fanniemae.org' | Should Be 'fanniemae.org\*.sub'
    }
    It 'Converts "*.ridiculous.subDomain.example.com" to "example.com\*.ridiculous.subDomain"' {
        ConvertFrom-UrlToRegistryUrl -rawUrl '*.ridiculous.subDomain.example.com' | Should Be 'example.com\*.ridiculous.subDomain'
    }
}

