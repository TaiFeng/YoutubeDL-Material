#!/bin/sh
set -e

# THANK YOU TALULAH (https://github.com/nottalulah) for your help in figuring this out
# and also optimizing some code with this commit.
# xoxo :D

# Static builds from yt-dlp's own FFmpeg-Builds (patched for yt-dlp, hosted on GitHub).
# johnvansickle.com serves an error page instead of the archive to GitHub Actions runners.
case $(uname -m) in
  x86_64)
    ARCH=linux64;;
  aarch64)
    ARCH=linuxarm64;;
  *)
    echo "Unsupported architecture: $(uname -m)"
    exit 1
esac

echo "(INFO) Architecture detected: $ARCH"
echo "(1/5) READY - Acquire temp dependencies in ffmpeg obtain layer"
apt-get update && apt-get -y install curl xz-utils
echo "(2/5) DOWNLOAD - Acquire latest ffmpeg and ffprobe from yt-dlp's FFmpeg-Builds in ffmpeg obtain layer"
curl -o ffmpeg.txz \
    --fail \
    --connect-timeout 5 \
    --max-time 300 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -L "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-${ARCH}-gpl.tar.xz"
mkdir /tmp/ffmpeg
tar xf ffmpeg.txz -C /tmp/ffmpeg
echo "(3/5) CLEANUP - Remove temp dependencies from ffmpeg obtain layer"
apt-get -y remove curl xz-utils
apt-get -y autoremove
echo "(4/5) PROVISION - Provide ffmpeg and ffprobe from ffmpeg obtain layer"
cp /tmp/ffmpeg/*/bin/ffmpeg /usr/local/bin/ffmpeg
cp /tmp/ffmpeg/*/bin/ffprobe /usr/local/bin/ffprobe
/usr/local/bin/ffmpeg -version | head -n 1
echo "(5/5) CLEANUP - Remove temporary downloads from ffmpeg obtain layer"
rm -rf /tmp/ffmpeg ffmpeg.txz
