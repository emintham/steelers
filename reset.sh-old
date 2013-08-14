#! /bin/bash

# --- Purge folders created by Rails and resets db ---

RAILS_HOME=${HOME}/Documents/Steelers

if [ -e ${RAILS_HOME}/u ] ; then
  echo "Removing /u/ ..."
  rm -r ${RAILS_HOME}/u && echo "/u/ removed!"
else
  echo "${RAILS_HOME}/u does not exist! Nothing was done..."
fi

if [ -e ${RAILS_HOME}/confs ] ; then
  echo "Removing /confs/ ..."
  rm -r ${RAILS_HOME}/confs && echo "/confs/ removed!"
else
  echo "${RAILS_HOME}/confs does not exist! Nothing was done..."
fi

if [ -e ${RAILS_HOME}/config_templates ] ; then
  echo "Removing /config_templates/ ..."
  rm -r ${RAILS_HOME}/config_templates && echo "/config_templates/ removed!"
else
  echo "${RAILS_HOME}/config_templates does not exist! Nothing was done..."
fi

echo "Resetting database..."
rake db:reset
