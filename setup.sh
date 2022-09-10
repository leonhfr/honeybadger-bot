#!/bin/bash

HOME="/home/ubuntu"
DIR_HONEYBADGER="$HOME/honeybadger-bot"
DIR_BOT="$HOME/lichess-bot"
DIR_GH="$HOME/actions-runner"
LICHESS_TOKEN=$1

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
source ./venv/bin/activate
p_success "virtualenv set up."

# install Python dependencies
p_header "- Installing Python dependencies"
python3 -m pip install -r requirements.txt
p_success "Python dependencies installed."

# copying config.yml
p_header "- Copying configuration file"
cp "$DIR_HONEYBADGER/config.yml" "$DIR_BOT/config.yml"
sed "1 s/xxxxxxxxxxxxxxxx/$1/" "$DIR_BOT/config.yml"
p_success "Configuration file copied."
