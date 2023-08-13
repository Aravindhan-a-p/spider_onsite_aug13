#! /usr/bin/bash python 3
import socket
import paramiko
import threading

class SSHServer(paramiko.ServerInterface):
    def check_auth_password(self, username: str, password: str) -> int:
        print(f"{username}:{password}")
        return paramiko.AUTH_FAILED
    
def client_handle(client):
    transport=paramiko.Transport(client)
    server_key=paramiko.RSAKey.from_private_key_file('key')
    transport.add_server_key(server_key)
    ssh=SSHServer()
    transport.start_server(server=ssh)
    
def main():
    server=socket.socket(socket.AF_INET , socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,-1)
    server.bind(('',22))
    server.listen()

    while True:
            client,addr=server.accept()
            print(f"connection from{addr[0]}:{addr[1]}")
            t=threading.Thread(target=client_handle,args=(client))





if __name__== "__main__":
    main()   