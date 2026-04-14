#!/bin/bash
# Downloads the latest JMdict XML file from EDRDG.
# Run from the Data/JMdict directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_DIR="$(dirname "$SCRIPT_DIR")"
URL="http://ftp.edrdg.org/pub/Nihongo/JMdict_e.gz"
OUTPUT="$DATA_DIR/JMdict_e.xml"

echo "Downloading JMdict from EDRDG..."
curl -L "$URL" | gunzip > "$OUTPUT"

echo "Downloaded to $OUTPUT"
echo "Size: $(du -h "$OUTPUT" | cut -f1)"
echo ""
echo "Next step: swift scripts/import-jmdict.swift"
