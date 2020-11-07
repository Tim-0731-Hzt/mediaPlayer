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
# media_player.set_playback_mode(1)
# add song   
# for entry in os.listdir(path='./audio/'):
#     if (".mp3" in entry or ".wav" in etry):
#         playlist.append(entry.split(".")[0])
#         media = player.media_new("audio/" + entry) 
#         media_list.add_media(media) 

# media_player.set_media_list(media_list)

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
            # endPlaylist()
            # return
            num = 0
        else:
            num += 1
    else:
        if (num == 0):
            num = len(playlist) - 1
        else:
            num -= 1


    updatePlaylistDisplay()
    media_player.stop()

    global is_playing
    is_playing = True
    print ("select " + playlist[num] + " from " + str(playlist))

def updatePlaylistDisplay():
    song_name.set(playlist[num])
    playlist_display.select_clear(0, "end")
    playlist_display.selection_set(num)
    playlist_display.activate(num)

def endPlaylist():
    global num
    global is_playing
    num = 0
    is_playing = False
    play_button_text.set("Play")
    playlist_display.select_clear(0, "end")
    playlist_display.selection_set(num)
    playlist_display.activate(num)

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
                sleep(0.05)
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

        sleep(0.1)
    

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

        sleep(0.1)
        
        
def close_window():
    os._exit(0)

def previousSong():
    global other_operation
    other_operation = 'back'

def playSong():
    global is_playing
    global is_pause
    if is_playing == True:
        is_playing = False
        is_pause = True
        play_button_text.set("Play")
    else:
        is_playing = True
        play_button_text.set("Pause")

def stopSong():
    global is_playing
    if (is_playing):
        playSong()
    p =  media_player.get_media_player()
    p.set_position(0)
    sleep(0.1)
    resetProgress()

def nextSong():
    global other_operation
    other_operation = 'next'

def barVolume(newVal):
    global volume
    volume = int(newVal)
    volume_variable.set(newVal)
    media_player.get_media_player().audio_set_volume(volume)

def increaseVolume():
    global volume
    if volume == 100:
        return
    else:
        volume += 5
    volume_variable.set(volume)
    media_player.get_media_player().audio_set_volume(volume)

def decreaseVolume():
    global volume
    if volume == 0:
        return
    else:
        volume -= 5
    volume_variable.set(volume)
    media_player.get_media_player().audio_set_volume(volume)

def resetProgress():
    song_progress.set(0)
    song_time.set("0:00")
    duration_number = (media_player.get_media_player().get_length() / 1000)
    song_duration.set(str(math.floor(duration_number/60)) + ":" + str(math.floor(duration_number%60/10)) + str(math.floor((duration_number%60)%10)))

def openSong():
    # if (is_playing):
    #     playSong()
    new_song = fd.askopenfile(initialdir = os.getcwd, filetypes=(("mp3 files", "*.mp3"),("all files","*.*")))
    if new_song == None:
        return
    new_name = os.path.basename(new_song.name)
    playlist.append(new_name)
    media = player.media_new(new_song.name) 
    media_list.add_media(media) 
    global num
    num = playlist.index(new_name)
    # is_playing = True

def openFolder():
    new_medialist = player.media_list_new() 
    new_playlist = []
    directory = fd.askdirectory(initialdir = os.getcwd)
    if directory == None:
        return
    print(directory)
    for entry in os.listdir(directory):
        print(entry)
        if (".mp3" in entry or ".wav" in entry):
            new_playlist.append(entry.split(".")[0])
            media = player.media_new(directory +  "/" + entry) 
            new_medialist.add_media(media) 

    print(new_medialist.count())

    if new_medialist.count() > 0:
        enableControls()
        media_player.set_media_list(new_medialist)
        global playlist
        playlist = new_playlist
        next_song_var.set(playlist)
        global num
        num = 0
        global is_playing
        is_playing = True
        updatePlaylistDisplay()

def disableControls():
    buttons = [play_button, stop_button, ffwd_button, rewind_button, next_button, decrease_volume_button, increase_volume_button, back_button]
    for button in buttons:
        button.state(["disabled"])

    volume_control.config(state=DISABLED)

def enableControls():
    buttons = [play_button, stop_button, ffwd_button, rewind_button, next_button, decrease_volume_button, increase_volume_button, back_button]
    for button in buttons:
        button.state(["!disabled"])

    volume_control.config(state=NORMAL)

def rewind():
    p =  media_player.get_media_player()
    p.set_position(p.get_position() - 0.05)
    updateProgress()

def fastForward():
    p =  media_player.get_media_player()
    p.set_position(p.get_position() + 0.05)
    updateProgress()

