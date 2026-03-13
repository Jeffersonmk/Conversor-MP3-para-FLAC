#!/usr/bin/env bash
set -euo pipefail

INPUT_DIR="${1:-}"
OUTPUT_DIR="${2:-}"

if [[ -z "$INPUT_DIR" || -z "$OUTPUT_DIR" ]]; then
    echo "Uso: $0 pasta_origem pasta_destino"
    exit 1
fi

if ! command -v ffmpeg >/dev/null; then
    echo "Erro: ffmpeg não instalado"
    exit 1
fi

if ! command -v parallel >/dev/null; then
    echo "Erro: GNU parallel não instalado"
    echo "Arch: sudo pacman -S parallel"
    echo "Debian/Ubuntu: sudo apt install parallel"
    exit 1
fi

THREADS=$(nproc)

mkdir -p "$OUTPUT_DIR"

export INPUT_DIR
export OUTPUT_DIR

convert_file() {

    file="$1"

    rel="${file#$INPUT_DIR/}"
    out="$OUTPUT_DIR/${rel%.*}.mp3"

    mkdir -p "$(dirname "$out")"

    if [[ -f "$out" ]]; then
        echo "Pulando: $rel"
        return
    fi

    dir=$(dirname "$file")

    cover=""

    for img in "cover.jpg" "folder.jpg" "Cover.jpg" "Folder.jpg"; do
        if [[ -f "$dir/$img" ]]; then
            cover="$dir/$img"
            break
        fi
    done

    echo "Convertendo: $rel"

    if [[ -n "$cover" ]]; then

        ffmpeg -loglevel error \
        -i "$file" \
        -i "$cover" \
        -map 0:a \
        -map 1 \
        -map_metadata 0 \
        -c:a libmp3lame \
        -qscale:a 0 \
        -c:v mjpeg \
        -id3v2_version 3 \
        -metadata:s:v title="Album cover" \
        -metadata:s:v comment="Cover (front)" \
        "$out"

    else

        ffmpeg -loglevel error \
        -i "$file" \
        -map 0 \
        -map_metadata 0 \
        -c:a libmp3lame \
        -qscale:a 0 \
        -c:v copy \
        -id3v2_version 3 \
        "$out"

    fi
}

export -f convert_file

echo
echo "🔎 Procurando arquivos de áudio..."
echo

mapfile -d '' FILES < <(find "$INPUT_DIR" -type f \( \
    -iname "*.flac" -o \
    -iname "*.wav" -o \
    -iname "*.aiff" -o \
    -iname "*.m4a" \
\) -print0)

TOTAL=${#FILES[@]}

echo "🎵 Arquivos encontrados: $TOTAL"
echo "⚡ Threads usadas: $THREADS"
echo

printf "%s\0" "${FILES[@]}" | parallel -0 -j "$THREADS" --bar convert_file {}

echo
echo "✅ Conversão concluída"