#!/bin/bash

set -e

# Set environment variables for the Ascend toolkit
source /usr/local/Ascend/ascend-toolkit/set_env.sh

# Execute other commands
exec "$@"
