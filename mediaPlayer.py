import threading
from socket import *
import vlc
from time import sleep

playlist = ['Die_Very_Rough','Miss_You','Throat_Baby','Cat_Girls_Are_Running_My_Life']
# global variable
num = 0
is_playing = False
other_operation = None
# creating a media player
media_player = vlc.MediaListPlayer() 
player = vlc.Instance() 
media_list = player.media_list_new() 
# add song  
for song in playlist:
    media = player.media_new("/audio/" + song + ".mp3") 
    media_list.add_media(media) 
    media_player.set_media_list(media_list)

def changeSong(direction):
    global num
    if (direction == 'next'):
        if (num == len(playlist) - 1):
            num = 0
        else:
            num += 1
    else:
        if (num == 0):
            num = len(playlist) - 1
        else:
            num -= 1

    print ("select " + playlist[num] + " from " + str(playlist))


def mediaPlayer():
    global is_playing
    global num
    global other_operation 
    is_pause = False
    while True:
        if (is_playing):
            if (is_pause):
                # continue playing
                media_player.set_pause(0) 
                print ("continue playing " + playlist[num])
            else:    
                media_player.play_item_at_index(num) 
                print ("playing " + playlist[num])
            sleep(5)
            while media_player.is_playing():
                # check if user press stop button when the song is playing
                if (is_playing):
                    # check if user press next when the song is playing
                    if (other_operation == 'next' or other_operation == 'back'):
                        is_playing = False
                        is_pause = False
                        print ("stop playing " + playlist[num])
                        changeSong(other_operation)
                        other_operation = None
                        media_player.stop()
                        break
                    sleep(1)
                else:
                    media_player.set_pause(1) 
                    is_pause = True
                    print ("stop playing " + playlist[num])
        elif (other_operation != None):
            if (other_operation == 'next' or other_operation == 'back'):
                changeSong(other_operation)
                other_operation = None
                is_pause = False
            

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
        elif (operation == 'back'):
            other_operation = 'back'

if __name__ == "__main__":
    # select the first song in playlist as default
    print ("select " + playlist[num] + " from " + str(playlist))
    # create threads
    mediaPlayer = threading.Thread(target = mediaPlayer)
    mediaPlayer.start()
    server = threading.Thread(target = udp_server)
    server.start()
    
