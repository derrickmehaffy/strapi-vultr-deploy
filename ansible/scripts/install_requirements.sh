#!/bin/bash
set -e

ansible-galaxy install -r ../requirements.yml $@

exit