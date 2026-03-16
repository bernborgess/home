print_blue() {
        echo -e "\e[0;34m * ${1}\e[0m"
}
print_error() {
        echo -e "\e[0;31m ! ${1}\e[0m"
}
print_usage_exit() {
    echo "Usage: WG_SERVER_PUBKEY=... WG_SERVER_ENDPOINT=... ID=... bash setup_client.sh";
    exit 1;
}

if [ x"${WG_SERVER_PUBKEY}" == "x" ]; then
    print_error "Env var WG_SERVER_PUBKEY is not set"
    print_usage_exit;
elif [ x"${WG_SERVER_ENDPOINT}" == "x" ]; then
    print_error "Env var WG_SERVER_ENDPOINT is not set"
    print_usage_exit;
elif [ x"${ID}" == "x" ]; then
    print_error "Env var ID is not set"
    print_usage_exit;
fi

# Install wireguard
print_blue "Installing wireguard"
sudo apt install wireguard

# Generate keys
if [ ! -f ~/wireguard-keys/private ]; then
    print_blue "Generating wireguard keys"
    mkdir -p ~/wireguard-keys
    cd ~/wireguard-keys
    (umask 0077 && wg genkey | tee private | wg pubkey > public)
else
    print_blue "The wireguard keys already exist, skipping"
fi

# Setup wireguard config
print_blue "Setting wireguard configuration"

cat >> wg0.conf << END
[Interface]
PrivateKey = $(cat ~/wireguard-keys/private)
Address = 10.8.0.$(echo $ID)

[Peer]
PublicKey = $(echo $WG_SERVER_PUBKEY)
Endpoint = $(echo $WG_SERVER_ENDPOINT)
AllowedIPs = 10.8.0.0/24
PersistentKeepalive = 25
END

sudo cp wg0.conf /etc/wireguard/wg0.conf
rm wg0.conf

# Enable and start service
print_blue "Starting wireguard service"
sudo systemctl enable --now wg-quick@wg0

# Feedback for the other end
echo -e "\e[0;34m * Run this on the server:\e[0m"
echo -e "\e[0;32m $ sudo wg set wg0 peer $(cat ~/wireguard-keys/public) allowed-ips 10.8.0.${ID}/32 \e[0m"

