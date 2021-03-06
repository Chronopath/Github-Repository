function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$FeatureName,

		[System.Boolean]
		$Installed,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure

	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
$FeatureExists = Get-WindowsFeature -Name $FeatureName -ErrorAction SilentlyContinue

    If ($FeatureExists.installed -eq $Installed) {
            Write-Verbose "Service status is correct"
           
        }Else {
            write-Verbose "Service status is not correct"
            
        }
	
    $returnValue = @{
		FeatureName = [System.String]$FeatureName
		Installed = [System.Boolean]$FeatureExists.installed
		Ensure = [System.String]$Ensure
	}
    $returnValue
	

	<#
	$returnValue = @{
		FeatureName = [System.String]
		Installed = [System.Boolean]
		Ensure = [System.String]
	}

	$returnValue
	#>
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$FeatureName,

		[System.Boolean]
		$Installed,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

     Write-verbose "Changing windows feature presence"
    If ($Installed -eq $True) {
        Install-WindowsFeature -name $FeatureName
    }Else {
        Uninstall-WindowsFeature -name $FeatureName
    }

	#Include this line if the resource requires a system reboot.
	$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$FeatureName,

		[System.Boolean]
		$Installed,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
$FeatureExists = Get-WindowsFeature -Name $FeatureName -ErrorAction SilentlyContinue

if ($Ensure -eq 'Present') {   
    if($FeatureExists -ne $null)
    {
        If ($FeatureExists.installed -eq $Installed) {
            Write-Verbose "Nothing to configure - Feature is installed"
            Return $True
        }Else {
            Write-Verbose "Need to configure - Feature is not installed"
            Return $False
        }
    } else {
        Write-Verbose "Nothing to configure - Feature do NOT Exist"
        return $false
    }
} Else {
    Write-Verbose "Nothing to configure - Ensure is Absent"
    return $False
}

	<#
	$result = [System.Boolean]
	
	$result
	#>
}


Export-ModuleMember -Function *-TargetResource

