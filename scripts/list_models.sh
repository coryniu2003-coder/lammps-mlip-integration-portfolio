#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"
printf '%-12s %-23s %-22s %-15s\n' "MODEL" "DISPLAY NAME" "CONDA ENV" "STATUS"
printf '%-12s %-23s %-22s %-15s\n' "-----" "------------" "---------" "------"
awk -F '\t' 'NR > 1 { printf "%-12s %-23s %-22s %-15s\n", $1, $2, $3, $7 }' "${REGISTRY}"
cat <<'EOF'

Status meanings:
  tested         Reproduced on the development workstation.
  configuration  Verify the integration on the target machine before use.
EOF
