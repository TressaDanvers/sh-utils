#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"
sh ./src/build-script-arg "$@"

PREFIX=${PREFIX:-/usr/local}

case "${1:-}" in
  "")
    sh ./src/err-fatal build "sh-utils has nothing to build"
    ;;
  deploy)
    mkdir -p "$PREFIX/bin" || sh ./src/err-fatal deploy "cannot make $PREFIX/bin"
    for file in ./src/*; do
      [ -f "$file" ] || sh ./src/err-fatal deploy "not a file: $file"
      name=$(basename "$file")
      sh ./src/info deploying "$PREFIX/bin/$name"
      cp "$file" "$PREFIX/bin/$name" || sh ./src/err-fatal deploy "cannot copy $file"
      chmod 755 "$PREFIX/bin/$name" || sh ./src/err-fatal deploy "cannot set the mode of $PREFIX/bin/$name"
    done
    ;;
  check)
    sh ./src/check build.sh || sh ./src/err-fatal check "build.sh has problems"
    for file in ./src/*; do
      [ -f "$file" ] || sh ./src/err-fatal check "not a file: $file"
      sh ./src/check "$file" || sh ./src/err-fatal check "$file has problems"
    done
    ;;
  clean)
    sh ./src/err-fatal clean "sh-utils has nothing to clean"
    ;;
esac
