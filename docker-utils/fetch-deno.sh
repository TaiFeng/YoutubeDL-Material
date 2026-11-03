#!/bin/sh

# yt-dlp needs a JavaScript runtime for YouTube extraction (https://github.com/yt-dlp/yt-dlp/wiki/EJS).
# Deno (>= 2.3) is the one yt-dlp enables by default. The bundled Node 16 is too old (yt-dlp needs Node >= 22).

case $(uname -m) in
  x86_64)
    ARCH=x86_64-unknown-linux-gnu;;
  aarch64)
    ARCH=aarch64-unknown-linux-gnu;;
  *)
    echo "Unsupported architecture for deno: $(uname -m)"
    exit 1
esac

echo "(INFO) Architecture detected: $ARCH"
echo "(1/3) READY - Install unzip"
apt-get update && apt-get -y install unzip curl
echo "(2/3) DOWNLOAD - Acquire deno"
curl -o deno.zip \
    --connect-timeout 5 \
    --max-time 120 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -L "https://github.com/denoland/deno/releases/latest/download/deno-$ARCH.zip"
unzip -o deno.zip deno
chmod +x deno
echo "(3/3) Smoke test"
./deno --version
cp ./deno /usr/local/bin/deno
