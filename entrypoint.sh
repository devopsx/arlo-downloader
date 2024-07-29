#!/bin/bash

set -xeu -o pipefail

# Allow to switch user in compose.yml
usermod -u $UID arlo-downloader
# shellcheck disable=2086  # passed from Dockerfile or compose
groupmod -g $GID arlo-downloader

chown -R "$UID:$GID" /records /arlo-downloader/aarlo

if [[ "$DEBUG" != "3" ]]; then
    set +x
    echo "runuser -u arlo-downloader -- python /arlo-downloader/arlo-downloader.py \
    --save-media-to \"${SAVE_MEDIA_TO}\" \
    --tfa-type \"${TFA_TYPE}\" \
    --tfa-source \"${TFA_SOURCE}\" \
    --tfa-retries \"${TFA_RETRIES}\" \
    --tfa-delay \"${TFA_DELAY}\" \
    --tfa-host \"${TFA_HOST}\" \
    --tfa-username \"${TFA_USERNAME}\" \
    --tfa-password \"***\""
fi

runuser -u arlo-downloader -- python /arlo-downloader/arlo-downloader.py \
    --save-media-to "${SAVE_MEDIA_TO}" \
    --tfa-type "${TFA_TYPE}" \
    --tfa-source "${TFA_SOURCE}" \
    --tfa-retries "${TFA_RETRIES}" \
    --tfa-delay "${TFA_DELAY}" \
    --tfa-host "${TFA_HOST}" \
    --tfa-username "${TFA_USERNAME}" \
    --tfa-password "${TFA_PASSWORD}"
