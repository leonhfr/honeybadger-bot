#!/bin/bash

HOME="/home/ubuntu"
DIR_HONEYBADGER="$HOME/honeybadger-bot"
DIR_BOT="$HOME/lichess-bot"
DIR_GH="$HOME/actions-runner"
LICHESS_TOKEN=$1

# utils
p_header() {
    printf "\n$(tput setaf 7)%s$(tput sgr0)\n" "$@"
}

p_log() {
    printf "$(tput setaf 7)%s$(tput sgr0)\n" "$@"
}

p_success() {
    printf "$(tput setaf 64)✓ %s$(tput sgr0)\n" "$@"
}

p_warn() {
    printf "$(tput setaf 136)! %s$(tput sgr0)\n" "$@"
}

source "$DIR_HONEYBADGER/lib/utils.sh"

cd $HOME

# lichess bot repository
p_header "- Cloning repository"
if [ -d $DIR_BOT ]; then
  p_log "- Lichess bot repository already cloned, skipping..."
else
  git clone https://github.com/ShailChoksi/lichess-bot.git $DIR_BOT
  p_success "Cloned repository."
fi

cd $DIR_BOT

# jq
p_header "- Installing jq"
apt install jq --yes
p_success "jq installed."

# Python
p_header "- Installing Python 3"
apt install python3-pip --yes
p_success "Python installed."

# virtualenv
p_header "- Installing virtualenv"
pip install virtualenv
p_success "virtualenv installed."

# setup virtualenv
p_header "- Setting up virtualenv"
apt install python3-venv
python3 -m venv venv
virtualenv venv -p python3
p_success "virtualenv set up."

# install Python dependencies
p_header "- Installing Python dependencies"
python3 -m pip install -r requirements.txt
p_success "Python dependencies installed."

# copying config.yml
p_header "- Copying configuration file"
cp "$DIR_HONEYBADGER/config.yml" "$DIR_BOT/config.yml"
sed -i "1 s/xxxxxxxxxxxxxxxx/$1/" "$DIR_BOT/config.yml"
p_success "Configuration file copied."

# downloading latest honey badger binary
p_header "- Downloading latest honeybadger binary"
cd "$DIR_BOT/engines"
curl -s https://api.github.com/repos/leonhfr/honeybadger/releases/latest \
  | jq -r '.assets[] | select(.name | contains("Linux_arm64")) | .browser_download_url' \
  | xargs -I % curl -L % > honeybadger.tar.gz
tar -xvvf honeybadger.tar.gz
rm honeybadger.tar.gz
p_success "Latest honeybadger binary downloaded."

# setting up the github actions runner service
p_header "- Setting up the Github Actions runner service"
cp "$DIR_HONEYBADGER/github.service" "/lib/systemd/system/"
chmod 644 /lib/systemd/system/github.service
systemctl daemon-reload
systemctl enable github.service
systemctl start github.service
p_success "Hithub Actions runner service set up."

# setting up the bot service
p_header "- Setting up the bot service"
cp "$DIR_HONEYBADGER/bot.service" "/lib/systemd/system/"
chmod 644 /lib/systemd/system/bot.service
systemctl daemon-reload
systemctl enable bot.service
systemctl start bot.service
p_success "Bot service set up."
