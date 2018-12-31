echo "Installing git"
sudo apt-get install git -y
echo "Installing sublime"
sudo snap install sublime-text --classic -y
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

echo "Adding ondrej ppa for php and nginx"
sudo add-apt-repository -y ppa:ondrej/php
sudo add-apt-repository -y ppa:ondrej/nginx-mainline

echo "Updating repositories"
sudo apt-get update -y

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
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
echo "Composer version is: "
composer --version

echo "Exporting path to zshrc...."
echo "export PATH=\$PATH:\$HOME/.local/bin" >> ~/.zshrc
source ~/.zshrc

echo "Installing php7.1-curl"
sudo apt-get install php7.1-curl -y

sudo apt -y install gitk nmap nethogs dnsmasq

echo "Installing google chrome"
sudo apt-get install google-chrome-stable -y

echo "Installing slack"
sudo apt-get install slack -y

echo "Installing software properties common"
sudo apt-get install -y software-properties-common

echo "Processing cleanup...."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

read -p "Do you want to use node version manager?" CONT
echo
if [ "$CONT" = "y" ];
then
  	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

	echo "Installing node"
	nvm install node

	echo "Node version is:"
	node --version

	echo "Npm version is:"
	npm --version
fi

read -p "Do you want to use yarn (y/n)?" CONT
echo
if [ "$CONT" = "y" ];
then
	npm istall -g yarn
fi

read -p "Do you want to use terminator (y/n)?" CONT
echo
if [ "$CONT" = "y" ];
then
	sudo apt-get install terminator -y
fi

read -p "Do you want to use nginx as your local server?" CONT
echo
if [ "$CONT" = "y" ];
then
	sudo apt-get install nginx -y
fi

echo "Removing apache2...."
sudo apt-get remove apache2 -y

echo "Installation completed!"
echo "If you want to customize your terminal look then please refer: https://github.com/zaffron/terminal-setup"
