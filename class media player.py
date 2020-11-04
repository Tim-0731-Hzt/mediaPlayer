import vlc

class VLCPlayer(App):
    def __init__(self):
        super().__init__()
        self.media_list_player = vlc.MediaListPlayer()
        self.media_player = media_list_player.get_media_player()
        self.instance = vlc.Instance() 
        self.media_list = instance.media_list_new() 
        self.volume = 80
        self.media_player.get_media_player().audio_set_volume(volume)