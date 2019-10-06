import socket
import subprocess
import sys
from datetime import datetime

#screen clearing
subprocess.call('clear', shell=True)

#Asking for input
remoteServer = input("Enter a remote host to scan: ")
remoteServerIP = socket.gethostbyname(remoteServer)

#Print info on the host we are about to scan

print ("-"*60)
print ("Please wait, scanning remote host", remoteServerIP)
print ("-"*60)

#The time the scan started
t1 = datetime.now()

#Specifying ports with the range function (scanning all ports between 1 to 1024) and error handling

try:
    for port in range (1,1025):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((remoteServerIP, port))
        if result == 0:
            print ("Port {}:     Open".format(port))
        sock.close()

except KeyboardInterrupt:
    print ("Error, you pressed Ctrl+C")
    sys.exit()

except socket.gaierror:
    print ("An error occured while resolving the host")
    sys.exit()

except socket.error:
    print ("could not connect to server")
    sys.exit()


#checking time

t2 = datetime.now()

total = t2 - t1

print ("Scanning completed in: ",total)
