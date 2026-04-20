#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /path/to/current_cv.pdf" >&2
  exit 1
fi

src=$1
dest="files/CV_Volfovsky.pdf"

if [ ! -f "$src" ]; then
  echo "CV source PDF not found: $src" >&2
  exit 1
fi

case "$src" in
  *.pdf|*.PDF) ;;
  *)
    echo "CV source should be a PDF: $src" >&2
    exit 1
    ;;
esac

cp "$src" "$dest"
echo "Updated $dest"
