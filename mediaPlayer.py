import threading
from socket import *
import vlc
from time import sleep

playlist = ['Die_Very_Rough', 'Miss_You', 'Throat_Baby']
num = 0
is_playing = False
other_operation = None
def media_player():
    global is_playing
    global num
    global other_operation
    print ("select " + playlist[num])
    while True:
        if (is_playing):
            media_player = vlc.MediaPlayer('/audio/' + playlist[num] + ".mp3") 
            media_player.play() 
            print ("playing " + playlist[num])
            sleep(5)
            while media_player.is_playing():
                if (is_playing):
                    if (other_operation == 'next'):
                        other_operation = None
                        is_playing = False
                        print ("sttop")
                        media_player.stop()
                    sleep(1)
                else:
                    media_player.pause()
                    print ("stop")
   

def udp_server():
    operation = None
    global other_operation
    global is_playing
    global num
    server = socket(AF_INET, SOCK_DGRAM)
    server.bind(("127.0.0.1", 12000))
    while True:
        message, clientAddress = server.recvfrom(2048)
        result = message.decode().split()
        operation = result[0]
        if (operation == 'play'):
            is_playing = True
        elif (operation == 'stop'):
            is_playing = False
        elif (operation == 'next'):
            other_operation = 'next'
            if (num == 2):
                num = 0
            else:
                num += 1
            print ("select " + playlist[num])
        #sleep(3)

if __name__ == "__main__":
    mediaPlayer = threading.Thread(target = media_player)
    mediaPlayer.start()
    server = threading.Thread(target = udp_server)
    server.start()
    