def updateProgress():
    song_progress.set(media_player.get_media_player().get_position() * 100)
    time_number = (media_player.get_media_player().get_time() / 1000)
    song_time.set(str(math.floor(time_number/60)) + ":" + str(math.floor(time_number%60/10)) + str(math.floor((time_number%60)%10)))
    duration_number = (media_player.get_media_player().get_length() / 1000)
    song_duration.set(str(math.floor(duration_number/60)) + ":" + str(math.floor(duration_number%60/10)) + str(math.floor((duration_number%60)%10)))
    # print(str(time_number) + ", " + str(duration_number))

    if (time_number >= duration_number):
        nextSong()


if __name__ == "__main__":
    root = Tk()
    root.title("Violet Player")
    # root.geometry("500x500")
    mainframe = ttk.Frame(root, padding="12 12 12 12")
    mainframe.grid(sticky=N+S+E+W)

    song_name = StringVar()
    song_time = DoubleVar()
    song_duration = StringVar()
    play_button_text = StringVar()
    play_button_text.set("Play")
    song_progress = StringVar()
    song_progress.set("0.0")


    open_song_button = ttk.Button(mainframe, text="Choose song", command=openSong).grid(column=0, row=0, sticky="W")
    open_folder_button = ttk.Button(mainframe, text="Open songs from folder", command=openFolder).grid(column=4, columnspan=2, row=0, sticky="E")

    name_label = ttk.Label(mainframe, text="Song Name:").grid(column=0, row=1)
    song_name_label = ttk.Label(mainframe, textvariable=song_name, width=70)
    song_name_label.grid(column=1, columnspan=5, row=1, sticky="E")
    song_progress_bar = ttk.Progressbar(mainframe, variable=song_progress, mode="determinate")
    song_progress_bar.grid(columnspan=6, sticky="W E", row=2)

    song_time_display = ttk.Label(mainframe, textvariable=song_time).grid(column=0, row=3, sticky="W")
    song_duration_display = ttk.Label(mainframe, textvariable=song_duration).grid(column=5, row=3, sticky="E")

    back_button = ttk.Button(mainframe, text="Back", command=previousSong)
    back_button.grid(column=0, row=4)
    rewind_button = ttk.Button(mainframe, text="<<", command=rewind)
    rewind_button.grid(column=1, row=4)

    play_button = ttk.Button(mainframe, textvariable=play_button_text, command=playSong)
    play_button.grid(column=2, row=4)
    stop_button = ttk.Button(mainframe, text="Stop", command=stopSong)
    stop_button.grid(column=3, row=4)

    ffwd_button = ttk.Button(mainframe, text=">>", command=fastForward)
    ffwd_button.grid(column=4, row=4)
    next_button = ttk.Button(mainframe, text="Next", command=nextSong)
    next_button.grid(column=5, row=4)

    volume_variable = IntVar()
    volume_variable.set(volume)

    volume_control = Scale(mainframe, variable=volume_variable, from_=0, to=100, resolution=5, showvalue=0, orient=HORIZONTAL, command=barVolume)
    volume_control.grid(column=0, row=5, columnspan=6, sticky="E W")

    decrease_volume_button = ttk.Button(mainframe, text="-", command=decreaseVolume)
    decrease_volume_button.grid(column=0, row=6, sticky="W")

    volume_display = ttk.Label(mainframe, textvariable=volume_variable)
    volume_display.grid(column=2, columnspan=2, row=6)

    increase_volume_button = ttk.Button(mainframe, text="+", command=increaseVolume)
    increase_volume_button.grid(column=5, row=6, sticky="E")

    next_song_var = StringVar(value=playlist)

    playlist_display = Listbox(mainframe, selectmode="single", listvariable=next_song_var)
    playlist_display.grid(row=7, columnspan=6, sticky="W E")
    playlist_display.selection_set(0)
    playlist_display.selection_anchor(0)
    playlist_display.activate(num)
    playlist_display.bindtags((playlist_display, mainframe, "all"))

    for i in range(0,7):
        Grid.columnconfigure(mainframe, i, weight=1)
        Grid.rowconfigure(mainframe, i, weight=1)


    # select the first song in playlist as default
    # print ("select " + playlist[num] + " from " + str(playlist))
    # create threads
    mediaPlayer = threading.Thread(target = mediaPlayer)
    mediaPlayer.start()
    server = threading.Thread(target = udp_server)
    server.start()

    disableControls()

    root.protocol("WM_DELETE_WINDOW", close_window)
    # is_playing = True
    root.mainloop()