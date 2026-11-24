#!/usr/bin/env bash
# ==============================================================================
#  Ubuntu to macOS Transformation Script (Linux / Tux Edition)
#  Crafted with care by Gaurav Patil (@GauravPatil2515)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo " -> 🐧 Initializing macOS Transformation for Ubuntu (GNOME)..."

# 1. Window Controls (macOS Left Traffic Lights)
echo "[1/7] Setting window titlebar buttons to top-left (close, minimize, maximize)..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# 2. GTK & Shell Themes (WhiteSur)
echo "[2/7] Configuring WhiteSur Dark theme and icon set..."
if [ -d "$HOME/.themes/WhiteSur-Dark" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark' || true
  gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark' || true
fi

if [ -d "$HOME/.local/share/icons/WhiteSur-dark" ] || [ -d "/usr/share/icons/WhiteSur-dark" ]; then
  gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark' || true
fi

if [ -d "$HOME/.local/share/icons/WhiteSur-cursors" ] || [ -d "/usr/share/icons/WhiteSur-cursors" ]; then
  gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors' || true
fi

# 3. Typography (Apple SF Pro Font)
echo "[3/7] Setting macOS SF Pro font if available..."
if fc-list : family | grep -iq "SF Pro Text"; then
  gsettings set org.gnome.desktop.interface font-name 'SF Pro Text 11'
  gsettings set org.gnome.desktop.interface document-font-name 'SF Pro Text 11'
fi

# 4. Dock Customizations (Dash to Dock)
echo "[4/7] Customizing floating macOS dock..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' || true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-icons-emblems true || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-icons-notifications-counter true || true

# 5. Linux Tux Branding (Replacing Apple Logos)
echo "[5/7] Replacing WhiteSur Apple logos with custom Linux Tux glass icons..."
TUX_DOCK_SVG="$SCRIPT_DIR/assets/view-app-grid-tux.svg"
TUX_PANEL_SVG="$SCRIPT_DIR/assets/activities-tux.svg"

for theme_assets in "$HOME"/.themes/WhiteSur*/gnome-shell/assets; do
  if [ -d "$theme_assets" ]; then
    [ -f "$TUX_DOCK_SVG" ] && cp "$TUX_DOCK_SVG" "$theme_assets/view-app-grid.svg"
    [ -f "$TUX_PANEL_SVG" ] && cp "$TUX_PANEL_SVG" "$theme_assets/activities.svg"
    [ -f "$TUX_PANEL_SVG" ] && cp "$TUX_PANEL_SVG" "$theme_assets/activities-white.svg"
  fi
done

# Also update WhiteSur icon themes
for icon_dir in "$HOME/.local/share/icons/WhiteSur" "$HOME/.local/share/icons/WhiteSur-dark"; do
  if [ -d "$icon_dir/apps/scalable" ] && [ -f "$TUX_DOCK_SVG" ]; then
    cp "$TUX_DOCK_SVG" "$icon_dir/apps/scalable/view-app-grid.svg"
  fi
done

# 6. GTK Rounded Corners
echo "[6/7] Applying GTK window border radius rules..."
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
if ! grep -q "border-radius" "$HOME/.config/gtk-3.0/gtk.css" 2>/dev/null; then
  cat << 'EOF' >> "$HOME/.config/gtk-3.0/gtk.css"

/* macOS Style Rounded Window Corners */
decoration {
  border-radius: 16px;
}
EOF
fi

if ! grep -q "border-radius" "$HOME/.config/gtk-4.0/gtk.css" 2>/dev/null; then
  cat << 'EOF' >> "$HOME/.config/gtk-4.0/gtk.css"

/* macOS Style Rounded Window Corners */
window, dialog {
  border-radius: 16px;
}
EOF
fi

# 7. Rounded Window Corners Reborn & Screen Corners
echo "[7/7] Configuring Rounded Window Corners Reborn extension..."
if command -v glib-compile-schemas &>/dev/null; then
  EXT_DIR="$HOME/.local/share/gnome-shell/extensions/rounded-window-corners@fxgn"
  if [ -d "$EXT_DIR/schemas" ]; then
    mkdir -p "$HOME/.local/share/glib-2.0/schemas"
    cp "$EXT_DIR/schemas/"*.xml "$HOME/.local/share/glib-2.0/schemas/"
    glib-compile-schemas "$HOME/.local/share/glib-2.0/schemas"
    
    gsettings set org.gnome.shell.extensions.rounded-window-corners-reborn global-rounded-corner-settings "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keepRoundedCorners': <{'maximized': <true>, 'fullscreen': <false>}>, 'borderRadius': <uint32 16>, 'smoothing': <0>, 'borderColor': <[0.5, 0.5, 0.5, 1.0]>, 'enabled': <true>}" || true
    gsettings set org.gnome.shell.extensions.rounded-window-corners-reborn skip-libadwaita-app false || true
  fi
fi

# Reload Shell Theme to apply immediately
echo "Reloading GNOME Shell user-theme..."
gsettings set org.gnome.shell.extensions.user-theme name '' || true
sleep 0.5
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark' || true

echo "✨ Transformation complete! Your desktop now looks like macOS with proud Linux Tux branding."
