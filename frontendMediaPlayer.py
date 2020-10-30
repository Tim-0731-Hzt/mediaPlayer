from tkinter import *
from tkinter import ttk
import threading
import os
from socket import *
import vlc
from time import sleep
import math

# playlist = ['Die_Very_Rough','Miss_You','Throat_Baby','Cat_Girls_Are_Running_My_Life']
playlist = []
# global variable
num = 0
is_pause = False
is_playing = False
other_operation = None
volume = 80 # defualt value
# creating a media player
media_player = vlc.MediaListPlayer() 
player = vlc.Instance() 
media_list = player.media_list_new() 
media_player.get_media_player().audio_set_volume(volume)
# add song   
for entry in os.listdir(path='./audio/'):
    if (".mp3" in entry):
        playlist.append(entry.split(".mp3")[0])
        media = player.media_new("audio/" + entry) 
        media_list.add_media(media) 

media_player.set_media_list(media_list)

for song in playlist:
    print(song)


# for song in playlist:
#     media = player.media_new("audio/" + song + ".mp3") 
#     media_list.add_media(media) 
#     media_player.set_media_list(media_list)

# change song by direction
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

    song_name.set(playlist[num])

    print ("select " + playlist[num] + " from " + str(playlist))


def mediaPlayer():
    global is_playing
    global num
    global other_operation 
    global volume
    global is_pause
    is_pause = False
    while True:
        if (is_playing):
            if (is_pause):
                # continue playing
                media_player.set_pause(0) 
                print ("continue playing " + playlist[num])
            else:    
                media_player.play_item_at_index(num) 
                song_name.set(playlist[num])
                print ("playing " + playlist[num])
            # sleep(5)
            while media_player.is_playing():
                updateProgress()
                # check if user press stop button when the song is playing
                if (is_playing):
                    # check if user press next when the song is playing
                    if (other_operation == 'next' or other_operation == 'back'):
                        is_playing = False
                        is_pause = False
                        # if 'next' is pressed, the song will be stopped
                        print ("stop playing " + playlist[num])
                        changeSong(other_operation)
                        other_operation = None
                        media_player.stop()
                        is_playing = True
                        break
                    if (other_operation == 'volume'):
                        other_operation = None
                        print("volume change to " + str(volume))
                        media_player.get_media_player().audio_set_volume(volume)
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
            if (other_operation == 'volume'):
                other_operation = None
                print("volume change to " + str(volume))
                media_player.get_media_player().audio_set_volume(volume)
    

def udp_server():
    operation = None
    global other_operation
    global is_playing
    global num
    global volume
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
        elif (operation == '0'):
            volume = 0
            other_operation = 'volume'
        elif (operation == '5'):
            volume = 5
            other_operation = 'volume'
        elif (operation == '10'):
            volume = 10
            other_operation = 'volume'
        elif (operation == '15'):
            volume = 15
            other_operation = 'volume'
        elif (operation == '20'):
            volume = 20
            other_operation = 'volume'
        elif (operation == '25'):
            volume = 25
            other_operation = 'volume'
        elif (operation == '30'):
            volume = 30
            other_operation = 'volume'
        elif (operation == '35'):
            volume = 35
            other_operation = 'volume'
        elif (operation == '40'):
            volume = 40
            other_operation = 'volume'
        elif (operation == '45'):
            volume = 45
            other_operation = 'volume'
        elif (operation == '50'):
            volume = 50
            other_operation = 'volume'
        elif (operation == '55'):
            volume = 55
            other_operation = 'volume'
        elif (operation == '60'):
            volume = 60
            other_operation = 'volume'
        elif (operation == '65'):
            volume = 65
            other_operation = 'volume'
        elif (operation == '70'):
            volume = 70
            other_operation = 'volume'
        elif (operation == '75'):
            volume = 75
            other_operation = 'volume'
        elif (operation == '80'):
            volume = 80
            other_operation = 'volume'
        elif (operation == '85'):
            volume = 85
            other_operation = 'volume'
        elif (operation == '90'):
            volume = 90
            other_operation = 'volume'
        elif (operation == '95'):
            volume = 95
            other_operation = 'volume'
        elif (operation == '100'):
            volume = 100
            other_operation = 'volume'

def previousSong():
    global other_operation
    other_operation = 'back'

def playSong():
    global is_playing
    if is_playing == True:
        is_playing = False
        play_button_text.set("Play")
    else:
        is_playing = True
        play_button_text.set("Stop")

def pauseSong():
    global is_pause
    is_pause = True

def nextSong():
    global other_operation
    other_operation = 'next'

def updateProgress():
    song_progress.set(media_player.get_media_player().get_position() * 100)
    time_number = (media_player.get_media_player().get_time() / 1000)
    song_time.set(str(math.floor(time_number/60)) + ":" + str(math.floor(time_number%60/10)) + str(math.floor((time_number%60)%10)))
    duration_number = (media_player.get_media_player().get_length() / 1000)
    song_duration.set(str(math.floor(duration_number/60)) + ":" + str(math.floor(duration_number%60/10)) + str(math.floor((duration_number%60)%10)))


if __name__ == "__main__":
    root = Tk()
    root.title("Violet Player")

    mainframe = ttk.Frame(root, padding="12 12 12 12")
    mainframe.grid(sticky="S")

    song_name = StringVar()
    song_time = DoubleVar()
    song_duration = StringVar()
    play_button_text = StringVar()
    play_button_text.set("Play")
    song_progress = StringVar()


    nameLabel = ttk.Label(mainframe, text="Song Name:").grid(column=0, row=1)
    songNameLabel = ttk.Label(mainframe, textvariable=song_name)
    songNameLabel.grid(columnspan=4, row=1, sticky="E")
    songProgressBar = ttk.Progressbar(mainframe, variable=song_progress, mode="determinate")
    songProgressBar.grid(columnspan=4, sticky="W E", row=2)

    songTime = ttk.Label(mainframe, textvariable=song_time).grid(column=0, row=3, sticky="W")
    songDuration = ttk.Label(mainframe, textvariable=song_duration).grid(column=1, columnspan=3, row=3, sticky="E")

    previousButton = ttk.Button(mainframe, text="<<", command=previousSong).grid(column=0, row=4)
    playButton = ttk.Button(mainframe, textvariable=play_button_text, command=playSong).grid(column=1, row=4)
    pauseButton = ttk.Button(mainframe, text="Pause", command=pauseSong).grid(column=2, row=4)
    nextButton = ttk.Button(mainframe, text=">>", command=nextSong).grid(column=3, row=4)

    mainframe.pack(expand=True)
    # select the first song in playlist as default
    print ("select " + playlist[num] + " from " + str(playlist))
    # create threads
    mediaPlayer = threading.Thread(target = mediaPlayer)
    mediaPlayer.start()
    server = threading.Thread(target = udp_server)
    server.start()
    # is_playing = True
    root.mainloop()