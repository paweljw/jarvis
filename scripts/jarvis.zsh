#!/bin/zsh
function jarvis_load_variables() {
  if [ ! -f ${JARVIS_DIR}/$1 ]; then
    echo "File ${JARVIS_DIR}/$1 do not exists!"
    exit 1;
  fi;

  export $(cat "${JARVIS_DIR}/$1";)
}

function jarvis_validate_command() {
  if [ "$(whence -w jarvis_command_${COMMAND})" = "jarvis_command_${COMMAND}: function" ]; then
    return 0
  elif [ -z "$COMMAND" ]; then
    jarvis_command_help;
    return 1
  else
    echo "Unknown command: ${COMMAND}";
    return 1
  fi
}

function jarvis_command_cleanup() {
  docker rmi $(docker images -q -f dangling=true)
  ​docker volume rm $(docker volume ls -qf dangling=true)
}

function jarvis_command_env() {
  env
}

function jarvis_command_ps() {
  docker-compose ps
}

function jarvis_command_ddns() {
  bin/ddns.py $MAIN_DOMAIN $HOME_ASSISTANT_SUBDOMAIN 1;
  bin/ddns.py $MAIN_DOMAIN notes.$HOME_ASSISTANT_SUBDOMAIN 0;
  bin/ddns.py $MAIN_DOMAIN $HOME_ASSISTANT_VPNDOMAIN 0;
  bin/ddns.py $MAIN_DOMAIN podcast.$HOME_ASSISTANT_SUBDOMAIN 0;
  bin/ddns.py $MAIN_DOMAIN rss.$HOME_ASSISTANT_SUBDOMAIN 0;
}

function jarvis_command_certbot() {
  systemctl stop nginx;
  certbot renew --no-self-upgrade;
  systemctl start nginx;
}

function jarvis_command_logs() {
  eval "docker-compose logs --tail=1000 -f ${COMMAND_ARGS}"
}

function jarvis_command_docker-compose() {
  eval "docker-compose ${COMMAND_ARGS}"
}

function jarvis_execute_command() {
  if ! jarvis_validate_command; then
    return 1
  fi
  jarvis_command_${COMMAND} ${COMMAND_ARGS}
  return $?
}

function jarvis_command_graylog() {
  source "${JARVIS_DIR}/scripts/graylog.sh"
}

function jarvis_command_media() {
  source "${JARVIS_DIR}/scripts/media.sh"
}
