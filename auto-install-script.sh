#!/bin/bash

dashboard_menu() {
    clear

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


echo "Welcome to the auto-install script for the Story node."
echo "1. Install Story node"
echo "2. Check logs"
echo "3. Check the synchronization status"
echo "4. Upgrade node"
echo "5. Check versions Geth & Story"
echo "6. Quit"
echo -n "Please enter your choice: "
}

# Function to install the Story node
install_story_node() {
read -p "Enter your node moniker: " moniker

sudo apt update && sudo apt upgrade -y && sudo apt install curl git jq build-essential gcc unzip wget lz4 -y
    
cd ~ && ver="1.22.0" && wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile && source ~/.bash_profile && go version

mkdir -p $HOME/.story/geth/bin $HOME/.story/story/bin

wget -q https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.3-b224fdf.tar.gz -O /tmp/geth-linux-amd64-0.9.3-b224fdf.tar.gz
tar -xzf /tmp/geth-linux-amd64-0.9.3-b224fdf.tar.gz -C /tmp
sudo mv /tmp/geth-linux-amd64-0.9.3-b224fdf/geth $HOME/.story/geth/bin/
   
git clone https://github.com/piplabs/story
cd story
git checkout v0.10.1
go build -o story ./client
sudo mv ~/story/story $HOME/.story/story/bin/
   
echo 'export PATH="$HOME/.story/geth/bin:$HOME/.story/story/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile

sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Geth Node
After=network.target

[Service]
User=$USER
Type=simple
WorkingDirectory=$HOME/.story/geth
ExecStart=$(which geth) --iliad --syncmode full
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && \
sudo systemctl enable story-geth && \
sudo systemctl start story-geth

story init --network iliad --moniker "$moniker"
   
PEERS=$(curl -sS https://story-testnet-cosmos-rpc.crouton.digital/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd, -)
echo "Updating peers..."
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.story/story/config/config.toml
   
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Protocol Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/.story/story
Type=simple
ExecStart=$(which story) run
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && \
sudo systemctl enable story && \
sudo systemctl start story

echo -e "\nStory Node installed"

while true; do
        echo -e "\nWhat would you like to do next?"
        echo "1. Back to dashboard menu"
        echo "2. Quit"
        read -p "Enter your choice: " post_install_choice
        case $post_install_choice in
                1)
                        return
                        ;;
                2)
                        echo "Exiting the script. Goodbye!"
                        exit 0
                        ;;
                *)
                        echo "Invalid option. Please try again."
                        ;;
        esac
done    
}


# Function to check logs
check_logs() {
echo -e "\nPlease choose the logs to check:"
echo "1. Check Story logs"
echo "2. Check Geth logs"
echo "3. Quit"
echo -n "Please enter your choice: "
read log_choice

case $log_choice in
        1)
                echo -e "\nChecking Story logs... Press Ctrl+C to exit"
                sudo journalctl -u story -f -o cat
                ;;
        2)
                echo -e "\nChecking Story-Geth logs... Press Ctrl+C to exit"
                sudo journalctl -u story-geth -f -o cat
                ;;
        3)
                echo "Exiting log check."
                ;;
        *)
                echo "Invalid option."
                ;;
esac
}

# Check the synchronization status
check_sync_status() {
echo -e "\nChecking node sync status..."
trap 'return' INT
while true; do
        local_height=$(curl -s localhost:26657/status | jq -r '.result.sync_info.latest_block_height')
        network_height=$(curl -s https://story-rpc.endorphinestake.com//status | jq -r '.result.sync_info.latest_block_height')
        blocks_left=$((network_height - local_height))

        echo -e "\033[1;32mYour node height:\033[0m \033[1;34m$local_height\033[0m" \
                        "| \033[1;33mNetwork height:\033[0m \033[1;36m$network_height\033[0m" \
                        "| \033[1;37mBlocks left:\033[0m \033[1;31m$blocks_left\033[0m"

        sleep 5
done
}

# Function Upgrade node 
upgrade_menu() {
wget https://storage.crouton.digital/testnet/story/bin/geth
chmod +x geth
mv geth $HOME/.story/geth/bin/

rm -rf story
wget https://storage.crouton.digital/testnet/story/bin/story
chmod +x story
mv story $HOME/.story/story/bin/
}


# Function to check versions Geth & Story
check_version() {
    echo -e "\nPlease choose which version to check:"
    echo "1. Story version"
    echo "2. Geth version"
    echo "3. Back to main menu"
    echo -n "Please enter your choice: "
    read version_choice

    case $version_choice in
        1)
            echo -e "\nChecking Story version..."
            $HOME/.story/story/bin/story version
            ;;
        2)
            echo -e "\nChecking Story-Geth version..."
            $HOME/.story/geth/bin/geth version
            ;;
        3)
            return
            ;;
        *)
            echo "Invalid option."
            ;;
    esac

    echo -e "\nPress Enter to continue..."
    read
}

# Main script
while true; do
    dashboard_menu
    read choice
    case $choice in
        1)
            install_story_node
            ;;
        2)
            check_logs
            ;;
        3)
            check_sync_status
            ;;
        4)
            upgrade_menu
            ;;      
        5)
            check_version
            ;;
        6)
            echo "Exiting the dashboard."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done
