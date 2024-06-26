#!/bin/bash

set -e

# Add the driver path to /etc/environment to make sure it can take effect
# when connecting to the container
printenv | grep DRIVER_PATH >> /etc/environment

# Set environment variables for the Ascend toolkit
source /usr/local/Ascend/ascend-toolkit/set_env.sh

# Execute other commands
exec "$@"
