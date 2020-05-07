#!/bin/zsh
function jarvis_load_variables() {
  if [ ! -f ${JARVIS_DIR}/$1 ]; then
    echo "File ${JARVIS_DIR}/$1 does not exist!"
    exit 1;
  fi;
  export $(cat "${JARVIS_DIR}/$1")
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
  docker volume rm $(docker volume ls -qf dangling=true)
}

function jarvis_command_psql() {
  PGPASSWORD=$POSTGRES_PASSWORD psql --host localhost --username=$POSTGRES_USER --port=5432 $POSTGRES_DB;
}

function jarvis_command_env() {
  env
}

function jarvis_command_ps() {
  docker-compose -f docker-compose.ha.yml ps
}

function jarvis_command_ddns() {
  bin/ddns.py $MAIN_DOMAIN $JARVIS_SUBDOMAIN 1;
  bin/ddns.py $MAIN_DOMAIN $RSS_SUBDOMAIN 1;
  bin/ddns.py $MAIN_DOMAIN $SSH_SUBDOMAIN 0;
  bin/ddns.py $WP_DOMAIN_ONE "" 1;
  bin/ddns.py $WP_DOMAIN_TWO "" 1;
  bin/ddns.py $NEXTCLOUD_DOMAIN;
  bin/ddns.py $WIKI_DOMAIN;
}

function jarvis_command_certbot() {
  systemctl stop nginx;
  /usr/local/bin/certbot renew --no-self-upgrade;
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

function jarvis_command_backup() {
  TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S);
  BACKUP_FILE="${BACKUP_FOLDER}jarvis_$TIMESTAMP.zip";
  mkdir -p $BACKUP_FOLDER;
  echo "Stopping services..."
  systemctl stop ha;
  systemctl stop media;
  systemctl stop shared;
  systemctl stop graylog;
  systemctl stop wordpress;
  echo "Compressing data"
  echo $BACKUP_FILE
  zip -1 -r $BACKUP_FILE $JARVIS_DIR -x"jarvis/.docker/data/plex/config/Library/Application Support/Plex Media Server/Metadata/**/*" -x"*.log" -x"jarvis/.docker/data/plex/config/Library/Application Support/Plex Media Server/Cache/**/*" -x"jarvis/.docker/data/plex/config/Library/Application Support/Plex Media Server/Media/**/*"
  echo "Starting services"
  systemctl start graylog;
  systemctl start shared;
  systemctl start media;
  systemctl start wordpress;
  sleep 30; # HA is not a fan of getting up and not finding its friends
  systemctl start ha;
  echo "Waiting for services to boot"
  sleep 60;
  echo $TIMESTAMP > $BACKUP_FOLDER/performed_at.txt
  echo "Clearing old data"
  find $BACKUP_FOLDER -mtime +3 -type f -delete;
  aws s3 sync $BACKUP_FOLDER s3://adloquium-backups --delete
  echo "Done"
}

function jarvis_command_pushup() {
  echo "Down...";
  sudo systemctl stop ha;
  sudo systemctl stop shared;
  echo "...hoooold it...";
  sleep 60;
  echo "...up!";
  sudo systemctl start shared;
  sudo systemctl start ha;
}

function jarvis_command_unban() {
  sudo fail2ban-client set ha unbanip ${COMMAND_ARGS};
  sudo fail2ban-client set nginx-noscript unbanip ${COMMAND_ARGS};
  sudo fail2ban-client set nginx-http-auth unbanip ${COMMAND_ARGS};
  sudo fail2ban-client set nginx-badbots unbanip ${COMMAND_ARGS};
  sudo fail2ban-client set nginx-forbidden unbanip ${COMMAND_ARGS};
  sudo fail2ban-client set mosquitto-auth unbanip ${COMMAND_ARGS};
}

function jarvis_command_mcmap() {
  export HOME=/home/pjw
  #/usr/local/bin/mcoverviewer --config="/jarvis/.overviewer/config" --simple-output
  #/usr/local/bin/mcoverviewer --config="/jarvis/.overviewer/config" --genpoi
}

function jarvis_command_graylog() {
  source "${JARVIS_DIR}/scripts/graylog.zsh"
}

function jarvis_command_media() {
  source "${JARVIS_DIR}/scripts/media.zsh"
}

function jarvis_command_shared() {
  source "${JARVIS_DIR}/scripts/shared.zsh"
}

function jarvis_command_ha() {
  source "${JARVIS_DIR}/scripts/ha.zsh"
}

function jarvis_command_wordpress() {
  source "${JARVIS_DIR}/scripts/wordpress.zsh"
}
