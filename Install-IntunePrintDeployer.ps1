$SharedPrinterPath = "\\printserver\printer" # Replace with your shared printer path
$SetAsDefault = $false # Set to $true if you want to set the shared printer as the default printer

# Get computer name from the shared printer path
$computerName = $SharedPrinterPath.Split('\')[2]

# Check if the print server is reachable
Write-Verbose "Checking if the print server '$computerName' is reachable."
if (!(Test-Connection -ComputerName $computerName -Count 1 -Quiet)) {
    Write-Verbose "The print server '$computerName' is not reachable."
    exit
}

# Get current installed printers
Write-Verbose "Getting current installed printers."
$installedPrinters = Get-Printer

# If the printer is already installed, exit the script
Write-Verbose "Checking if the printer '$SharedPrinterPath' is already installed."
if ($installedPrinters | Where-Object { $_.Name -eq $SharedPrinterPath }) {
    exit
}

# Add the shared printer
Write-Verbose "Adding the printer '$SharedPrinterPath'."
Add-Printer -ConnectionName $SharedPrinterPath

# Set the shared printer as the default printer if specified
if ($SetAsDefault) {
    Write-Verbose "Setting the printer '$SharedPrinterPath' as the default printer."
    $Printer = Get-WmiObject -Class Win32_Printer -Filter "Shared=True" | Where-Object {$_.Name -eq $SharedPrinterPath} 
    $Printer.SetDefaultPrinter() | Out-Null
}