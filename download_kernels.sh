#!/bin/bash

URL="https://drive.usercontent.google.com/download?id=1tqjhHl7PPI0-X_6JwNhV5Rd2Z_qFj34p&confirm=xxx"

echo "Downloading from $URL..."
curl -L -o iffset.tar.xz "$URL"

echo "Extracting ..."
tar -xvf iffset.tar.xz

echo "Done."
rm -rf ./iffset.tar.xz

