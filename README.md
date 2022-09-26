# honeybadger-bot

Lichess bot running the Honey Badger chess engine on a Raspberry Pi

## Set up

1. As [per the documentation](https://github.com/ShailChoksi/lichess-bot), create a Lichess account, get a OAuth token, and upgrade the account to a bot
2. [Install Ubuntu Server](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi) on the Raspberry Pi.
3. Set up a [Github self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners), using Linux/ARM64 for the Raspberry Pi 3. Skip the step to run it `./run.sh`.
4. Save the Lichess OAuth token as `LICHESS_TOKEN` in the repository secrets.
5. Then, run:

```sh
# From HOME
cd ~
# Clone this repository
git clone https://github.com/leonhfr/honeybadger-bot.git
cd honeybadger-bot
# Running with sudo to set everything up with the lichess token as argument
sudo ./setup.sh lip_651p**************io
```

## Service commands

```sh
# Status:
sudo systemctl status bot.service
# Start:
sudo systemctl start bot.service
# Stop:
sudo systemctl stop bot.service
# Check journal:
sudo journalctl -f -u bot.service
```

# Lichess bot shield

The lichess bot shield uses a netlify function.
