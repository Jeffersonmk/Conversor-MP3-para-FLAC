#!/usr/bin/env bash
set -euo pipefail

INPUT_DIR="${1:-}"
OUTPUT_DIR="${2:-}"
THREADS=$(nproc)

if [[ -z "$INPUT_DIR" || -z "$OUTPUT_DIR" ]]; then
    echo "Uso: $0 pasta_flac pasta_mp3"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

export INPUT_DIR
export OUTPUT_DIR

convert_file() {

    file="$1"

    rel="${file#$INPUT_DIR/}"
    out="$OUTPUT_DIR/${rel%.flac}.mp3"

    mkdir -p "$(dirname "$out")"

    if [[ -f "$out" ]]; then
        echo "Pulando (já existe): $rel"
        return
    fi

    echo "Convertendo: $rel"

    ffmpeg -loglevel error         -i "$file"         -map_metadata 0         -vn         -codec:a libmp3lame         -qscale:a 0         "$out"
}

export -f convert_file

find "$INPUT_DIR" -type f -iname "*.flac" -print0 |
xargs -0 -n1 -P"$THREADS" bash -c 'convert_file "$@"' _
