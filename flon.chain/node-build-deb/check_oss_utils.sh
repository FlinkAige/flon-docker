#!/bin/bash

# 判断 ossutil 是否已安装
if ! command -v ossutil &> /dev/null; then
    echo "[INFO] ossutil not found. Installing..."

    # 选择安装路径
    INSTALL_DIR="/usr/local/bin"
    OSSUTIL_URL="https://gosspublic.alicdn.com/ossutil/ossutil64"
    TMP_FILE="/tmp/ossutil64"

    # 下载 ossutil
    curl -o "$TMP_FILE" "$OSSUTIL_URL" || {
        echo "[ERROR] Failed to download ossutil"
        exit 1
    }

    # 添加执行权限并移动到安装目录
    chmod +x "$TMP_FILE"
    sudo mv "$TMP_FILE" "$INSTALL_DIR/ossutil"

    echo "[INFO] ossutil installed at $INSTALL_DIR/ossutil"
else
    echo "[INFO] ossutil already installed: $(which ossutil)"
fi

# 可选：展示版本验证
ossutil version
