#!/bin/bash

sudo su
git clone --recurse-submodules https://github.com/erkanergen7/ErfanGSIs-VelanGSIs ErfanGSIs
chmod -R 777 ErfanGSIs
cd ErfanGSIs

export ROM_URL=https://liquidtelecom.dl.sourceforge.net/project/rayrzy/ResurrectionRemix/RROS-Q-8.7.2-20210824-rosy-Unofficial.zip
export ROM_NAME=Generic
export TZ=Asia/Jakarta
export MIR=wet
export ZIP_NAME=RROS-Q
export TG_CHAT_ID=-1001580307414
export TG_TOKEN=1852697615:AAGKDF9cYNnTY4Ylm7XjBrsssS31eTtqYfk
export BOT_MSG_URL=https://api.telegram.org/bot$TG_TOKEN/sendMessage

msg() {
    echo -e "\e[1;32m$*\e[0m"
}

err() {
    echo -e "\e[1;41m$*\e[0m"
}

DATE=$(date +"%F-%S")
START=$(date +"%s")

tg_post_msg() {
	curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
	-d "disable_web_page_preview=true" \
	-d "parse_mode=html" \
	-d text="$1"
}

tg_post_build() {
	curl --progress-bar -F document=@"$1" "$BOT_MSG_URL" \
	-F chat_id="$TG_CHAT_ID"  \
	-F "disable_web_page_preview=true" \
	-F "parse_mode=html" \
	-F caption="$3"
}

tg_post_msg "<b>Rom Compilation Started...</b>%0A<b>Date : </b><code>$DATE</code>%0A"
bash setup.sh
apt-get update --fix-missing
./url2GSI.sh $ROM_URL $ROM_NAME

tg_post_msg "<b>===+++ Uploading Rom +++===</b>"
echo " ===+++ Uploading Rom +++==="
# Push Rom to channel
	zip -r output/$ZIP_NAME-GSI-AB.7z output/*-AB-*.img
    ZIP=$(echo $ZIP_NAME-GSI-AB.7z)
    curl -F document=@output/$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
     
    zip -r output/$ZIP_NAME-GSI-Aonly.7z output/*-Aonly-*.img
    ZIP=$(echo $ZIP_NAME-GSI-Aonly.7z)
    curl -F document=@output/$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

INFO() {
     cat output/*-Aonly-*.txt
}

tg_post_msg "<b>Rom Info : </b><code>$INFO</code>%0A"
