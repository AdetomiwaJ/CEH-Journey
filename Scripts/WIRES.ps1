<##################################################################################################

Name:IRES - Incident Response Extraction Script
Author: Adetomiwa Jeminiwa

IRES: Incident Response Extraction Script

This script will extract the following:
1. Account Information
2. System Information
3. Network Information
4. Registry information
5. Logs
6. Audit policies
7. Firewall settings
8. Tasks, Processes & Services
9. Miscellaneous 

This script will be developed for Windows OS and Linux OS.
WIRES - Windows.
LIRES - Linux

RUN AS ADMIN

#####################################################################################################>

$timezone = Get-TimeZone
$date = Get-Date -DisplayHint DateTime

$d = $date.Date

$dt = Get-Date -format "dd-MM-yyyy"

#Function declaration


function WIRES_System($target) 
{
    <# This function extracts all System information and saves in a file.
        Data captured in this function
        -Hostname
        -Running processes
        -Services
        -System info
        -Event logs
        -Startup programs/processes


    #>

    #Declaring variables 

    $hostname = hostname 
    $me = whoami
    $si = systeminfo
    $service = Get-Service #-ComputerName
    $proc = Get-Process
    $tasks = schtasks
    $startup = wmic startup list

    #Exporting to text file
    "Data was collected: $date" > WIRES_SystemInfo_$hostname_$dt.txt
     "`n " >> WIRES_SystemInfo_$hostname_$dt.txt

    "Hostname: $hostname" >> WIRES_SystemInfo_$hostname_$dt.txt
     "`n " >> WIRES_SystemInfo_$hostname_$dt.txt

    "Logged-on user: $me " >> WIRES_SystemInfo_$hostname_$dt.txt
    "`n " >> WIRES_SystemInfo_$hostname_$dt.txt

    "Full system information: " >> WIRES_SystemInfo_$hostname_$dt.txt
    "`n " >> WIRES_SystemInfo_$hostname_$dt.txt

    $si >> WIRES_SystemInfo_$hostname_$dt.txt
    "`n " >> WIRES_SystemInfo_$hostname_$dt.txt

    
    #Running processes
    "Data was collected: $date" > WIRES_Processes_$hostname_$dt.txt
    $proc >>WIRES_Processes_$hostname_$dt.txt #large
    "`n " >> WIRES_Processes_$hostname_$dt.txt

    #Startup processes & Services
    "Data was collected: $date" > WIRES_startup_$hostname_$dt.txt
    $startup >> WIRES_startup_$hostname_$dt.txt
    "`n" >> WIRES_startup_$hostname_$dt.txt
    net start >> WIRES_startup_$hostname_$dt.txt

    #Firewall rules
    "Data was collected: $date" > WIRES_Firewall_$hostname_$dt.txt
    $firewall >>WIRES_Firewall_$hostname_$dt.txt
    "`n" >> WIRES_Firewall_$hostname_$dt.txt

    #List of services
    "Data was collected: $date"  > WIRES_Services_$hostname_$dt.txt
    $service > WIRES_Services_$hostname_$dt.txt
    "`n" >> WIRES_Services_$hostname_$dt.txt
    cmd /c sc query >> WIRES_Services_$hostname_$dt.txt
    "`n" >> WIRES_Services_$hostname_$dt.txt
    wmic service list config >> WIRES_Services_$hostname_$dt.txt


    #Scheduled tasks
    "Data was collected: $date" > WIRES_schtasks_$hostname_$dt.txt
    $tasks >>WIRES_schtasks_$hostname_$dt.txt
    "`n" >> WIRES_schtasks_$hostname_$dt.txt

    #Verbose task list
    "Data was collected: $date" > WIRES_tasklist_$hostname_$dt.txt
    tasklist /v  >>WIRES_tasklist_$hostname_$dt.txt
    "`n" >> WIRES_tasklist_$hostname_$dt.txt

    #Event logs
    "These are the available logs:" > WIRES_EvtLogs_$hostname_$dt.txt
    Get-EventLog -list >> WIRES_EvtLogs_$hostname_$dt.txt

    Get-EventLog -LogName System 
    Get-EventLog -LogName Application 
    Get-EventLog -LogName Security 

    #Work on outputting to excel using proper piping.
    #Copy logs from original event folder in sys32  to your device
       
}

