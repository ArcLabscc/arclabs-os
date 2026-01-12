<div align="center">

# ArcLabs OS

### ARM64 Linux Desktop for Apple Silicon

![Hyprland](https://img.shields.io/badge/Hyprland-00ff99?style=for-the-badge&logo=hyprland&logoColor=black)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Apple Silicon](https://img.shields.io/badge/Apple_Silicon-000000?style=for-the-badge&logo=apple&logoColor=white)

*A complete, standalone Hyprland desktop environment for Apple Silicon Macs*

**No external dependencies. Everything included.**

</div>

---

## What is This?

ArcLabs OS is a **complete, self-contained** Hyprland desktop rice specifically built for ARM64 Apple Silicon Macs running Asahi Linux.

### Included Out of the Box

- **15 Themes** with animated wallpaper transitions (swww)
- **Glassmorphism UI** - SDDM login, Walker launcher with blur effects
- **Plymouth boot splash** - ArcLabs branded boot screen
- **Full Hyprland configuration** with tiling, workspaces, and animations
- **Waybar** status bar with battery, wifi, bluetooth, media controls
- **Walker + Elephant** application launcher with theme picker
- **Ghostty/Kitty** terminal with custom theme
- **Apple keyboard optimization** - Cmd/Opt swap, keyboard backlight
- **Two-finger right-click** on trackpad
- **TUI utilities** - impala (wifi), bluetuith (bluetooth), pulsemixer (audio)

---

## Tested Hardware

| Device | Status |
|--------|--------|
| MacBook Pro M2 Max | ✓ Fully Working |
| MacBook Pro M1/M2/M3 | Should work |
| Mac Mini M1/M2 | Should work |
| Mac Studio M1/M2 | Should work |

---

## Prerequisites

1. **Asahi Linux** on your Apple Silicon Mac
   - Install from: https://asahilinux.org/

2. **Arch-based system** (Asahi ships with Arch)

3. **AUR helper** (yay or paru) for some packages:
   ```bash
   git clone https://aur.archlinux.org/yay-bin.git
   cd yay-bin && makepkg -si
   ```

---

## Installation

```bash
git clone https://github.com/ArcLabscc/arclabs-os.git
cd arclabs-os
./install.sh
```

Then log out and select **Hyprland (uwsm-managed)** at the SDDM login screen.

### What the Installer Does

The modular installer runs through these phases:

| Phase | Description |
|-------|-------------|
| **Preflight** | Checks architecture, disk space, AUR helper |
| **Packaging** | Installs ~120 packages from official repos + AUR |
| **Config** | Copies configs, sets up themes, shell PATH |
| **Hardware** | Apple keyboard, trackpad, speakers, GPU optimization |
| **Login** | SDDM + UWSM session configuration |

Installation log: `/tmp/arclabs-install.log`

---

## Keybindings

### Essential
| Key | Action |
|-----|--------|
| Super + Return | Terminal |
| Super + Space | App Launcher (Walker) |
| Super + W | Close Window |
| Super + F | Fullscreen |
| Super + V | Float/Tile Toggle |
| Super + 1-9 | Workspaces |
| Super + Shift + 1-9 | Move to Workspace |

### Apps
| Key | Action |
|-----|--------|
| Super + Shift + B | Browser |
| Super + Shift + F | File Manager |
| Super + Shift + T | System Monitor |

### Tiling
| Key | Action |
|-----|--------|
| Super + H/J/K/L | Focus Left/Down/Up/Right |
| Super + Shift + H/J/K/L | Move Window |
| Super + Ctrl + H/L | Resize |

---

## Directory Structure

### Installation Files
```
arclabs-os/                   # Repository
├── install.sh                # Entry point
├── install/                  # Modular installer
│   ├── helpers/              # Logging, errors, presentation
│   ├── preflight/            # Pre-install checks
│   ├── packaging/            # Package installation
│   ├── config/               # System configuration
│   │   └── hardware/         # Apple Silicon specific
│   ├── login/                # Display manager setup
│   └── post-install/         # Cleanup and finish
├── bin/                      # 161 utility scripts
├── config/                   # Default configs
├── default/                  # Base defaults
└── themes/                   # Theme files
```

### Installed Files
```
~/.local/share/arclabs-os/
├── bin/                 # 161 utility scripts
├── default/             # Base configs
│   ├── hypr/            # Hyprland defaults
│   ├── waybar/          # Waybar configs
│   └── walker/          # Launcher themes
└── themes/              # Theme files

~/.config/
├── hypr/                # Your Hyprland config
├── waybar/              # Your Waybar config
├── kitty/               # Terminal config
└── arclabs-os/
    └── current/
        ├── theme -> ...  # Active theme symlink
        └── background    # Wallpaper
```

---

## Themes

ArcLabs OS includes **15 themes** with unique wallpapers and color schemes:

| Theme | Style |
|-------|-------|
| arclabs | Cyber green (#00ff99) |
| catppuccin | Mocha purple pastels |
| catppuccin-latte | Light mode pastels |
| tokyo-night | Purple/pink night |
| gruvbox | Warm retro |
| nord | Cool arctic blue |
| rose-pine | Muted rose tones |
| everforest | Forest greens |
| kanagawa | Japanese wave |
| hackerman | Matrix green |
| ethereal | Dreamy pastels |
| matte-black | Pure dark |
| osaka-jade | Jade green |
| ristretto | Coffee brown |
| flexoki-light | Light warm |

### Switch Themes
```bash
arclabs-theme tokyo-night
arclabs-theme --list        # List all themes
```

Or use the theme picker: **Super + Alt + Space** → Style → Theme

---

## Customization

### Change Wallpaper
```bash
arclabs-theme gruvbox       # Switch theme (includes wallpaper)
# Or manually with swww:
swww img /path/to/image.jpg --transition-type fade
```

### Edit Theme Colors
Edit `~/.local/share/arclabs-os/themes/arclabs/colors.toml`:
```toml
accent = "#00ff99"
background = "#0a0a0a"
foreground = "#e0e0e0"
```

### Modify Keybindings
Edit `~/.config/hypr/bindings.conf`

---

## Apple Hardware

### Keyboard
ArcLabs OS automatically configures:
- **Swap Option and Command** - Option becomes Super (main modifier)
- **Function keys** - Media keys by default, Fn for F1-F12
- **Keyboard backlight** - Fn+F5/F6 to adjust brightness
- **Two-finger right-click** - Enabled on trackpad

To customize keyboard: `/etc/modprobe.d/hid_apple.conf`

### Trackpad Gestures
| Gesture | Action |
|---------|--------|
| Two-finger click | Right-click |
| Two-finger scroll | Scroll |
| Three-finger swipe | Change workspace |

---

## Troubleshooting

### Installation fails
Check the log:
```bash
cat /tmp/arclabs-install.log
```

### Keyboard not working in Hyprland
```bash
sudo usermod -aG input $USER
# Then log out and back in
```

### Scripts not found
```bash
source ~/.bashrc  # or restart terminal
echo $PATH | grep arclabs  # verify PATH
```

### WiFi not working
```bash
sudo asahi-fwextract
# Then reboot
```

### No sound
Check speaker safety daemon and audio DSP:
```bash
systemctl status speakersafetyd
wpctl status
```

---

## Credits

- [Asahi Linux](https://asahilinux.org/) - Linux on Apple Silicon
- [Hyprland](https://hyprland.org/) - Wayland compositor
- Originally forked from [Omarchy](https://github.com/basecamp/omarchy)

---

## License

MIT License - See [LICENSE](LICENSE)

---

<div align="center">

**Made for the Apple Silicon Linux community**

*2026: The Year of Linux on the Mac*

</div>
