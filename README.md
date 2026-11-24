# GNOME Desktop Customization Guide (Modern Minimalist Rice)

An open-source reference guide and automation scripts to transform an Ubuntu / GNOME desktop into an ultra-clean, minimalist interface with glassmorphism, floating dock layout, rounded window shaders, and native Linux branding.

---

## Overview of Customizations

| Category | Component | Description |
| :--- | :--- | :--- |
| **Window Layout** | Titlebar Controls | Left-aligned window controls (`close,minimize,maximize:`) |
| **Interface** | Shell & GTK | Modern dark theme integration via User Themes |
| **Dock** | Dash to Dock | Floating, auto-centered bottom dock with notification counters |
| **Shaders** | Window Corners | Hardware-accelerated rounded corners (16px) with drop shadows |
| **Display** | Screen Geometry | Soft rounded monitor screen edges |
| **Effects** | Blur My Shell | Acrylic / frosted glass background blur for top bar & dock |
| **Branding** | Custom SVGs | Vector Linux Tux icon for application grid & panel menus |

---

## Automated Quickstart

Clone the repository and run the setup script:

```bash
git clone https://github.com/GauravPatil2515/gnome-macos-aesthetic.git
cd gnome-macos-aesthetic
chmod +x install.sh
./install.sh
```

---

## Manual Configuration Steps

### 1. Left-Aligned Window Controls
Move titlebar buttons to the top-left corner:

```bash
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
```

### 2. Floating Centered Bottom Dock
If using the `dash-to-dock` GNOME extension:

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
```

### 3. Window Border Radius via CSS
Add smooth corner rounding for GTK applications:

`~/.config/gtk-3.0/gtk.css`:
```css
decoration {
  border-radius: 16px;
}
```

`~/.config/gtk-4.0/gtk.css`:
```css
window, dialog {
  border-radius: 16px;
}
```

### 4. Hardware-Accelerated Corner Shaders
For full system-wide window rounding across all toolkits:
* Install the community extension `rounded-window-corners-reborn`.
* Ensure schemas are compiled:
  ```bash
  mkdir -p ~/.local/share/glib-2.0/schemas
  cp ~/.local/share/gnome-shell/extensions/rounded-window-corners@fxgn/schemas/*.xml ~/.local/share/glib-2.0/schemas/
  glib-compile-schemas ~/.local/share/glib-2.0/schemas
  ```
* Enable rounding for maximized and tiled windows:
  ```bash
  gsettings set org.gnome.shell.extensions.rounded-window-corners-reborn global-rounded-corner-settings "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keepRoundedCorners': <{'maximized': <true>, 'fullscreen': <false>}>, 'borderRadius': <uint32 16>, 'smoothing': <0>, 'borderColor': <[0.5, 0.5, 0.5, 1.0]>, 'enabled': <true>}"
  ```

---

## Recommended Extensions

* **User Themes**: Enables custom GNOME Shell themes.
* **Dash to Dock**: Configurable floating dock.
* **Blur my Shell**: Adds dynamic background blur.
* **Compiz-alike Magic Lamp Effect**: Smooth genie-style window minimization.
* **Rounded Corners**: Displays curved monitor viewport corners.

---

## License

MIT License — free to use, modify, and distribute.
