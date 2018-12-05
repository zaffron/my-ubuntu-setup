echo "Setting up docker"
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
echo "Docker version is: "
docker version
echo "Adding docker group and adding user to the docker group"
sudo usermod -aG docker $USER
echo "Installing curl"
sudo apt-get install curl -y
echo "Installing docker compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Installed docker compose version is:"
docker-compose --version
echo "#######################################"

echo "Installing make if it is not present"
sudo apt-get install --reinstall make -y

echo "Setting up php"
sudo apt install -y php7.1 php7.1-fpm php7.1-cli php7.1-mbstring php7.1-gd php7.1-intl php7.1-xml php7.1-mysql  php7.1-mcrypt php7.1-zip php7.1-xdebug
cd ~
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi
php composer-setup.php --filename=composer --install-dir=bin --quiet
php -r "unlink('composer-setup.php');"
echo "Composer installed on bin folder"
echo "Composer version is: "
composer --version
echo "Exporting path to zshrc...."
echo "export PATH=\$PATH:\$HOME/.local/bin" >> ~/.zshrc
source ~/.zshrc
echo "Installing php7.1-curl"
sudo apt-get install php7.1-curl -y

sudo apt -y install git gitk nmap gdebi nethogs dnsmasq
echo "Installing google chrome"
sudo apt-get install google-chrome-stable -y
echo "Installing slack"
sudo apt-get install slack -y

echo "Installing software properties common"
sudo apt-get install -y software-properties-common

echo "Processing cleanup...."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "Adding ondrej ppa for php and nginx"
sudo add-apt-repository -y ppa:ondrej/php
sudo add-apt-repository -y ppa:ondrej/nginx-mainline

echo "Installation completed!"
echo "Suggested:"
echo "Set git config"
echo "Add public key to gitlab if there is no public key then generate it. More info here: https://gitlab.com/help/ssh/README#generating-a-new-ssh-key-pair"
echo "Configure dnsmasq"
