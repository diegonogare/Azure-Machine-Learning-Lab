# Add Azure account
Add-AzureAccount

# If there are multiple subscriptions we will need to select one
$subscriptions = Get-AzureSubscription
if ($subscriptions.GetType().IsArray)
{
	Write-Host "Multiple subscriptions found:"  -ForegroundColor Yellow
	$subscriptions | select SubscriptionName
	Write-Host "There are mutiple subscriptions found for your account. Please type the name of the subscription you want to use:" -ForegroundColor Yellow

	$subscriptinName = Read-Host "Subscription Name"
	Select-AzureSubscription -SubscriptionName $subscriptinName
}


Get-AzureAccount

# Setup Azure SQL Database
Write-Host "Create Azure Sql Database and tables" -ForegroundColor White

$region = "South Central US"
$sqlUser = "churnuser"
$sqlPwd = "passWord!"
$dbName = "Churn"

$svr = New-AzureSqlDatabaseServer -location $region -AdministratorLogin $sqlUser -AdministratorLoginPassword $sqlPwd
$svrName = $svr.ServerName
$sqlServerFqdn = "$svrName.database.windows.net"
Write-Host "Created Sql Server $sqlServerFqdn" -ForegroundColor Green

$rule = New-AzureSqlDatabaseServerFirewallRule -ServerName $svrName -RuleName "all" -StartIPAddress "0.0.0.0" -EndIPAddress "255.255.255.255"
$svrCredential = new-object System.Management.Automation.PSCredential($sqlUser, ($sqlPwd  | ConvertTo-SecureString -asPlainText -Force))
$ctx = $svr | New-AzureSqlDatabaseServerContext -Credential $svrCredential 
$db = New-AzureSqlDatabase $ctx -DatabaseName $dbName 
Write-Host "Created Sql Database: $dbName" -ForegroundColor Green

# Create Sql tables
$sqlConnString = "Server=tcp:$sqlServerFqdn,1433;Database=$dbName;Uid=$sqlUser@$svrName;Pwd=$sqlPwd;Encrypt=yes;Connection Timeout=30;"
$sqlConn= New-Object System.Data.SqlClient.SqlConnection($sqlConnString)
$sqlConn.Open()

$cmdText = [System.IO.File]::ReadAllText("C:\\Lab1\\ChurnDataSQLAzure\\CreateTables.sql")
#$cmdText = [System.IO.File]::ReadAllText("$PSScriptRoot\\CreateTables.sql")
$sqlCmd= New-Object System.Data.SqlClient.SqlCommand($cmdText,$sqlConn)
$cmdResult = $sqlCmd.ExecuteNonQuery()
$sqlConn.Close()
Write-Host "Created Sql tables" -ForegroundColor Green


# Bulk Copy churn.csv to SQL Database table
bcp Churn.dbo.ChurnTable in c:\Lab1\ChurnDataSQLAzure\ChurnData.csv -U $sqlUser -S $sqlServerFqdn -P $sqlPwd -b 1000 -h "TABLOCK" -c -t ","  -r 0x0A
Write-Host "Copied Churn data to SQL Server" -ForegroundColor Green
