#!/bin/bash
# Enemy Territory Phase 1: Safe Reorganize
# Reorganisiert original-et-source/src in die neue Struktur

WORKSPACE_ROOT="/workspaces/EnemyTerritory-BloodySkulls"
SRC_DIR="$WORKSPACE_ROOT/workspace/original-et-source/src"

if [ ! -d "$SRC_DIR" ]; then
    echo "ERROR: $SRC_DIR existiert nicht!"
    exit 1
fi

echo "=========================================="
echo "Enemy Territory Phase 1: Safe Reorganize"
echo "=========================================="
echo ""

# Backup erstellen
BACKUP_DIR="$WORKSPACE_ROOT/backup-et-src-$(date +%Y%m%d%H%M%S)"
echo "[1/4] Backup wird erstellt: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r "$SRC_DIR"/* "$BACKUP_DIR" 2>/dev/null || true
echo "✓ Backup erfolgreich erstellt"
echo ""

# Zielordner saubermachen (alte placeholder files löschen)
echo "[2/4] Räume Zielordner auf..."
find "$WORKSPACE_ROOT"/engine "$WORKSPACE_ROOT"/client "$WORKSPACE_ROOT"/game "$WORKSPACE_ROOT"/shared -name "placeholder.dev-note" -delete 2>/dev/null || true
echo "✓ Zielordner bereit"
echo ""

echo "[3/4] Kopiere Verzeichnisse..."

# Engine-Ordner
[ -d "$SRC_DIR/renderer" ] && { rm -rf "$WORKSPACE_ROOT/engine/renderer" 2>/dev/null; cp -r "$SRC_DIR/renderer" "$WORKSPACE_ROOT/engine/" && echo "  → renderer -> engine/"; }
[ -d "$SRC_DIR/snd_dma" ] && { rm -rf "$WORKSPACE_ROOT/engine/snd_dma" 2>/dev/null; cp -r "$SRC_DIR/snd_dma" "$WORKSPACE_ROOT/engine/" && echo "  → snd_dma -> engine/"; }

# Shared
[ -d "$SRC_DIR/qcommon" ] && { rm -rf "$WORKSPACE_ROOT/shared/qcommon" 2>/dev/null; cp -r "$SRC_DIR/qcommon" "$WORKSPACE_ROOT/shared/" && echo "  → qcommon -> shared/"; }

# Game
[ -d "$SRC_DIR/game" ] && { rm -rf "$WORKSPACE_ROOT/game/game" 2>/dev/null; cp -r "$SRC_DIR/game" "$WORKSPACE_ROOT/game/" && echo "  → game -> game/"; }
[ -d "$SRC_DIR/botai" ] && { rm -rf "$WORKSPACE_ROOT/game/botai" 2>/dev/null; cp -r "$SRC_DIR/botai" "$WORKSPACE_ROOT/game/" && echo "  → botai -> game/"; }
[ -d "$SRC_DIR/botlib" ] && { rm -rf "$WORKSPACE_ROOT/game/botlib" 2>/dev/null; cp -r "$SRC_DIR/botlib" "$WORKSPACE_ROOT/game/" && echo "  → botlib -> game/"; }
[ -d "$SRC_DIR/server" ] && { rm -rf "$WORKSPACE_ROOT/game/server" 2>/dev/null; cp -r "$SRC_DIR/server" "$WORKSPACE_ROOT/game/" && echo "  → server -> game/"; }

# Client
[ -d "$SRC_DIR/client" ] && { rm -rf "$WORKSPACE_ROOT/client/client" 2>/dev/null; cp -r "$SRC_DIR/client" "$WORKSPACE_ROOT/client/" && echo "  → client -> client/"; }
[ -d "$SRC_DIR/cgame" ] && { rm -rf "$WORKSPACE_ROOT/client/cgame" 2>/dev/null; cp -r "$SRC_DIR/cgame" "$WORKSPACE_ROOT/client/" && echo "  → cgame -> client/"; }
[ -d "$SRC_DIR/ui" ] && { rm -rf "$WORKSPACE_ROOT/client/ui" 2>/dev/null; cp -r "$SRC_DIR/ui" "$WORKSPACE_ROOT/client/" && echo "  → ui -> client/"; }

