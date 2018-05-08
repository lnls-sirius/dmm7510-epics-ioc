#!/usr/bin/env bash

set -u

if [ -z "$DMM7510_INSTANCE" ]; then
    echo "DMM7510_INSTANCE environment variable is not set." >&2
    exit 1
fi

export DMM7510_CURRENT_PV_AREA_PREFIX=DMM7510_${DMM7510_INSTANCE}_PV_AREA_PREFIX
export DMM7510_CURRENT_PV_DEVICE_PREFIX=DMM7510_${DMM7510_INSTANCE}_PV_DEVICE_PREFIX
export DMM7510_CURRENT_DEVICE_IP=DMM7510_${DMM7510_INSTANCE}_DEVICE_IP
export DMM7510_CURRENT_DEVICE_PORT=DMM7510_${DMM7510_INSTANCE}_DEVICE_PORT
export DMM7510_CURRENT_DEVICE_TELNET_PORT_SUFFIX=DMM7510_${DMM7510_INSTANCE}_TELNET_PORT_SUFFIX
# Only works with bash
export DMM7510_PV_AREA_PREFIX=${!DMM7510_CURRENT_PV_AREA_PREFIX}
export DMM7510_PV_DEVICE_PREFIX=${!DMM7510_CURRENT_PV_DEVICE_PREFIX}
export DMM7510_DEVICE_IP=${!DMM7510_CURRENT_DEVICE_IP}
export DMM7510_DEVICE_PORT=${!DMM7510_CURRENT_DEVICE_PORT}
export DMM7510_DEVICE_TELNET_PORT=${PROCSERV_DMM7510_PORT_PREFIX}${!DMM7510_CURRENT_DEVICE_TELNET_PORT_SUFFIX}

DMM7510_TYPE=$(echo ${DMM7510_INSTANCE} | grep -Eo "[^0-9]+");

if [ -z "$DMM7510_TYPE" ]; then
    echo "Device instance is invalid. Valid device options are: DCCT, ICT, and DMM." >&2
    echo "The instance format is: <device type><device index>. Example: DCCT1" >&2
    exit 5
fi

./runProcServ.sh \
    -t "${DMM7510_DEVICE_TELNET_PORT}" \
    -i "${DMM7510_DEVICE_IP}" \
    -p "${DMM7510_DEVICE_PORT}" \
    -d "${DMM7510_TYPE}" \
    -P "${DMM7510_PV_AREA_PREFIX}" \
    -R "${DMM7510_PV_DEVICE_PREFIX}"
