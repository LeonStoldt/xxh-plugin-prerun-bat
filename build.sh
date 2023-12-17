#!/usr/bin/env bash

main() {
  while getopts A:K:q option; do
    case "${option}" in
      q) QUIET=1;;
      A) ARCH=${OPTARG};;
      K) KERNEL=${OPTARG};;
    esac
  done

  check_if_commands_are_present
	build
}

check_if_commands_are_present() {
  commands=("curl" "grep" "cut" "xargs" "chmod")
  for cmd in "${commands[@]}"; do
    need_cmd "${cmd}"
  done
}

need_cmd() {
  if ! check_cmd "$1"; then
    error "need $1 (command not found)"
    exit 1
  fi
}

check_cmd() {
  [ $QUIET ] || >&2 echo "Check $1"
  command -v "$1" >/dev/null 2>&1
}

build() {
  prepare_build_dir
  install_bat
}

prepare_build_dir() {
  CDIR="$(cd "$(dirname "$0")" && pwd)"
  build_dir="${CDIR}/build"
  rm -rf "${build_dir}"
  mkdir -p "${build_dir}"

  cd "${CDIR}" || exit
  cp *prerun.sh *pluginrc.* "${build_dir}/"

  cd "${build_dir}" || exit
}

install_bat() {
  tool_name="bat"
  [ $QUIET ] && arg_s='s' || arg_s=''
  [ $QUIET ] && arg_v='' || arg_v='v'
  [ $QUIET ] || echo "Downloading ${tool_name}..."

  cputype="x86_64"
  clibtype="musl"
  ostype="unknown-linux-${clibtype}"
  target="${cputype}-${ostype}"
  tool_dir="${tool_name}"
  output_tar_dir="${tool_name}-${target}.tar.gz"

  rm -rf "${tool_dir}"

  curl -s "https://api.github.com/repos/sharkdp/${tool_name}/releases/latest" |
    grep "browser_download_url" |
    cut -d '"' -f 4 |
    grep "$target" |
    xargs -n 1 curl -LJ"${arg_s}" -o "${output_tar_dir}" # add -s to last curl to be silent

  mkdir -p "${tool_dir}"
  tar zxf"${arg_v}" "${output_tar_dir}" -C "${tool_dir}" --strip-components=1 # remove v to be silent
  rm -rf "${output_tar_dir}"
}

main "$@" || exit 1
