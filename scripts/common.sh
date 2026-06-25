#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REGISTRY="${REPO_ROOT}/models/registry.tsv"
if [[ -f "${REPO_ROOT}/config.env" ]]; then
  # shellcheck disable=SC1091
  source "${REPO_ROOT}/config.env"
fi
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
require_value() { local option="$1" value="${2:-}"; [[ -n "${value}" ]] || die "${option} requires a value"; }
model_row() { local model="$1"; awk -F '\t' -v id="${model}" 'NR > 1 && $1 == id { print; exit }' "${REGISTRY}"; }
load_model() {
  local model="$1" row
  row="$(model_row "${model}")"
  [[ -n "${row}" ]] || die "unknown model '${model}'. Run scripts/list_models.sh."
  IFS=$'\t' read -r MODEL_ID MODEL_NAME MODEL_ENV MODEL_BINARY_ENV MODEL_PAIR_PAYLOAD MODEL_PYTHON_MODULE MODEL_STATUS <<< "${row}"
}
resolve_gnnp_root() {
  local explicit="${1:-}"
  if [[ -n "${explicit}" ]]; then printf '%s\n' "${explicit}"
  elif [[ -n "${GNNP_ROOT:-}" ]]; then printf '%s\n' "${GNNP_ROOT}"
  elif [[ -n "${LAMMPS_ROOT:-}" ]]; then printf '%s\n' "${LAMMPS_ROOT}/src/ML-GNNP"
  else return 1; fi
}
resolve_lmp_bin() {
  local explicit="${1:-}" configured=""
  if [[ -n "${MODEL_BINARY_ENV:-}" ]]; then configured="${!MODEL_BINARY_ENV:-}"; fi
  if [[ -n "${explicit}" ]]; then printf '%s\n' "${explicit}"
  elif [[ -n "${configured}" ]]; then printf '%s\n' "${configured}"
  elif command -v lmp >/dev/null 2>&1; then command -v lmp
  else return 1; fi
}
