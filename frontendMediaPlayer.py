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

global is_enabled
is_enabled = True
# media_player.set_playback_mode(1)
# add song   
for entry in os.listdir(path='./audio/'):
    if (".mp3" in entry or ".wav" in entry):
        playlist.append(entry.split(".")[0])
        media = player.media_new("audio/" + entry) 
        media_list.add_media(media) 

media_player.set_media_list(media_list)

for song in playlist:
    print(song)


# for song in playlist:
#     media = player.media_new("audio/" + song + ".mp3") 
#     media_list.add_media(media) 
#     media_player.set_media_list(media_list)

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
                # print ("playing " + playlist[num])
                sleep(0.15)
                set_meta_data()
            # sleep(5)
            while media_player.is_playing():
                updateProgress()
                checkSongEnd()
                # check if user press stop button when the song is playing
                if (is_playing):
                    # check if user press next when the song is playing
                    if (other_operation == 'next' or other_operation == 'back'):
                        # is_playing = False
                        is_pause = False
                        # if 'next' is pressed, the song will be stopped
                        # print ("stop playing " + playlist[num])
                        changeSong(other_operation)
                        other_operation = None
                        break
                    # sleep(1)
                else:
                    media_player.set_pause(1) 
                    is_pause = True
                    print ("stop playing ")
                
                sleep(0.05)


        elif (other_operation != None):
            if (other_operation == 'next' or other_operation == 'back'):
                # print("outer loop next")
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
        global is_enabled
        if is_enabled == False:
            player_interrupt.wait()

        message, clientAddress = server.recvfrom(2048)
        result = message.decode().split()
        operation = result[0]
        if (operation == 'play'):
            is_playing = True
        elif (operation == 'pause'):
            is_playing = False
        elif (operation == 'stop'):
            stopSong()
        elif (operation == 'next'):
            other_operation = 'next'
        elif (operation == 'back'):
            other_operation = 'back'
        elif operation == 'volumeup':
            increaseVolume()
        elif operation == 'volumedown':
            decreaseVolume()
        elif operation == "ffwd":
            fastForward()
        elif operation == 'rwd':
            rewind()
        elif operation == 'toggle':
            playSong()
        elif operation == 'mute':
            muteButton()

        sleep(0.1)

# change song by direction
def changeSong(direction):
    global num
    if (direction == 'next'):
        if (num == len(playlist) - 1):
            endPlaylist()
            # return
            # num = 0
        else:
            num += 1
    else:
        if (num == 0):
            num = len(playlist) - 1
        else:
            num -= 1


    updatePlaylistDisplay()
    media_player.stop()

    # global is_playing
    # is_playing = True
    print ("select " + playlist[num] + " from " + str(playlist))

def updatePlaylistDisplay():
    song_name.set(playlist[num])
    playlist_display.select_clear(0, "end")
    playlist_display.selection_set(num)
    playlist_display.activate(num)

def set_meta_data():
    m = media_player.get_media_player().get_media()
    result = m.get_meta(1)
    if result == None:
        artist_name.set("Unknown")
    else:
        artist_name.set(result)

def endPlaylist():
    global num
    global is_playing
    num = 0
    is_playing = False
    noSongDisplay()
    updatePlaylistDisplay()

def noSongDisplay():
    play_button_text.set("Play")
    song_progress.set(0)
    song_time.set("0:00")
    song_duration.set("0:00")
    song_name.set("")
    resetProgress()


def checkSongEnd():
    p = media_player.get_media_player()
    if (p.get_time() >= p.get_length() and p.get_time() != -1):
        global other_operation
        other_operation = "next"

        
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
        # is_pause = False
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

def muteButton():
    p = media_player.get_media_player()
    p.audio_toggle_mute()
    if (p.audio_get_mute() == True):
        mute_button["image"] = unmute_image
    else:
        mute_button["image"] = mute_image

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
    new_song = fd.askopenfile(initialdir = os.getcwd, filetypes=(("Audio Files", ("*.mp3", "*.wav")),("All Files","*.*")))
    if new_song == None:
        return
    new_path = os.path.basename(new_song.name)
    new_name = new_path.split(".")[0]
    print(new_name)
    global playlist
    if playlist == []:
        new_medialist = player.media_list_new()
        media_player.set_media_list(new_medialist)
        media_list = new_medialist
    elif new_name in playlist:
        return

    playlist.append(new_name)
    media = player.media_new(new_song.name) 
    media_list.add_media(media)
    # is_playing = True
    next_song_var.set(playlist)
    enableControls()

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
        media_list = new_medialist
        global playlist
        playlist = new_playlist
        next_song_var.set(playlist)
        global num
        num = 0

