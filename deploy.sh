#!/usr/bin/env bash
#
# Deploy the Maho API test harness into an install's public/api-test/.
#
# Usage:
#   ./deploy.sh <user@host:/path/to/public/api-test/> [ssh-port]
#
# Or create a gitignored .deploy-targets file (one target per line, optional
# ssh port as a second field) and run ./deploy.sh with no arguments:
#   user@host:/var/www/store/public/api-test/ 22
#
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

deploy_one() {
    local target="$1" port="${2:-22}"
    rsync -az \
        --exclude='.git' --exclude='.gitignore' \
        --exclude='deploy.sh' --exclude='README.md' --exclude='.deploy-targets' \
        -e "ssh -p ${port}" \
        "${DIR}/" "${target}"
    echo "Deployed -> ${target}"
}

if [[ $# -ge 1 ]]; then
    deploy_one "$@"
elif [[ -f "${DIR}/.deploy-targets" ]]; then
    while read -r target port _; do
        [[ -z "${target}" || "${target}" == \#* ]] && continue
        deploy_one "${target}" "${port:-22}"
    done < "${DIR}/.deploy-targets"
else
    echo "Usage: ./deploy.sh <user@host:/path/to/public/api-test/> [ssh-port]" >&2
    echo "   or: create a gitignored .deploy-targets file, one target per line" >&2
    exit 1
fi
