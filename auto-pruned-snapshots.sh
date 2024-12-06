#!/bin/bash
echo -e "
  _____ _   _ ____   ___  ____  ____  _   _ ___ _   _ _____ 
 | ____| \ | |  _ \ / _ \|  _ \|  _ \| | | |_ _| \ | | ____|
 |  _| |  \| | | | | | | | |_) | |_) | |_| || ||  \| |  _|  
 | |___| |\  | |_| | |_| |  _ <|  __/|  _  || || |\  | |___ 
 |_____|_|_\_|____/_\___/|_|_\_\_|   |_| |_|___|_| \_|_____|
 / ___|_   _|/ \  | |/ / ____|                              
 \___ \ | | / _ \ | ' /|  _|                                
  ___) || |/ ___ \| . \| |___                               
 |____/ |_/_/   \_\_|\_\_____| "
 
echo "Enter your name for Story Service:"
read story_servise

echo "Enter your name for Geth Service:"
read geth_servise

#Stop the Story service
sudo systemctl stop "$story_servise"

#Stop the Geth service
sudo systemctl stop "$geth_servise"

# Save priv_validator_state.json
cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup

# Reset the data 
rm -rf $HOME/.story/story/data
rm -rf $HOME/.story/geth/odyssey/geth/chaindata

# Download la$story_servise snapshots
snapshots1=`curl -s https://story-pruned-snapshots.endorphinestake.com | grep -v geth |grep -oP 'href=".*?\.tar\.lz4"' | awk -F '"' '{print $2}'`
if [ -n "$snapshots1" ]
then curl -L https://story-pruned-snapshots.endorphinestake.com/"$snapshots1" | tar -Ilz4 -xf - -C $HOME/.story/story
fi

snapshots2=`curl -s https://story-pruned-snapshots.endorphinestake.com | grep geth |grep -oP 'href=".*?\.tar\.lz4"' | awk -F '"' '{print $2}'`
if [ -n "$snapshots2" ]
then curl -L https://story-pruned-snapshots.endorphinestake.com/"$snapshots2" | tar -Ilz4 -xf - -C $HOME/.story/geth/odyssey/geth
fi

# Recover validator state
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

# Restart nodes and check logs
sudo systemctl restart $story_servise $geth_servise
sudo journalctl -u $story_servise -u $geth_servise -f

exit 0
