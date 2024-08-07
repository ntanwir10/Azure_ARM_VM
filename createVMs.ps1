param(
    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$location,
    
    [Parameter(Mandatory=$true)]
    [string]$adminUsername,
    
    [Parameter(Mandatory=$true)]
    [string]$adminPassword,
)

# function to ensure user has logged in to Azure account

function Ensure-Login {
   $azAccount = az account show -o json | ConvertFrom-Json
   if(-not $azAccount) {
      Write-Host "You're not logged in. Please login to your Azure account"
      az login
   }
}

# function to verify subscription

function Verify-Subscription {
   $currentSubscription = az account show --query 'id' -o tsv
   $subscriptions = az account list --query '[].{Name:name, Id:id}' -o table

   Write-host "Current Subscription ID: $currentSubscription"
   Write-host "Available Subscriptions: "
   Write-host $subscriptions

    $changeSubscription = Read-Host "Do you want to change subscription? (y/n)"
    if($changeSubscription -eq "y") {
        $newSubscriptionId = Read-Host "Enter Subscription ID that you want to use"
        az account set --subscription $newSubscriptionId
        Write-host "Subscription changed to $newSubscriptionId"
    }
}

# function to create virtual machines (VMs)
function Create-VM {
    param(
        [string]$vmName, 
        [string]$resourceGroupName, 
        [string]$location,
        [string]$adminUsername, 
        [string]$adminPassword
    )

    $vmSize = "Standard_DS1_v2"
    $imagePublisher = "MicrosoftWindowsServer"
    $imageOffer = "WindowsServer"
    $imageSku = "2019-Datacenter"

    New-AzVm `
        -ResourceGroupName $resourceGroupName `
        -Name $vmName `
        -Location $location `
        -VirtualNetworkName "myVNet" `
        -SubnetName "default" `
        -SecurityGroupName "myNSG" `
        -PublicIpAddressName "$vmName-pip" `
        -OpenPorts 3389 `
        -ImageName "$imagePublisher:$imageOffer:$imageSku:latest" `
        -Size $vmSize `
        # use for fully automated script.
        #Cons- the creds will be stored in plain text. 
        -Credential (New-Object PSCredential ($adminUsername, (ConvertTo-SecureString $adminPassword -AsPlainText -Force)))

        # use for not fully automated script where user interaction is required
        # -Credential (Get-Credential -UserName $adminUsername -Message "Enter a password for the virtual machine.")
}

#Ensure the user is logged in to Azure before proceeding

Ensure-Login

#Verify the subscription before proceeding

Verify-Subscription

#Create VMs
$vmNames = @("myVM1", "myVM2", "myVM3", "myVM4", "myVM5")
foreach($vmName in $vmNames) {
    Create-VM -vmName $vmName -resourceGroupName $resourceGroupName -location $location -adminUsername $adminUsername -adminPassword $adminPassword
}