function WIRES_Account($target) #This functions extracts account information and saves in a file.
{
    $hostname = hostname 


    "Data was collected: $date" > WIRES_Account_$hostname_$dt.txt
    "`n" >> WIRES_Account_$hostname_$dt.txt
    
    "NET USER" >> WIRES_Account_$hostname_$dt.txt
    net user >> WIRES_Account_$hostname_$dt.txt
    "`n" >> WIRES_Account_$hostname_$dt.txt

    "NET LOCALGROUP" >> WIRES_Account_$hostname_$dt.txt
    net localgroup >> WIRES_Account_$hostname_$dt.txt
    "`n" >> WIRES_Account_$hostname_$dt.txt

    "NET GROUP ADMINS" >> WIRES_Account_$hostname_$dt.txt
    net group administrators >> WIRES_Account_$hostname_$dt.txt
    "`n" >> WIRES_Account_$hostname_$dt.txt

    "NET SHARE" >> WIRES_Account_$hostname_$dt.txt
    net share >> WIRES_Account_$hostname_$dt.txt
    "`n" >> WIRES_Account_$hostname_$dt.txt

    #Audit policies - run as admin
    "Data was collected: $date" > WIRES_Audit_$hostname_$dt.txt
    auditpol /get /category:* >> WIRES_Audit_$hostname_$dt.txt
}

function WIRES_Registry($target)
{
    <#
        Use <cmd /c REG QUERY /?>

        Persistence keys from MITRE

        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
        cmd /c REG QUERY HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
        cmd /c REG QUERY HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce

        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
        cmd /c REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
        cmd /c REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders

        cmd /c REG QUERY HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
        cmd /c REG QUERY HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices
        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices

        cmd /c REG QUERY HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
        cmd /c REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run

    #>


}

function WIRES_Network($target)
{
    <# This function extracts all Network information and saves in a file.
        Data captured in this function
        -DNS Cache
        -ARP Cache
        -Routing table
        -Firewall rules
        

        netstat -naob (run as admin)

        -n: Displays addresses and port numbers.
        -a: Active TCP and listening UDP ports.
        -o: Connections with PID
        -b: Binary application for each connection (req admin account)
        -p: Shows protocols (IP, ICMP, UDP, TCP)
        -r: routing table
        -t: displays only TCP connections
        -u: Only UDP connections


    #>
    $hostname = hostname
    $dnscache = Get-DnsClientCache
    $arpcache = Get-NetNeighbor
    $routeTable = Get-NetRoute
    $firewall = netsh advfirewall show allprofiles
    
    
    #IPCONFIG /ALL
    "Data was collected: $date" >> WIRES_ipconfig_$hostname_$dt.txt
    ipconfig /all >> WIRES_ipconfig_$hostname_$dt.txt
    #"`n" >> WIRES_ipconfig_$hostname_$dt.txt


    #DNS Cache collection
    "Data was collected: $date" > WIRES_DNSCache_$hostname_$dt.txt
    $dnscache >> WIRES_DNSCache_$hostname_$dt.txt #large
    

    #ARP Cache collection
    "Data was collected: $date" > WIRES_ARPCache_$hostname_$dt.txt
    $arpcache >> WIRES_ARPCache_$hostname_$dt.txt #large
    "`n" >> WIRES_ARPCache_$hostname_$dt.txt #large
    
    arp -a >> WIRES_ARPCache_$hostname_$dt.txt #large
    #"`n " >> WIRES_ARPCache_$dt.txt

    #Routing table collection
    "Data was collected: $date" > WIRES_RouteTable_$hostname_$dt.txt
    $routeTable >>WIRES_RouteTable_$hostname_$dt.txt #large
    "`n " >> WIRES_RouteTable_$hostname_$dt.txt

    #NETSTAT -NAOB
    "NETSTAT -NAOB" > WIRES_netstat_$hostname_$dt.txt
    "Data was collected: $date" >> WIRES_netstat_$hostname_$dt.txt
    netstat -naob  >> WIRES_netstat_$hostname_$dt.txt

}

<# - Code snippet for extracting history with time stamp to csv
$history = Get-History | Format-list
$history | Export-Csv -Path "history.csv" -append -ErrorAction SilentlyContinue
#>
Write-Host $date $timezone.Id

Write-Host "
Welcome to IRES: Incident Response Extraction Script!

                This script will extract the following:
                    1. Account Information
                    2. System Information
                    3. Network Information
                    4. Registry information
                    5. Logs
                    6. Audit policies
                    7. Firewall settings
                    8. Tasks, Processes & Services
                    9. Miscellaneous
                     "
$input = Read-host "Please select your operating system by typing the number:
                        For windows: 1
                        For Linux : 2"


