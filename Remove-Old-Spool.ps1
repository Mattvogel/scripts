<#
.Synopsis
    Fix up the Printer Spooler and remove old documents that may have gotten stuck
.Description
    Remove all the old documents that got sent to wrong printers or other horrible mistakes.

.Example
    ./Remove-Old-Spool.ps1 -hours 6
    ./Remove-Old-spool -hours 1
#>
Function Remove-Old-Spool ($hours)
{
    Process
    {
    $Date = (Get-Date).AddHours($hours)

    Stop-Service spooler
        sleep 10
    Get-ChildItem -Path "C:\Windows\System32\spool\PRINTERS" |Where-Object { $_.LastWriteTime -l $Date } |Remove-Item -Verbose -Confirm
        sleep 10
    Start-Service spooler
    }
}