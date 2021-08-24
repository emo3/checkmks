#!/bin/bash
declare i=0;
declare wait=5;
declare timeout=300;
while ! sudo test -f /opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret; do
  if [ ${i} -ge ${timeout} ]; then
    echo "Timed out after ${i}s waiting for CheckMK to complete";
    exit 1;
  fi;
  echo "Waited ${i}/${timeout}s for CheckMK to complete, retrying in ${wait} seconds"
  sleep ${wait};
  let i+=${wait};
done;
sudo cat /opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret;
sudo ip addr;
