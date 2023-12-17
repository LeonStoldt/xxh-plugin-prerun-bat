set -x

CURR_DIR="$(cd "$(dirname "$0")" && pwd)" # .xxh/.xxh/plugins/xxh-plugin-prerun-bat/build
plugin_name='bat'
bat_zsh_completion="${CURR_DIR}/${plugin_name}/autocomplete/bat.zsh"

# completions location: .xxh/.xxh/plugins/xxh-plugin-zsh-ohmyzsh/build/ohmyzsh/cache/completions
ohmyzsh_dir="${HOME}/.xxh/plugins/xxh-plugin-zsh-ohmyzsh/build/ohmyzsh"
zsh_completions_dir="${ohmyzsh_dir}/cache/completions"


if [ -d "${ohmyzsh_dir}" ]; then
  if [ -d "${zsh_completions_dir}" ]; then
    if [[ $XXH_VERBOSE == '2' ]]; then
      echo "zsh_completions_dir found."
    fi
  else
    if [[ $XXH_VERBOSE == '2' ]]; then
      echo "zsh_completions_dir not found. creating..."
    fi
    mkdir -p "${zsh_completions_dir}"
  fi

  if [[ $XXH_VERBOSE == '2' ]]; then
    echo "copying completion file: ${bat_zsh_completion} to ${zsh_completions_dir}"
  fi
  cp "${bat_zsh_completion}" "${zsh_completions_dir}/_bat"
  source "${ohmyzsh_dir}/oh-my-zsh.sh"
  autoload -U compinit && compinit

else
  echo "Error: xxh-plugin-zsh-ohmyzsh plugin seems not to be installed. exiting..."
  exit 1
fi
