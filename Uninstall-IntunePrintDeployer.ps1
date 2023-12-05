$SharedPrinterPath = "\\printserver\printer" # Replace with your shared printer path

# Remove the shared printer
Write-Verbose "Getting the printer '$SharedPrinterPath'."
$printer = Get-WmiObject -Class Win32_Printer -Filter "Shared=True" | Where-Object {$_.Name -eq $SharedPrinterPath} 

# If the printer is installed, remove it
if ($printer) {
    Write-Verbose "Removing the printer '$SharedPrinterPath'."
    $printer.Delete()
    Write-Verbose "The printer '$SharedPrinterPath' has been removed."
} else {
    Write-Verbose "The printer '$SharedPrinterPath' is not installed."
}