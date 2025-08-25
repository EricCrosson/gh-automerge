#!/usr/bin/env bash
set -eu

# Create dist directory
mkdir -p dist

# Build for current platform
case "$(uname -s)" in
Darwin)
	GOOS=darwin
	;;
Linux)
	GOOS=linux
	;;
MINGW* | MSYS* | CYGWIN*)
	GOOS=windows
	;;
*)
	echo "Unsupported OS"
	exit 1
	;;
esac

# Determine architecture
case "$(uname -m)" in
x86_64 | amd64)
	GOARCH=amd64
	;;
arm64 | aarch64)
	GOARCH=arm64
	;;
*)
	echo "Unsupported architecture"
	exit 1
	;;
esac

# Build with cargo
echo "Building for $GOOS-$GOARCH"
cargo build --release

# Create platform-specific filename
if [ "$GOOS" = "windows" ]; then
	EXTENSION=".exe"
else
	EXTENSION=""
fi
OUTPUT_FILE="dist/${GOOS}-${GOARCH}${EXTENSION}"

# Copy the built binary to the output location
cp target/release/gh-automerge "$OUTPUT_FILE"
chmod +x "$OUTPUT_FILE"

echo "Successfully built gh-automerge extension at $OUTPUT_FILE"
