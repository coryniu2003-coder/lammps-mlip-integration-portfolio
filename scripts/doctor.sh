#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"
MODEL=""; LMP_BIN_ARG=""; GNNP_ROOT_ARG=""; CONFIG_ONLY=0
usage() { cat <<'EOF'
Usage: bash scripts/doctor.sh --model MODEL [--lmp-bin PATH] [--gnnp-root PATH] [--config-only]
EOF
}
while (($#)); do
  case "$1" in
    --model) require_value "$1" "${2:-}"; MODEL="$2"; shift 2 ;;
    --lmp-bin) require_value "$1" "${2:-}"; LMP_BIN_ARG="$2"; shift 2 ;;
    --gnnp-root) require_value "$1" "${2:-}"; GNNP_ROOT_ARG="$2"; shift 2 ;;
    --config-only) CONFIG_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option '$1'" ;;
  esac
done
[[ -n "${MODEL}" ]] || die "--model is required"
[[ -f "${REGISTRY}" ]] || die "missing model registry: ${REGISTRY}"
load_model "${MODEL}"
DEFAULT_STRUCTURE="${REPO_ROOT}/structures/argon_fcc_4.lammps"
[[ -f "${DEFAULT_STRUCTURE}" ]] || die "missing default structure: ${DEFAULT_STRUCTURE}"
printf 'Model:           %s (%s)\n' "${MODEL_NAME}" "${MODEL_ID}"
printf 'Repository:      %s\n' "${REPO_ROOT}"
printf 'Registry status: %s\n' "${MODEL_STATUS}"
printf 'Default input:   %s\n' "${DEFAULT_STRUCTURE}"
if ((CONFIG_ONLY)); then printf 'Configuration check: PASS\n'; exit 0; fi
GNNP_PATH="$(resolve_gnnp_root "${GNNP_ROOT_ARG}")" || die "ML-GNNP path not configured. Copy .env.example to config.env or use --gnnp-root."
[[ -d "${GNNP_PATH}" ]] || die "ML-GNNP directory does not exist: ${GNNP_PATH}"
[[ -f "${GNNP_PATH}/gnnp_driver.py" ]] || die "gnnp_driver.py not found under ${GNNP_PATH}"
LMP_PATH="$(resolve_lmp_bin "${LMP_BIN_ARG}")" || die "LAMMPS binary not configured. Set ${MODEL_BINARY_ENV} or use --lmp-bin."
[[ -x "${LMP_PATH}" ]] || die "LAMMPS binary is not executable: ${LMP_PATH}"
if [[ "${MODEL_ENV}" == "base" ]]; then
  command -v python >/dev/null 2>&1 || die "python is not available"
  python -c "import ${MODEL_PYTHON_MODULE}" >/dev/null 2>&1 || die "Python module '${MODEL_PYTHON_MODULE}' is missing from the active environment"
else
  command -v conda >/dev/null 2>&1 || die "conda is required for environment ${MODEL_ENV}"
  conda run -n "${MODEL_ENV}" python -c "import ${MODEL_PYTHON_MODULE}" >/dev/null 2>&1 || die "Python module '${MODEL_PYTHON_MODULE}' is missing from Conda environment ${MODEL_ENV}"
fi
if [[ "${MODEL_ID}" == "mace" ]]; then
  if [[ "${MODEL_ENV}" == "base" ]]; then
    python -c "import torch; assert hasattr(torch.compiler, 'is_compiling')" >/dev/null 2>&1 || die "MACE requires a Torch build exposing torch.compiler.is_compiling"
  else
    conda run -n "${MODEL_ENV}" python -c "import torch; assert hasattr(torch.compiler, 'is_compiling')" >/dev/null 2>&1 || die "MACE environment ${MODEL_ENV} is incompatible: torch.compiler.is_compiling is missing"
  fi
fi
printf 'LAMMPS binary:   %s\n' "${LMP_PATH}"
printf 'ML-GNNP path:    %s\n' "${GNNP_PATH}"
printf 'Python runtime:  %s\n' "${MODEL_ENV}"
printf 'Runtime check:   PASS\n'
