#!/bin/bash

set -e

# Ensure the script is run as root.
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Update package lists.
apt-get update

# Install tool installation functions.

install_crow() {
  git clone https://github.com/CrowCpp/Crow.git
  cd Crow
  mkdir build && cd build
  cmake .. && make && make install
  cd ../.. && rm -rf Crow
}

install_webgl() {
  echo "WebGL is a browser API and doesn't require installation on the server."
}

install_threejs() {
  echo "three.js is a JavaScript library for WebGL; include it in your web project as needed."
}

install_libsodium() {
  apt-get install -y libsodium-dev
}

install_boost() {
  apt-get install -y libboost-all-dev
}

install_jmeter() {
  local version="5.4.1"
  wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-${version}.tgz
  tar -xzf apache-jmeter-${version}.tgz -C /opt
  rm apache-jmeter-${version}.tgz
}

install_zaproxy() {
  apt-get install -y zaproxy
}

install_cryptopp() {
  apt-get install -y libcrypto++-dev
}

install_jq() {
  apt-get install -y jq
}

install_alertmanager() {
  local version="0.21.0"
  wget https://github.com/prometheus/alertmanager/releases/download/v${version}/alertmanager-${version}.linux-amd64.tar.gz
  tar -xzf alertmanager-${version}.linux-amd64.tar.gz -C /opt
  rm alertmanager-${version}.linux-amd64.tar.gz
}

install_elk_stack() {
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
  sh -c "echo \"deb https://artifacts.elastic.co/packages/7.x/apt stable main\" > /etc/apt/sources.list.d/elastic-7.x.list"
  apt-get update && apt-get install -y elasticsearch logstash kibana
  systemctl enable elasticsearch logstash kibana
}

install_custom_js() {
  echo "Custom.js is a concept; create your JavaScript files as needed for your project."
}

install_custom_html() {
  echo "Custom HTML elements are defined in your HTML files; no installation required."
}

install_cpp17() {
  apt-get install -y gcc g++
}

install_grafana() {
  apt-get install -y grafana
  systemctl enable grafana-server
}

install_mysqldump() {
  apt-get install -y mysql-client
}

install_tar_scp_openssl() {
  for tool in tar scp openssl; do
    if ! command -v $tool &> /dev/null; then
      apt-get install -y $tool
    fi
  done
}

install_emscripten() {
  git clone https://github.com/emscripten-core/emsdk.git
  cd emsdk
  ./emsdk install latest
  ./emsdk activate latest
  source ./emsdk_env.sh
  cd .. && rm -rf emsdk
}

install_pjsip() {
  apt-get install -y libpjsip-dev
}

install_gnu_zrtp() {
  git clone https://github.com/wernerd/ZRTPCPP.git
  cd ZRTPCPP
  make && make install
  cd ..
}

install_react_native() {
  echo "Installing React Native dependencies..."
  # Install Node.js if it's not already installed.
  if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
    apt-get install -y nodejs
  fi
  # Update npm to the latest version.
  npm install -g npm
  # Optionally install watchman (helpful for React Native projects).
  apt-get install -y watchman || true
  # Install React Native CLI globally.
  npm install -g react-native-cli
}

# New: Install the most recent version of NGINX.
install_nginx() {
  echo "Installing the most recent version of NGINX..."
  # Add the official NGINX signing key.
  wget -qO - https://nginx.org/keys/nginx_signing.key | apt-key add -
  # Add the official NGINX repository.
  echo "deb http://nginx.org/packages/debian $(lsb_release -cs) nginx" > /etc/apt/sources.list.d/nginx.list
  apt-get update
  apt-get install -y nginx
  systemctl enable nginx
}

# Execute installation of all tools.
install_crow
install_webgl
install_threejs
install_libsodium
install_boost
install_jmeter
install_zaproxy
install_cryptopp
install_jq
install_alertmanager
install_elk_stack
install_custom_js
install_custom_html
install_cpp17
install_grafana
install_mysqldump
install_tar_scp_openssl
install_emscripten
install_pjsip
install_gnu_zrtp
install_react_native
install_nginx

echo "All tools installed successfully."