#!/bin/bash
# Usage: tool/gemini_body.sh /path/to/photo.jpg
# Writes ~/Downloads/gemini_body.json, to be sent from Postman as a binary body.
OUT="$HOME/Downloads/gemini_body.json"
B64=$(base64 -i "$1" | tr -d '\n')
cat > "$OUT" <<JSON
{"contents":[{"parts":[{"text":"Transcribe all text in this image exactly as written. Keep numbering and line breaks. Keep Hindi and English as is. Do not correct or translate. If a word is unclear, write [?]. Output only the text."},{"inline_data":{"mime_type":"image/jpeg","data":"$B64"}}]}]}
JSON
echo "Saved: $OUT"
