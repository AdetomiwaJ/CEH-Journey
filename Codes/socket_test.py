import socket

import sys


#ip = socket.gethostbyname('www.google.com')
#print ip

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    print "Socket created successfully"
    
except socket.error as err:
   print "Socket creation failed due to %s" %(err)

port = 80

try:
    host_ip = socket.gethostbyname('www.google.com')
    
except socket.gaierror:
    print "an error occurred while resolving the host"
    sys.exit()
    
s.connect((host_ip, port))
#print "successfully connected to www.google.com on port == %s" %(host_ip)

s.send("GET / HTTP/1.1\r\nHost: google.com\r\n\r\n")

resp = s.recv(4096)

print resp
