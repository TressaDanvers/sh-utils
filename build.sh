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
      name=$(basename "$file")
      sh ./src/info deploy "$PREFIX/bin/$name"
      cp "$file" "$PREFIX/bin/$name" || sh ./src/err-fatal deploy "cannot copy $file"
      chmod 755 "$PREFIX/bin/$name" || sh ./src/err-fatal deploy "cannot set the mode of $PREFIX/bin/$name"
    done
    sh ./src/pass deploy "all files deployed"
    ;;
  check)
    sh ./src/check-sh build.sh || sh ./src/err-fatal check "build.sh has problems"
    for file in ./src/*; do
      sh ./src/check-sh "$file" || sh ./src/err-fatal check "$file has problems"
    done
    sh ./src/pass check "all checks passed"
    ;;
  clean)
    sh ./src/err-fatal clean "sh-utils has nothing to clean"
    ;;
esac
