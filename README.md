# fzf-wuzzy 🐻
A collection of fzf scripts for common system tasks. Originally built with Sway in mind, but could be adapted to any window manager.

## Overview
| Script | Description |
|--------|-------------|
| `audio_output.sh` | Switch between audio output devices |
| `bluetooth.sh` | Connect/disconnect Bluetooth devices |
| `bookmarks.sh` | Browse and open bookmarks from CSV in default browser |
| `books.sh` | Browse and open ebooks (PDF/EPUB) in Zathura |
| `config.sh` | Edit dotfiles |
| `control.sh` | Control panel with shortcuts to all scripts and session control options |
| `films.sh` | Browse and play films in MPV |
| `games.sh` | Launch games via various emulators/launchers |
| `grim.sh` | Take screenshots (Wayland) |
| `kill.sh` | Kill a running process |
| `launcher.sh` | Launch GUI applications (like Rofi)|
| `man.sh` | Search and read manual pages |
| `media.sh` | Hub for all media (books/films/music/TV/games) |
| `music.sh` | Browse and play music with MPV |
| `notes.sh` | Browse and edit notes (CSV/MD/TEX/TXT) |
| `overview.sh` | Display system information |
| `projects.sh` | Open programming projects in VS Code |
| `television.sh` | Browse TV shows by season/episode |
| `themes.sh` | Switch GTK and icon theme |
| `wallpapers.sh` | Preview and set wallpapers |
| `youtube.sh` | Search for and watch YouTube videos in MPV |

## Requirements
* `fzf`
* `awk` 
* `grep` 
* `find`
* `sed` 
* `bluetoothctl` - Bluetooth menu
* `pactl`, `pavucontrol` - Audio control
* `mpv` - Media playback
* `zathura` - Document viewing
* `grim`, `slurp` - Screenshots (Wayland)
* `swaymsg` - Sway integration
* `flatpak` - Flatpak app launching
* `nvim` - Text editing
* `yt-dlp` - YouTube integration

## Installation
1. Clone the repository:
```
git clone https://github.com/nniemeir/fzf-wuzzy ~/.fzf-wuzzy
```

2. Modify the paths in ~/.fzf-wuzzy/config/preferences.conf to suit your system

## Usage
Scripts can be run directly or bound to hotkeys in your window manager.

**Standalone:**
```
~/.fzf-wuzzy/scripts/launcher.sh
```

**Example Sway binding:**
```
bindsym $mod+r exec $term -e ~/.fzf-wuzzy/scripts/launcher.sh
```

## Bookmarks Configuration
The `bookmarks.sh` script uses a CSV file to map bookmark names to their corresponding URLs. 
```
Title;Link
Film | The Criterion Channel;https://www.criterionchannel.com/browse
```

## Games Configuration
The `games.sh` script uses a CSV file (config/games.csv) to map games to their runners:
```
Title;Runner;ID or ROM filename
Cyberpunk 2077;Steam;1091500
DOOM;None;gzdoom -file BRUTAL.pk3
God Of War II;PCSX2;~/ROMS/PS2/GOWII.iso
```

#### Supported Runners
* Blastem (Flatpak)
* bsnes (Flatpak)
* DeSmuME (Flatpak)
* Heroic 
* Lutris
* mGBA (Flatpak)
* Nestopia (Flatpak)
* PCSX2 (Flatpak)
* PPSSPP (Flatpak)
* RPCS3 (Flatpak)
* Steam

## Window Manager Integration
For scripts that should appear briefly, it can be helpful to set floating window rules:

**Example In Sway:**
```
for_window [app_id="shortmenu"] {
    floating enable
    resize set 1280 720
    move position center
}
```

Then specify the app-id in the hotkey:
```
bindsym $mod+r exec kitty --app-id shortmenu -e ~/.fzf-wuzzy/scripts/launcher.sh
```

## License
GNU General Public License V2

Copyright (c) 2026 Jacob Niemeir

## Acknowledgments
* Built with [fzf](https://github.com/junegunn/fzf)
* Audio switching script is a modified version of [Bread On Penguins](https://www.youtube.com/@BreadOnPenguins)