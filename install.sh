#!/usr/bin/env bash
# FR!sky Paperclip — install the agent desk
# Frisky Developments LLC · New Mexico, USA
#
#   brew install FriskyDevelopments/paperclip/frisky-paperclip
#   curl -fsSL https://raw.githubusercontent.com/FriskyDevelopments/homebrew-paperclip/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/FriskyDevelopments/homebrew-paperclip/main/install.sh | bash -s -- uninstall
#
set -euo pipefail

VERSION="0.1.1"
DESK="${PAPERCLIP_DESK:-https://clip.friskydev.com}"
PAY="${PAPERCLIP_PAY:-https://whop.com/checkout/plan_4WRbqNWxmh5SG}"
RAW="${PAPERCLIP_RAW:-https://raw.githubusercontent.com/FriskyDevelopments/homebrew-paperclip/main}"
PREFIX="${PAPERCLIP_PREFIX:-$HOME/.local}"
BIN="$PREFIX/bin/paperclip"
DESKTOP="$PREFIX/share/applications/frisky-paperclip.desktop"
MAC_APP="$HOME/Applications/Paperclip.app"

usage() {
  cat <<U
FR!sky Paperclip ${VERSION}  ·  the agent desk

  brew install FriskyDevelopments/paperclip/frisky-paperclip

  install      launcher (uses Homebrew when present)
  run          open the desk
  uninstall    remove launcher (or brew uninstall)
  help

Desk $DESK
Pay  $PAY
U
}

fetch_cli() {
  local dest="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$RAW/cmd/paperclip" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$RAW/cmd/paperclip"
  else
    echo "need curl or wget" >&2
    exit 1
  fi
  chmod +x "$dest"
}

install_brew() {
  brew install FriskyDevelopments/paperclip/frisky-paperclip
  echo "Installed via Homebrew. Run: paperclip"
}

install_local() {
  mkdir -p "$(dirname "$BIN")"
  fetch_cli "$BIN"
  if [[ "$(uname -s)" == Linux ]]; then
    mkdir -p "$(dirname "$DESKTOP")"
    cat > "$DESKTOP" <<D
[Desktop Entry]
Type=Application
Name=FR!sky Paperclip
Comment=The agent desk
Exec=$BIN
Icon=utilities-terminal
Terminal=false
Categories=Development;Office;
StartupNotify=true
D
  fi
  echo "Installed $BIN"
  echo "Desk $DESK"
}

uninstall() {
  if command -v brew >/dev/null 2>&1 && brew list --formula frisky-paperclip >/dev/null 2>&1; then
    brew uninstall frisky-paperclip || true
  fi
  rm -f "$BIN" "$DESKTOP"
  rm -rf "$MAC_APP" "$PREFIX/share/frisky-paperclip"
  echo "Removed FR!sky Paperclip launcher."
}

cmd="${1:-install}"
case "$cmd" in
  -h|--help|help) usage; exit 0 ;;
  uninstall|remove) uninstall; exit 0 ;;
  run|open)
    if command -v paperclip >/dev/null 2>&1; then exec paperclip; fi
    [[ -x "$BIN" ]] && exec "$BIN"
    echo "not installed" >&2
    exit 1
    ;;
  install|"") ;;
  *) echo "unknown command: $cmd" >&2; usage >&2; exit 2 ;;
esac

if command -v brew >/dev/null 2>&1; then
  install_brew
else
  install_local
fi

if command -v paperclip >/dev/null 2>&1; then
  paperclip || true
elif [[ -x "$BIN" ]]; then
  "$BIN" || true
fi
