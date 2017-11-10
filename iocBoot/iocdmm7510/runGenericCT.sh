#!/bin/sh

: ${EPICS_HOST_ARCH:?"Environment variable needs to be set"}

DMM7510_TYPE=$(echo ${DMM7510_INSTANCE} | grep -Eo "[^0-9]+");
DMM7510_NUMBER=$(echo ${DMM7510_INSTANCE} | grep -Eo "[0-9]+");

export DMM7510_CURRENT_PV_AREA_PREFIX=DMM7510_${DMM7510_INSTANCE}_PV_AREA_PREFIX
export DMM7510_CURRENT_PV_DEVICE_PREFIX=DMM7510_${DMM7510_INSTANCE}_PV_DEVICE_PREFIX
export DMM7510_CURRENT_DEVICE_IP=DMM7510_${DMM7510_INSTANCE}_DEVICE_IP
export EPICS_PV_AREA_PREFIX=${!DMM7510_CURRENT_PV_AREA_PREFIX}
export EPICS_PV_DEVICE_PREFIX=${!DMM7510_CURRENT_PV_DEVICE_PREFIX}
export EPICS_DEVICE_IP=${!DMM7510_CURRENT_DEVICE_IP}

case ${DMM7510_TYPE} in
    DCCT)
        ST_CMD_FILE=stDCCT.cmd
        ;;

    ICT)
        ST_CMD_FILE=stICT.cmd
        ;;

    *)
        echo "Invalid DMM7510 type: "${DMM7510_TYPE} >&2
        exit 1
        ;;
esac

echo "Using st.cmd file: "${ST_CMD_FILE}

DEVICE_IP=${EPICS_DEVICE_IP} ../../bin/${EPICS_HOST_ARCH}/dmm7510 ${ST_CMD_FILE}
