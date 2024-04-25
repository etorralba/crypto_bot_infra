#!/bin/bash
mkdir ft_userdata
cd ft_userdata/

cp ../docker-compose.yml .

# Pull the freqtrade image
sudo docker-compose pull

# Create user directory structure
sudo docker-compose run --rm freqtrade create-userdir --userdir user_data

# Copy the example strategy to the correct location
cp ../IchimokuStrategy.py user_data/strategies/IchimokuStrategy.py
cp ../config.json user_data/config.json

sudo docker compose up -d