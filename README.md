# xxh prerun plugin for [bat](https://github.com/sharkdp/bat)

## Installation
1. Install the plugin separately:
```shell
xxh +I https://github.com/LeonStoldt/xxh-plugin-prerun-bat
```

2. Install the plugin via config.xxhc: (e.g.)
```shell
hosts:
  ".*":
    #[...]
    +I:
      - https://github.com/LeonStoldt/xxh-plugin-prerun-bat
    #[...]  
```

3. Install on-the-fly while connecting via xxh:
```shell
xxh <HOST> +I https://github.com/LeonStoldt/xxh-plugin-prerun-bat
#OR using zsh seamless mode:
source xxh.zsh <HOST> +I https://github.com/LeonStoldt/xxh-plugin-prerun-bat
```

## Usage
After connecting to your host using xxh, bat will be available via `bat`.
Checkout `bat --help` or visit [bat GitHub page](https://github.com/sharkdp/bat) for usage information.

## Credits
- bat is provided by: [sharkdp/bat](https://github.com/sharkdp/bat)
- This plugin was created with [xxh-prerun-plugin cookiecutter template](https://github.com/xxh/cookiecutter-xxh-plugin-prerun).