#!/bin/bash

set -e

pkgnm="$1"
targdir="$2"
pkgtype="$3"

if [ -z "$targdir" ]; then
    >&2 echo "You must call this script with the following arguments:"
    >&2 echo
    >&2 echo "    1. Package name (not used for this script)"
    >&2 echo "    2. Target directory"
    >&2 echo "    3. Package type (not used for this script)"
    >&2 echo
    exit 2
fi

if [ ! -d "$targdir" ]; then
    >&2 echo "Target directory '$targdir' does not appear to be a directory."
    exit 5
fi

prefix="$targdir/opt/$pkgnm"
mkdir -p "$prefix/bin"
cp src/* "$prefix/bin/"

if ./scripts/build-docs.sh >/dev/null; then
    mkdir -p "$prefix/share/man/"
    cp -R ./doc-build/* "$prefix/share/man/"
else
    >&2 echo "Couldn't build man pages! Not continuing with package build."
    exit 10
fi

