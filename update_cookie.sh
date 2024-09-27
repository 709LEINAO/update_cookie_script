#!/bin/bash

# 检查clewd文件夹是否存在
if [ ! -d "clewd" ]; then
    echo "clewd文件夹不存在，请先运行clewd。"
    exit 1
fi

# 进入clewd目录
cd clewd

# 检查config.js文件是否存在
if [ ! -f "config.js" ]; then
    echo "config.js文件不存在，请先运行clewd生成config.js文件。"
    exit 1
fi

# 检查"Cookie": ""内是否存在任意的内容
existing_cookie=$(grep -o '"Cookie": "[^"]*"' config.js | sed 's/"Cookie": "\(.*\)"/\1/')

if [ -n "$existing_cookie" ]; then
    echo "检测到已存在的Cookie值: $existing_cookie"
    echo "请选择操作："
    echo "1. 删除原内容并添加目前输入的内容"
    echo "2. 保留内容并添加目前输入的内容"
    echo "3. 放弃修改"
    read -p "请输入选项 (1/2/3): " choice

    case $choice in
        1)
            # 删除原内容并添加目前输入的内容
            read -p "请输入新的Cookie值: " new_cookie_value
            sed -i "s/\"Cookie\": \"[^\"]*\"/\"Cookie\": \"$new_cookie_value\"/" config.js
            echo "Cookie值已成功替换为: $new_cookie_value"
            ;;
        2)
            # 保留内容并添加目前输入的内容
            read -p "请输入新的Cookie值: " new_cookie_value
            # 清空"Cookie": ""内容
            sed -i 's/"Cookie": "[^"]*"/"Cookie": ""/' config.js
            # 将原内容和新内容添加到"CookieArray": []中
            sed -i "/CookieArray/s/\[\]/\[\"$existing_cookie\",\"$new_cookie_value\"\]/" config.js
            echo "Cookie值已成功添加到CookieArray中: [\"$existing_cookie\",\"$new_cookie_value\"]"
            ;;
        3)
            # 放弃修改
            echo "放弃修改，退出脚本。"
            exit 0
            ;;
        *)
            echo "无效选项，退出脚本。"
            exit 1
            ;;
    esac
else
    # 提示用户输入Cookie值
    read -p "请输入Cookie值: " cookie_value
    # 使用sed命令将Cookie值填入config.js文件
    sed -i "s/\"Cookie\": \"\"/\"Cookie\": \"$cookie_value\"/" config.js
    echo "Cookie值已成功填入config.js文件。"
fi