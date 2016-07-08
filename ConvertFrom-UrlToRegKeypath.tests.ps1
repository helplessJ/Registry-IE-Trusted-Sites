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
    
    It 'Throws an exception if url begins with http' {
        {ConvertFrom-UrlToRegistryUrl -rawUrl 'http://www.microsoft.com'} | Should Throw 'HTTP and HTTPS are not allowed'
    }
    It 'Will leave full domain "*.microsoft.com" as-is'   {
        ConvertFrom-UrlToRegistryUrl -rawUrl '*.microsoft.com' | Should Be '*.microsoft.com'
    }
    It 'Will leave single domain "microsoft.com" as-is' {
        ConvertFrom-UrlToRegistryUrl -rawUrl 'microsoft.com' | Should Be 'microsoft.com'
    }
    It 'Converts "*.sub.fanniemae.org" to "fanniemae.org\*.sub' {
        ConvertFrom-UrlToRegistryUrl -rawUrl '*.sub.fanniemae.org' | Should Be 'fanniemae.org\*.sub'
    }
    It 'Converts "*.ridiculous.subDomain.example.com" to "example.com\*.ridiculous.subDomain"' {
        ConvertFrom-UrlToRegistryUrl -rawUrl '*.ridiculous.subDomain.example.com' |
          Should Be 'example.com\*.ridiculous.subDomain'
    }
    It 'Converts "www.microsoft.com" to "microsoft.com\www"' {
        ConvertFrom-UrlToRegistryUrl -rawUrl 'www.microsoft.com' | Should Be 'microsoft.com\www'
    }
    It 'Converts "sub.microsoft.com" to "microsoft.com\sub"' {
        ConvertFrom-UrlToRegistryUrl -rawUrl 'sub.microsoft.com' | Should Be 'microsoft.com\sub'
    }
    It 'Converts "ridiculous.sub.microsoft.com" to "microsoft.com\ridiculous.sub' {
        ConvertFrom-UrlToRegistryUrl -rawUrl 'ridiculous.sub.microsoft.com' |
          Should Be 'microsoft.com\ridiculous.sub'
    }
}

Describe 'Assert-Url' {

    Context 'Running without arguments'   {
        It 'Throws error if run without arguments with errors' {
            { Assert-Url } | Should Throw
        }
        It 'Throws error if URL does not end with approved suffix (.com/.net/.org)' {
             { Assert-Url -rawUrl 'bad.xample' } | Should Throw
        }
        It 'Returns $true if proper input is given'{
			Assert-Url -rawUrl 'example.com' | Should Be $true
			Assert-Url -rawUrl 'http://www.example.com' | Should Be $true
			Assert-Url -rawUrl 'login.microsoft.com' | Should Be $true
        }
    }
}