# Platform
[ -d "$SRC_DIR/win32" ] && { rm -rf "$WORKSPACE_ROOT/windows/win32" 2>/dev/null; cp -r "$SRC_DIR/win32" "$WORKSPACE_ROOT/windows/" && echo "  → win32 -> windows/"; }
[ -d "$SRC_DIR/unix" ] && { rm -rf "$WORKSPACE_ROOT/linux/unix" 2>/dev/null; cp -r "$SRC_DIR/unix" "$WORKSPACE_ROOT/linux/" && echo "  → unix -> linux/"; }
[ -d "$SRC_DIR/mac" ] && { rm -rf "$WORKSPACE_ROOT/shared/mac" 2>/dev/null; cp -r "$SRC_DIR/mac" "$WORKSPACE_ROOT/shared/" && echo "  → mac -> shared/"; }

# Tools/Build
[ -d "$SRC_DIR/bspc" ] && { rm -rf "$WORKSPACE_ROOT/tools/bspc" 2>/dev/null; cp -r "$SRC_DIR/bspc" "$WORKSPACE_ROOT/tools/" && echo "  → bspc -> tools/"; }
[ -d "$SRC_DIR/extractfuncs" ] && { rm -rf "$WORKSPACE_ROOT/tools/extractfuncs" 2>/dev/null; cp -r "$SRC_DIR/extractfuncs" "$WORKSPACE_ROOT/tools/" && echo "  → extractfuncs -> tools/"; }

# Externe Libraries nach shared
[ -d "$SRC_DIR/curl-7.12.2" ] && { rm -rf "$WORKSPACE_ROOT/shared/curl-7.12.2" 2>/dev/null; cp -r "$SRC_DIR/curl-7.12.2" "$WORKSPACE_ROOT/shared/" && echo "  → curl-7.12.2 -> shared/"; }
[ -d "$SRC_DIR/jpeg-6" ] && { rm -rf "$WORKSPACE_ROOT/shared/jpeg-6" 2>/dev/null; cp -r "$SRC_DIR/jpeg-6" "$WORKSPACE_ROOT/shared/" && echo "  → jpeg-6 -> shared/"; }
[ -d "$SRC_DIR/ft2" ] && { rm -rf "$WORKSPACE_ROOT/shared/ft2" 2>/dev/null; cp -r "$SRC_DIR/ft2" "$WORKSPACE_ROOT/shared/" && echo "  → ft2 -> shared/"; }
[ -d "$SRC_DIR/splines" ] && { rm -rf "$WORKSPACE_ROOT/shared/splines" 2>/dev/null; cp -r "$SRC_DIR/splines" "$WORKSPACE_ROOT/shared/" && echo "  → splines -> shared/"; }

# Docs
[ -d "$SRC_DIR/docs" ] && { rm -rf "$WORKSPACE_ROOT/docs/source" 2>/dev/null; cp -r "$SRC_DIR/docs" "$WORKSPACE_ROOT/docs/source" && echo "  → docs -> docs/source/"; }
[ -d "$SRC_DIR/null" ] && { rm -rf "$WORKSPACE_ROOT/shared/null" 2>/dev/null; cp -r "$SRC_DIR/null" "$WORKSPACE_ROOT/shared/" && echo "  → null -> shared/"; }

echo "✓ Verzeichnisse kopiert"
echo ""

echo "[4/4] Kopiere Build-Files..."
for file in "$SRC_DIR"/{SConstruct*,SConscript*,scons_utils.py,wolf.sln,wolf.vcproj,makebundle.sh}; do
    if [ -e "$file" ]; then
        cp "$file" "$WORKSPACE_ROOT/tools/" 2>/dev/null || true
        echo "  → $(basename "$file") -> tools/"
    fi
done
echo "✓ Build-Files kopiert"
echo ""

echo "=========================================="
echo "✓ FERTIG! Reorganisation abgeschlossen!"
echo "=========================================="
echo ""
echo "Backup Location: $BACKUP_DIR"
echo ""
