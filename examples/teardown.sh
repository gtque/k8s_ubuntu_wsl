#!/bin/bash
set -euo pipefail

export deploy_action=teardown
source ./deploy/deploy.sh
