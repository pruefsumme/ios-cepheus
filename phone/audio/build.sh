#!/bin/sh
# Build HakiosAudio.driver and sound_test for iOS 16 arm64.
set -eu
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
CC=${CC:-$ROOT/work/userland/bin/ios-cc}
OUT=$ROOT/phone/audio/out

rm -rf "$OUT"
mkdir -p "$OUT/HakiosAudio.driver"

"$CC" -O2 -Wall -Wextra -bundle \
	-framework CoreFoundation \
	-I"$ROOT/phone/audio" \
	-o "$OUT/HakiosAudio.driver/HakiosAudio" \
	"$ROOT/phone/audio/audio_plugin.c"
cp "$ROOT/phone/audio/Info.plist" "$OUT/HakiosAudio.driver/Info.plist"
codesign -f -s - "$OUT/HakiosAudio.driver/HakiosAudio"

"$CC" -O2 -Wall -Wextra \
	-framework AudioToolbox \
	-framework CoreFoundation \
	-lobjc \
	-o "$OUT/sound_test" \
	"$ROOT/phone/audio/sound_test.c"
codesign -f -s - "$OUT/sound_test"

ls -lh "$OUT/HakiosAudio.driver" "$OUT/sound_test"
