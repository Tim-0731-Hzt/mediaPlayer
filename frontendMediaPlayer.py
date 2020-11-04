from tkinter import *
from tkinter import ttk
import tkinter.filedialog as fd
import threading
import os
from socket import *
import vlc
from time import sleep
import math

# playlist = ['Die_Very_Rough','Miss_You','Throat_Baby','Cat_Girls_Are_Running_My_Life']
global playlist
playlist = []
# global variable
num = 0
is_pause = False
is_playing = False
other_operation = None
volume = 50 # defualt value
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

    playlistDisplay.select_clear(0, "end")
    playlistDisplay.selection_set(num)
    playlistDisplay.activate(num)

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
                    # sleep(1)
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
        elif operation == 'volumeup':
            increaseVolume()
        elif operation == 'volumedown':
            decreaseVolume()
        
def close_window():
    os._exit(0)

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

def barVolume(newVal):
    if int(newVal) > volumeVariable.get():
        increaseVolume()
    else:
        decreaseVolume()


def increaseVolume():
    global volume
    if volume == 100:
        return
    else:
        volume += 5
    volumeVariable.set(volume)
    media_player.get_media_player().audio_set_volume(volume)
def decreaseVolume():
    global volume
    if volume == 0:
        return
    else:
        volume -= 5
    volumeVariable.set(volume)
    media_player.get_media_player().audio_set_volume(volume)

def openSong():
    new_song = fd.askopenfile(initialdir = os.getcwd, filetypes=(("mp3 files", "*.mp3"),("all files","*.*")))
    new_name = os.path.basename(new_song.name)
    playlist.append(new_name)
    media = player.media_new(new_song.name) 
    media_list.add_media(media) 
    global num
    num = playlist.index(new_name)
    is_playing = True

def openFolder():
    new_medialist = player.media_list_new() 
    new_playlist = []
    directory = fd.askdirectory(initialdir = os.getcwd)
    print(directory)
    for entry in os.listdir(directory):
        print(entry)
        if (".mp3" in entry):
            new_playlist.append(entry.split(".mp3")[0])
            media = player.media_new(directory +  "/" + entry) 
            new_medialist.add_media(media) 

    print(new_medialist.count())

    if new_medialist.count() > 0:
        media_player.set_media_list(new_medialist)
        global playlist
        playlist = new_playlist
        global num
        num = 0


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


    openSongButton = ttk.Button(mainframe, text="Choose song", command=openSong).grid(column=0, row=0, sticky="W")
    openFolderButton = ttk.Button(mainframe, text="Open songs from folder", command=openFolder).grid(column=2, columnspan=2, row=0, sticky="E")

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

    volumeVariable = IntVar()
    volumeVariable.set(volume)

    volumeControl = Scale(mainframe, variable=volumeVariable, from_=0, to=100, resolution=5, showvalue=0, orient=HORIZONTAL, command=barVolume)
    volumeControl.grid(column=0, row=5, columnspan=4, sticky="E W")

    decreaseVolumeButton = ttk.Button(mainframe, text="-", command=decreaseVolume)
    decreaseVolumeButton.grid(column=0, row=6, sticky="W")

    volumeDisplay = ttk.Label(mainframe, textvariable=volumeVariable)
    volumeDisplay.grid(column=1, columnspan=2, row=6)

    increaseVolumeButton = ttk.Button(mainframe, text="+", command=increaseVolume)
    increaseVolumeButton.grid(column=3, row=6, sticky="E")

    nextSongVar = StringVar(value=playlist)

    playlistDisplay = Listbox(mainframe, selectmode="single", listvariable=nextSongVar)
    playlistDisplay.grid(row=7, columnspan=4, sticky="W E")
    # playlistDisplay.set
    playlistDisplay.selection_set(0)
    playlistDisplay.selection_anchor(0)
    playlistDisplay.activate(num)
    playlistDisplay.bindtags((playlistDisplay, mainframe, "all"))


    mainframe.pack(expand=True)
    # select the first song in playlist as default
    print ("select " + playlist[num] + " from " + str(playlist))
    # create threads
    mediaPlayer = threading.Thread(target = mediaPlayer)
    mediaPlayer.start()
    server = threading.Thread(target = udp_server)
    server.start()

    root.protocol("WM_DELETE_WINDOW", close_window)
    cv = Canvas(root, width=200, height=200); cv.pack()
    # is_playing = True
    root.mainloop()