def disableControls():
    buttons = [play_button, stop_button, ffwd_button, rewind_button, next_button, decrease_volume_button, increase_volume_button, back_button]
    for button in buttons:
        button.state(["disabled"])

    volume_control.config(state=DISABLED)
    global is_enabled
    is_enabled = False
    

def enableControls():
    buttons = [play_button, stop_button, ffwd_button, rewind_button, next_button, decrease_volume_button, increase_volume_button, back_button]
    for button in buttons:
        button.state(["!disabled"])

    volume_control.config(state=NORMAL)
    global is_enabled
    is_enabled = False
    player_interrupt.set()

def rewind():
    p =  media_player.get_media_player()
    next_time = p.get_position() - 0.05
    if (next_time > 0):
        p.set_position(next_time)
    else:
        p.set_position(0.0)
    updateProgress()

def fastForward():
    p =  media_player.get_media_player()
    next_time = p.get_position() + 0.05
    if (next_time < 1.0):
        p.set_position(next_time)
    else:
        p.set_position(1.0)
    updateProgress()
    checkSongEnd()

def clearPlaylist():
    stopSong()
    global playlist
    playlist = []
    noSongDisplay()
    disableControls()
    next_song_var.set(playlist)
    media_player.stop()
    sleep(0.2)
    global is_pause
    is_pause = False
    print("pause = false")
    global num
    num = 0



def updateProgress():
    if media_player.get_media_player().get_position() < 0:
        resetProgress()
    else:
        song_progress.set(media_player.get_media_player().get_position() * 100)
        time_number = (media_player.get_media_player().get_time() / 1000)
        song_time.set(str(math.floor(time_number/60)) + ":" + str(math.floor(time_number%60/10)) + str(math.floor((time_number%60)%10)))
        duration_number = (media_player.get_media_player().get_length() / 1000)
        song_duration.set(str(math.floor(duration_number/60)) + ":" + str(math.floor(duration_number%60/10)) + str(math.floor((duration_number%60)%10)))
    # print(str(time_number) + ", " + str(duration_number))


