#!/usr/bin/env bash

if [ ! -d "$PKG_PATH/../common" ]; then
    echo "Dependency on katharinegillis/common, package is missing."
    exit 1
fi

source "$PKG_PATH/../common/common_ellipsis.sh"
