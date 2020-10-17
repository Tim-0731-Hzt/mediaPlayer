from socket import *

server = socket(AF_INET, SOCK_DGRAM)
server.bind(("127.0.0.1", 12000))

while True:
    message, clientAddress = server.recvfrom(2048)
    result = message.decode().split()
    print(result)
    print("\n")

