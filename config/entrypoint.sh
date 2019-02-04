#!/usr/bin/env bash

export USER_ID=${LOCAL_USER_ID:-${USER_ID_DEFAULT}}
export GROUP_ID=${LOCAL_GROUP_ID:-${GROUP_ID_DEFAULT}}

if [ -z "${WORKDIR}" ]; then
    echo 'Using Default value for ${WORKDIR}'
    WORKDIR='/workspace'
fi

# Either use the LOCAL_USER_ID if passed in at runtime or fallback
echo ""
echo "- Starting with UID: ${USER_ID} USER: ${USER} GID: ${GROUP_ID} WORKDIR: ${WORKDIR}"

#  create workdir if it doesn't exist
mkdir -p "${WORKDIR}"

# Fix permissions
usermod ${USER} -u ${USER_ID}
groupmod ${USER} -g ${GROUP_ID}
# useradd --shell /bin/bash -u $USER_ID -o -c "" -m ${USER}

export HOME=/home/${USER}
chown -R ${USER_ID}:${GROUP_ID} "${HOME}"
chown ${USER_ID}:${GROUP_ID} "${WORKDIR}"

# fix workdir permissions if it's not empty
workdir_folder_count=$(ls "${WORKDIR}/" | wc -l)
if [ "$workdir_folder_count" -gt "0" ];then
    ls ${WORKDIR} | xargs chown ${USER_ID}:${GROUP_ID}
fi

echo "-> GoSU user: ${USER} [${USER_ID}] (currently: $(whoami) [$(id)])"
echo ""

# Drop permissions w/ gosu
exec /usr/sbin/gosu ${USER_ID} "$@"
