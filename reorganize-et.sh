#!/bin/bash
# Enemy Territory Phase 1: Safe Reorganize
# Reorganisiert original-et-source/src in die neue Struktur
# WICHTIG: Backup wird erstellt bevor was verschoben wird!

set -e

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
BACKUP_DIR="$WORKSPACE_ROOT/backup-src-$(date +%Y%m%d%H%M%S)"
echo "[1/4] Backup wird erstellt: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r "$SRC_DIR"/* "$BACKUP_DIR"
echo "✓ Backup erfolgreich erstellt"
echo ""

# Zielordner saubermachen (alte placeholder files löschen)
echo "[2/4] Räume Zielordner auf..."
rm -f "$WORKSPACE_ROOT"/engine/placeholder.dev-note
rm -f "$WORKSPACE_ROOT"/client/placeholder.dev-note
rm -f "$WORKSPACE_ROOT"/game/placeholder.dev-note
rm -f "$WORKSPACE_ROOT"/shared/placeholder.dev-note
echo "✓ Zielordner bereit"
echo ""

# Move Mapping - welche Verzeichnisse wohin
declare -A MOVE_MAP
MOVE_MAP=(
    ["renderer"]="engine"
    ["snd_dma"]="engine"
    ["qcommon"]="shared"
    ["game"]="game"
    ["cgame"]="client"
    ["client"]="client"
    ["ui"]="client"
    ["botai"]="game"
    ["botlib"]="game"
    ["server"]="game"
    ["win32"]="windows"
    ["unix"]="linux"
    ["mac"]="macos"
)

echo "[3/4] Verschiebe Verzeichnisse..."
for src_sub in "${!MOVE_MAP[@]}"; do
    if [ -d "$SRC_DIR/$src_sub" ]; then
        target="${MOVE_MAP[$src_sub]}"
        mv "$SRC_DIR/$src_sub" "$WORKSPACE_ROOT/$target/"
        echo "  → $src_sub -> $target/"
    fi
done
echo "✓ Verzeichnisse verschoben"
echo ""

# Restliche Dateien
echo "[4/4] Verschiebe restliche Dateien..."
if [ -d "$SRC_DIR" ] && [ "$(ls -A $SRC_DIR)" ]; then
    for file in "$SRC_DIR"/*; do
        if [ -e "$file" ]; then
            filename=$(basename "$file")
            if [[ "$filename" != "SConscript"* ]] && [[ "$filename" != "SConstruct"* ]] && \
               [[ "$filename" != "wolf."* ]] && [[ "$filename" != "scons_utils.py" ]]; then
                mv "$file" "$WORKSPACE_ROOT/shared/"
                echo "  → $filename -> shared/"
            else
                mv "$file" "$WORKSPACE_ROOT/tools/"
                echo "  → $filename -> tools/"
            fi
        fi
    done
fi
echo "✓ Restliche Dateien verschoben"
echo ""

# Aufräumen
rmdir "$SRC_DIR" 2>/dev/null || true

echo "=========================================="
echo "✓ FERTIG! Reorganisation abgeschlossen!"
echo "=========================================="
echo ""
echo "Backup Location: $BACKUP_DIR"
echo "Falls was schiefgeht: cp -r $BACKUP_DIR/* $SRC_DIR/"
echo ""
