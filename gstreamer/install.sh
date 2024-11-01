#!/usr/bin/env bash
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Clone cerbero and build
CERBERO_DIR="/cerbero"
git clone --depth=1 ${CERBER_URL} ${CERBERO_DIR}
cd ${CERBERO_DIR}
git fetch --all --tags
git checkout ${CERBERO_REF}

./cerbero-uninstalled ${CERBERO_ARGS} -c config/linux.config fetch-bootstrap
./cerbero-uninstalled ${CERBERO_ARGS} -c config/linux.config fetch-package gstreamer-1.0
./cerbero-uninstalled ${CERBERO_ARGS} -c config/linux.config bootstrap --system=yes --toolchains=no --build-tools=no --offline
./cerbero-uninstalled ${CERBERO_ARGS} -c config/linux.config package gstreamer-1.0 --offline
