#!/bin/bash
# Usage: tool/gemini_test.sh YOUR_KEY /path/to/photo.jpg
KEY="$1"; IMG="$2"
MODEL="gemini-3.8-flash"
B64=$(base64 -i "$IMG" | tr -d '\n')
cat > /tmp/gemini_req.json <<JSON
{"contents":[{"parts":[{"text":"Transcribe all text in this image exactly as written. Keep numbering and line breaks. Keep Hindi and English as is. Do not correct or translate. If a word is unclear, write [?]. Output only the text."},{"inline_data":{"mime_type":"image/jpeg","data":"$B64"}}]}]}
JSON
curl -s -w "\n\nTime: %{time_total}s  HTTP: %{http_code}\n" \
  "https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent" \
  -H "x-goog-api-key: $KEY" -H "Content-Type: application/json" \
  -d @/tmp/gemini_req.json