if __name__ == "__main__":
    root = Tk()
    root.title("Violet Player")
    # root.geometry("500x500")
    # mainframe = ttk.Frame(root, padding="12 12 12 12")
    mainframe = Frame(root)
    mainframe.grid(sticky=N+S+E+W)

    song_name = StringVar()
    artist_name = StringVar()
    song_time = DoubleVar()
    song_duration = StringVar()
    play_button_text = StringVar()
    play_button_text.set("Play")
    song_progress = StringVar()
    song_progress.set("0.0")


    open_song_button = ttk.Button(mainframe, text="Add song to queue", command=openSong).grid(column=0, columnspan=2, row=0, sticky="W")
    clear_queue_button = ttk.Button(mainframe, text="Clear Queue", command=clearPlaylist).grid(column=2, columnspan=2, sticky="N", row=0)
    open_folder_button = ttk.Button(mainframe, text="Playlist from folder", command=openFolder).grid(column=4, columnspan=2, row=0, sticky="E")

    name_label = ttk.Label(mainframe, text="Song Name:").grid(column=0, row=1, sticky="W")
    song_name_label = ttk.Label(mainframe, textvariable=song_name, width=70)
    song_name_label.grid(column=1, columnspan=5, row=1, sticky="E")

    artist_label = ttk.Label(mainframe, text="Artist:").grid(column=0, row=2, sticky="W")
    artist_name_label = ttk.Label(mainframe, textvariable=artist_name, width=70)
    artist_name_label.grid(column=1, columnspan=5, row=2, sticky="E")
    
    song_progress_bar = ttk.Progressbar(mainframe, variable=song_progress, mode="determinate")
    song_progress_bar.grid(columnspan=6, sticky="W E", row=3)

    song_time_display = ttk.Label(mainframe, textvariable=song_time).grid(column=0, row=4, sticky="W")
    song_duration_display = ttk.Label(mainframe, textvariable=song_duration).grid(column=5, row=4, sticky="E")

    back_button = ttk.Button(mainframe, text="Back", command=previousSong)
    back_button.grid(column=0, row=5)
    rewind_button = ttk.Button(mainframe, text="<<", command=rewind)
    rewind_button.grid(column=1, row=5)

    play_button = ttk.Button(mainframe, textvariable=play_button_text, command=playSong)
    play_button.grid(column=2, row=5)
    stop_button = ttk.Button(mainframe, text="Stop", command=stopSong)
    stop_button.grid(column=3, row=5)

    ffwd_button = ttk.Button(mainframe, text=">>", command=fastForward)
    ffwd_button.grid(column=4, row=5)
    next_button = ttk.Button(mainframe, text="Next", command=nextSong)
    next_button.grid(column=5, row=5, sticky="E")

    volume_variable = IntVar()
    volume_variable.set(volume)


    volume_control = Scale(mainframe, variable=volume_variable, from_=0, to=100, showvalue=0, resolution=5, orient=HORIZONTAL, command=barVolume)
    volume_control.grid(column=0, row=6, columnspan=6, sticky="E W")

    decrease_volume_button = ttk.Button(mainframe, text="-", command=decreaseVolume)
    decrease_volume_button.grid(column=0, row=8, sticky="W")

    volume_display = ttk.Label(mainframe, textvariable=volume_variable)
    volume_display.grid(column=2, columnspan=2, row=7)

    mute_image = PhotoImage(file="mute.png")
    unmute_image = PhotoImage(file="unmute.png")

    mute_button = Button(mainframe, image=unmute_image, command=muteButton)
    mute_button.grid(column=2, columnspan=2, row=8)

    increase_volume_button = ttk.Button(mainframe, text="+", command=increaseVolume)
    increase_volume_button.grid(column=5, row=8, sticky="E")

    next_song_var = StringVar(value=playlist)

    playlist_display = Listbox(mainframe, selectmode="single", listvariable=next_song_var)
    playlist_display.grid(row=9, columnspan=6, sticky="W E")
    playlist_display.selection_set(0)
    playlist_display.selection_anchor(0)
    playlist_display.activate(num)
    playlist_display.bindtags((playlist_display, mainframe, "all"))

    # for i in range(0,7):
    #     Grid.columnconfigure(mainframe, i, weight=1)
    #     Grid.rowconfigure(mainframe, i, weight=1)

    for child in mainframe.winfo_children():
        child.grid(padx=5, pady=5)

    # select the first song in playlist as default
    # print ("select " + playlist[num] + " from " + str(playlist))
    # create threads

    player_interrupt = threading.Event()

    media_player_thread = threading.Thread(target = mediaPlayer)
    media_player_thread.start()
    server_thread = threading.Thread(target = udp_server)
    server_thread.start()

    # disableControls()

    root.protocol("WM_DELETE_WINDOW", close_window)
    noSongDisplay()



    icon_image = PhotoImage(file="./Logo/logo_no_background.png")
    root.iconphoto(False, icon_image)
    s = ttk.Style()
    # print(s.element_options('Button.label'))
    s.theme_use('clam')
    # s.configure('TButton', bordercolor="violet")
    volume_control.configure(highlightbackground="#bc4899", highlightthickness=3, borderwidth=0, troughcolor="#bab5ab", background="violet", activebackground="violet")
    # volume_control.configure(highlightthickness=0, bordercolor='#bc4899', troughcolor="#bab5ab")
    s.configure('Horizontal.TProgressbar', background="#bc4899")
    # button_image = PhotoImage(file="button.png")
    s.configure('TButton', font=("Helvetica", 10))

    mainframe.configure(highlightcolor='#bc4899', highlightbackground='#bc4899', highlightthickness=10, borderwidth=20, background="violet")
    playlist_display.configure(selectbackground="#bc4899", background="#bab5ab", highlightthickness=3, highlightbackground="#bc4899", foreground="#000000")
    # is_playing = True
    root.mainloop()