#!/bin/bash

# Start SSH service
service ssh start

# Start your other services here
# For example:
# service postgresql start

exec tail -f /dev/null