#!/usr/bin/with-contenv bash

SLEEP_DURATION=${SLEEP_DURATION:-30}

echo "<------------------------------------------------->"
echo "Running PyInstaLive"
echo "Running continuously with SLEEP=${SLEEP_DURATION}"
echo "<------------------------------------------------->"

CONFIG_FILE='/config/pyinstalive.ini'
DOWNLOAD_BASEDIR=$(awk -F "=" '/download_path/ {print $2}' ${CONFIG_FILE} | sed -e 's/^[[:space:]]*//')

while true
do
    DATE=$(date +'%Y-%m-%d')
    DOWNLOAD_DIR="${DOWNLOAD_BASEDIR}/${DATE}"

    if [ ! -d "${DOWNLOAD_DIR}" ]; then
        echo "Can't find ${DOWNLOAD_DIR}. Creating."
        mkdir -p ${DOWNLOAD_DIR}
    fi
    echo "Using DOWNLOAD_DIR=${DOWNLOAD_DIR}"
    /usr/local/bin/pyinstalive -df -cp /config/pyinstalive.ini -dp ${DOWNLOAD_DIR}
	sleep ${SLEEP_DURATION}
done

