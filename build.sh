#!/usr/bin/env bash

main() {
	need_cmd curl
	need_cmd grep
	need_cmd cut
	need_cmd xargs
	need_cmd chmod
	build
}

need_cmd() {
  if ! cmd_chk "$1"; then
    error "need $1 (command not found)"
    exit 1
  fi
}

cmd_chk() {
  >&2 echo "Check $1"
	command -v "$1" >/dev/null 2>&1
}

build() {
  while getopts A:K:q option; do
    case "${option}"
    in
      q) QUIET=1;;
      A) ARCH=${OPTARG};;
      K) KERNEL=${OPTARG};;
    esac
  done

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
  echo "Downloading ${tool_name}..."
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
    xargs -n 1 curl -LJ -o "${output_tar_dir}" # add -s to last curl to be silent

  mkdir -p "${tool_dir}"
  tar -zxvf "${output_tar_dir}" -C "${tool_dir}" --strip-components=1 # remove v to be silent
}

main "$@" || exit 1
