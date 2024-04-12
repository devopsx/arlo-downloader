#!/bin/bash

set -e
chown -R 99:100 /records
/bin/bash -l -c "$*"
exec exec runuser -u appuser "$@"
