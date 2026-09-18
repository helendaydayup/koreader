#!/bin/bash
# KOReader 开发/测试环境（macOS）
# 用法: source ./dev-env.sh
# 依赖: 本机代理 127.0.0.1:7890（拉取第三方依赖时需要）

export PATH="$HOME/opt/gnumake/bin:$HOME/opt/bash5/bin:$HOME/opt/coreutils/bin:$HOME/Library/Python/3.9/bin:$PATH"

# kodev 需要 bash >= 4（macOS 自带 3.2），所以统一用:
#   bash ./kodev <command>
# 而不是 ./kodev <command>

# 网络代理（构建时从 GitHub 拉取第三方依赖）
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export all_proxy=http://127.0.0.1:7890

echo "KOReader dev env ready. Use: bash ./kodev <command>"
