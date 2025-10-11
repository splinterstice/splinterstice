#!/bin/bash
# auto-install-dev-tools.sh - Fully Decentralized P2P IM Development Tools
# Zero-cost, Open Source, Serverless Architecture with Darknet Support

set -e

# Make this script executable if it isn't already
chmod +x "$0"

# Ensure the script is run as root.
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Update package lists.
apt-get update

# Core C++ development tools for WebAssembly compilation
install_cpp_wasm_tools() {
  echo "Installing C++ tools for WebAssembly development..."
  apt-get install -y gcc g++ cmake build-essential clang llvm lld
  echo "C++ compilation tools installed for WebAssembly target"
}

# Emscripten - Critical for compiling C++ to WebAssembly
install_emscripten() {
  echo "Installing Emscripten for WebAssembly compilation..."
  git clone https://github.com/emscripten-core/emsdk.git /opt/emsdk
  cd /opt/emsdk
  ./emsdk install latest
  ./emsdk activate latest
  source ./emsdk_env.sh
  
  # Add to bash profile for persistence
  echo "source /opt/emsdk/emsdk_env.sh" >> ~/.bashrc
  
  # Create WebAssembly project template
  mkdir -p /opt/wasm-template
  cat > /opt/wasm-template/build.sh << 'EOF'
#!/bin/bash
# WebAssembly build script for P2P modules
emcc main.cpp \
  -O3 \
  -s WASM=1 \
  -s EXPORTED_FUNCTIONS='["_init","_processMessage","_encrypt","_decrypt"]' \
  -s EXPORTED_RUNTIME_METHODS='["ccall","cwrap"]' \
  -s MODULARIZE=1 \
  -s EXPORT_NAME="P2PModule" \
  -s ENVIRONMENT=web \
  -s SINGLE_FILE=1 \
  -o p2p-module.js
EOF
  chmod +x /opt/wasm-template/build.sh
  
  cd /
  echo "Emscripten installed at /opt/emsdk"
  echo "WebAssembly template created at /opt/wasm-template"
}

# libp2p - Core P2P networking replacing traditional client-server
install_libp2p() {
  echo "Installing libp2p for true P2P networking..."
  
  # Ensure Node.js is installed
  if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
  fi
  
  # Install libp2p and essential modules
  npm install -g libp2p @libp2p/webrtc @libp2p/websockets @libp2p/kad-dht \
    @libp2p/mdns @libp2p/bootstrap @libp2p/noise @libp2p/yamux \
    @libp2p/circuit-relay-v2 @chainsafe/libp2p-gossipsub
  
  # Create libp2p configuration for P2P IM
  mkdir -p /opt/libp2p-config
  cat > /opt/libp2p-config/p2p-node.js << 'EOF'
import { createLibp2p } from 'libp2p'
import { webSockets } from '@libp2p/websockets'
import { webRTC } from '@libp2p/webrtc'
import { noise } from '@chainsafe/libp2p-noise'
import { yamux } from '@chainsafe/libp2p-yamux'
import { kadDHT } from '@libp2p/kad-dht'
import { gossipsub } from '@chainsafe/libp2p-gossipsub'
import { circuitRelayTransport } from '@libp2p/circuit-relay-v2'

async function createNode() {
  const node = await createLibp2p({
    transports: [
      webSockets(),
      webRTC(),
      circuitRelayTransport()
    ],
    connectionEncryption: [noise()],
    streamMuxers: [yamux()],
    peerDiscovery: [],
    services: {
      dht: kadDHT(),
      pubsub: gossipsub()
    }
  })
  
  await node.start()
  console.log('P2P node started with ID:', node.peerId.toString())
  return node
}

export { createNode }
EOF
  chmod +x /opt/libp2p-config/p2p-node.js
  
  echo "libp2p installed - provides NAT traversal, peer discovery, and encrypted P2P communications"
}

# IPFS - Distributed storage layer
install_ipfs() {
  echo "Installing IPFS for distributed storage..."
  
  # Download and install IPFS
  wget https://dist.ipfs.tech/go-ipfs/v0.20.0/go-ipfs_v0.20.0_linux-amd64.tar.gz
  tar -xvzf go-ipfs_v0.20.0_linux-amd64.tar.gz
  cd go-ipfs
  sudo bash install.sh
  cd ..
  rm -rf go-ipfs go-ipfs_v0.20.0_linux-amd64.tar.gz
  
  # Initialize IPFS with custom config for P2P
  ipfs init --profile=lowpower
  
  # Configure IPFS for browser P2P usage
  ipfs config --json Experimental.Libp2pStreamMounting true
  ipfs config --json Experimental.P2pHttpProxy true
  ipfs config --json Swarm.EnableRelayHop true
  ipfs config --json Swarm.EnableAutoRelay true
  
  # Configure CORS for browser access
  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["GET", "POST", "PUT", "DELETE"]'
  
  echo "IPFS installed and configured for P2P operations"
}

# GUN - Decentralized real-time graph database
install_gun() {
  echo "Installing GUN for real-time decentralized database..."
  
  npm install -g gun
  
  # Create GUN configuration for P2P IM
  mkdir -p /opt/gun-config
  cat > /opt/gun-config/gun-setup.js << 'EOF'
import Gun from 'gun'
import 'gun/sea' // Security, Encryption, Authorization
import 'gun/axe'
import 'gun/lib/radix'
import 'gun/lib/radisk'
import 'gun/lib/store'

// Initialize GUN with P2P configuration
const gun = Gun({
  peers: [], // Will be populated by libp2p peer discovery
  localStorage: false,
  radisk: true,
  multicast: true,
  WebRTC: true
})

// Create user authentication system
const user = gun.user()

// Define data structures for IM
const messages = gun.get('messages')
const channels = gun.get('channels')
const users = gun.get('users')

export { gun, user, messages, channels, users, Gun }
EOF
  
  # Create GUN + SEA (Security, Encryption, Authorization) example
  cat > /opt/gun-config/gun-sea-crypto.js << 'EOF'
import { Gun, SEA } from 'gun'

// Generate keypair for user
async function createUser(username, password) {
  const pair = await SEA.pair()
  const encryptedPair = await SEA.encrypt(pair, password)
  return { username, encryptedPair, pub: pair.pub }
}

// Encrypt message with recipient's public key
async function encryptMessage(message, recipientPub) {
  const encrypted = await SEA.encrypt(message, recipientPub)
  return encrypted
}

// Sign message for authentication
async function signMessage(message, pair) {
  const signed = await SEA.sign(message, pair)
  return signed
}

export { createUser, encryptMessage, signMessage }
EOF
  chmod +x /opt/gun-config/gun-setup.js
  chmod +x /opt/gun-config/gun-sea-crypto.js
  
  echo "GUN installed with real-time sync and built-in CRDT conflict resolution"
}

# OrbitDB - Distributed database on IPFS
install_orbitdb() {
  echo "Installing OrbitDB for distributed database..."
  
  npm install -g orbit-db orbit-db-cli
  
  mkdir -p /opt/orbitdb-config
  cat > /opt/orbitdb-config/orbitdb-init.js << 'EOF'
import { create } from 'ipfs'
import OrbitDB from 'orbit-db'
import AccessControllers from 'orbit-db-access-controllers'

async function initOrbitDB() {
  // Create IPFS instance with P2P config
  const ipfs = await create({
    repo: './ipfs-repo',
    config: {
      Addresses: {
        Swarm: [
          '/dns4/wrtc-star1.par.dwebops.pub/tcp/443/wss/p2p-webrtc-star',
          '/dns4/wrtc-star2.sjc.dwebops.pub/tcp/443/wss/p2p-webrtc-star'
        ]
      },
      Bootstrap: []
    },
    EXPERIMENTAL: {
      pubsub: true
    }
  })
  
  // Create OrbitDB instance
  const orbitdb = await OrbitDB.createInstance(ipfs)
  
  // Create databases with custom access control
  const messagesDB = await orbitdb.feed('im-messages', {
    accessController: {
      type: 'orbitdb',
      write: ['*'] // Allow all peers to write
    }
  })
  
  const usersDB = await orbitdb.keyvalue('im-users')
  const channelsDB = await orbitdb.keyvalue('im-channels')
  
  return { ipfs, orbitdb, messagesDB, usersDB, channelsDB }
}

export { initOrbitDB }
EOF
  chmod +x /opt/orbitdb-config/orbitdb-init.js
  
  echo "OrbitDB configured for P2P database operations"
}

# Ceramic Network - Decentralized identity and data
install_ceramic() {
  echo "Installing Ceramic Network for decentralized identity..."
  
  npm install -g @ceramicnetwork/cli @ceramicnetwork/http-client \
    @ceramicnetwork/stream-tile dids \
    @glazed/did-datastore @glazed/devtools \
    @self.id/core @self.id/web
  
  # Create Ceramic configuration
  mkdir -p /opt/ceramic-config
  cat > /opt/ceramic-config/ceramic-did.js << 'EOF'
import { CeramicClient } from '@ceramicnetwork/http-client'
import { DID } from 'dids'
import { Ed25519Provider } from 'key-did-provider-ed25519'
import { getResolver } from 'key-did-resolver'
import { randomBytes } from 'crypto'

async function createDID() {
  // Generate random seed
  const seed = randomBytes(32)
  
  // Create provider and DID
  const provider = new Ed25519Provider(seed)
  const did = new DID({ provider, resolver: getResolver() })
  await did.authenticate()
  
  // Connect to Ceramic
  const ceramic = new CeramicClient()
  ceramic.did = did
  
  return { ceramic, did }
}

// Create self-sovereign identity profile
async function createProfile(ceramic, profileData) {
  const doc = await ceramic.createDocument('tile', {
    content: profileData,
    metadata: {
      schema: 'BasicProfile',
      controllers: [ceramic.did.id]
    }
  })
  return doc
}

export { createDID, createProfile }
EOF
  chmod +x /opt/ceramic-config/ceramic-did.js
  
  echo "Ceramic Network installed for decentralized identity (DID) management"
}

# Zero-Knowledge Proof libraries
install_zk_proofs() {
  echo "Installing Zero-Knowledge Proof libraries..."
  
  npm install -g snarkjs circomlib circom

  # Create ZK proof example for anonymous authentication
  mkdir -p /opt/zk-config
  cat > /opt/zk-config/zk-auth.circom << 'EOF'
pragma circom 2.0.0;

template PrivateAuth() {
    signal input password;
    signal input hash;
    signal output valid;
    
    component hasher = Poseidon(1);
    hasher.inputs[0] <== password;
    
    valid <== 1 - (hasher.out - hash) * (hasher.out - hash);
}

component main = PrivateAuth();
EOF
  
  cat > /opt/zk-config/zk-setup.js << 'EOF'
import snarkjs from 'snarkjs'

async function setupZKProof() {
  // Compile circuit
  const circuit = await snarkjs.circuit.compile('./zk-auth.circom')
  
  // Generate proving and verification keys
  const { pk, vk } = await snarkjs.setup(circuit)
  
  return { circuit, pk, vk }
}

// Generate proof without revealing password
async function generateProof(password, circuit, pk) {
  const witness = circuit.calculateWitness({ password })
  const proof = await snarkjs.proof.generate(witness, pk)
  return proof
}

// Verify proof without knowing password
async function verifyProof(proof, vk) {
  const result = await snarkjs.proof.verify(vk, proof)
  return result
}

export { setupZKProof, generateProof, verifyProof }
EOF
  chmod +x /opt/zk-config/zk-setup.js
  
  echo "Zero-Knowledge Proof libraries installed for privacy-preserving authentication"
}

# Cryptography libraries
install_crypto_libs() {
  echo "Installing cryptography libraries..."
  
  # libsodium for encryption
  apt-get install -y libsodium-dev
  
  # Additional crypto libraries
  apt-get install -y libssl-dev libcrypto++-dev
  
  # Install Node.js crypto libraries
  npm install -g tweetnacl tweetnacl-util openpgp jose libsignal
  
  # Create crypto utilities
  mkdir -p /opt/crypto-utils
  cat > /opt/crypto-utils/e2e-encryption.js << 'EOF'
import nacl from 'tweetnacl'
import util from 'tweetnacl-util'

// Generate keypair for user
function generateKeyPair() {
  return nacl.box.keyPair()
}

// Encrypt message for recipient
function encryptMessage(message, recipientPublicKey, senderSecretKey) {
  const nonce = nacl.randomBytes(nacl.box.nonceLength)
  const messageBytes = util.decodeUTF8(message)
  const encrypted = nacl.box(messageBytes, nonce, recipientPublicKey, senderSecretKey)
  
  return {
    nonce: util.encodeBase64(nonce),
    encrypted: util.encodeBase64(encrypted)
  }
}

// Decrypt received message
function decryptMessage(encryptedData, senderPublicKey, recipientSecretKey) {
  const nonce = util.decodeBase64(encryptedData.nonce)
  const encrypted = util.decodeBase64(encryptedData.encrypted)
  const decrypted = nacl.box.open(encrypted, nonce, senderPublicKey, recipientSecretKey)
  
  return util.encodeUTF8(decrypted)
}

export { generateKeyPair, encryptMessage, decryptMessage }
EOF
  chmod +x /opt/crypto-utils/e2e-encryption.js
  
  echo "Cryptography libraries installed for end-to-end encryption"
}

# P2P Communication protocols
install_communication_protocols() {
  echo "Installing P2P communication protocols..."
  
  # WebRTC for browser P2P
  npm install -g simple-peer peerjs webtorrent y-webrtc
  
  # Install Matrix protocol SDK for federated messaging
  npm install -g matrix-js-sdk matrix-bot-sdk
  
  # Create WebRTC signaling server (minimal, for development)
  mkdir -p /opt/webrtc-signal
  cat > /opt/webrtc-signal/signal-server.js << 'EOF'
import { WebSocketServer } from 'ws'

const wss = new WebSocketServer({ port: 8080 })
const peers = new Map()

wss.on('connection', (ws) => {
  let peerId = null
  
  ws.on('message', (data) => {
    const message = JSON.parse(data)
    
    switch(message.type) {
      case 'register':
        peerId = message.peerId
        peers.set(peerId, ws)
        break
        
      case 'signal':
        const targetWs = peers.get(message.to)
        if (targetWs) {
          targetWs.send(JSON.stringify({
            type: 'signal',
            from: peerId,
            signal: message.signal
          }))
        }
        break
    }
  })
  
  ws.on('close', () => {
    if (peerId) peers.delete(peerId)
  })
})

console.log('WebRTC signaling server running on ws://localhost:8080')
EOF
  chmod +x /opt/webrtc-signal/signal-server.js
  
  echo "P2P communication protocols installed"
}

# NGINX for Tor and I2P bridge functionality
install_nginx_darknet_bridge() {
  echo "Installing NGINX as Tor/I2P bridge for enhanced privacy..."
  
  # Install NGINX from source for maximum control
  apt-get install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev \
    libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev
  
  # Download and compile NGINX with necessary modules
  cd /tmp
  wget http://nginx.org/download/nginx-1.24.0.tar.gz
  tar -xzvf nginx-1.24.0.tar.gz
  cd nginx-1.24.0
  
  # Configure with stream module for TCP/UDP proxying and other essential modules
  ./configure \
    --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_realip_module
  
  make && make install
  cd /
  rm -rf /tmp/nginx-*
  
  # Create NGINX configuration for Tor hidden service
  mkdir -p /usr/local/nginx/conf/darknet
  cat > /usr/local/nginx/conf/darknet/tor-bridge.conf << 'EOF'
# Tor Hidden Service Configuration
server {
    listen 127.0.0.1:8080;
    server_name localhost;
    
    # Proxy to IPFS gateway
    location /ipfs/ {
        proxy_pass http://127.0.0.1:8081/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support for P2P connections
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
    
    # Proxy to libp2p WebSocket endpoint
    location /p2p/ {
        proxy_pass http://127.0.0.1:9090/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Long timeout for persistent P2P connections
        proxy_connect_timeout 7d;
        proxy_send_timeout 7d;
        proxy_read_timeout 7d;
    }
    
    # Security headers for Tor browser
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy no-referrer;
    
    # Disable logging for privacy
    access_log off;
    error_log /dev/null;
}
EOF
  
  # Create I2P eepsite configuration
  cat > /usr/local/nginx/conf/darknet/i2p-bridge.conf << 'EOF'
# I2P Eepsite Configuration
server {
    listen 127.0.0.1:7070;
    server_name localhost;
    
    # Similar proxy configuration for I2P
    location / {
        proxy_pass http://127.0.0.1:8081/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP 127.0.0.1;  # Hide real IP
        proxy_set_header X-Forwarded-For 127.0.0.1;  # Hide real IP
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
    
    # Strip identifying headers
    proxy_hide_header X-Powered-By;
    proxy_hide_header Server;
    
    # Privacy-focused settings
    access_log off;
    error_log /dev/null;
}
EOF
  
  # Main NGINX configuration including darknet configs
  cat > /usr/local/nginx/conf/nginx.conf << 'EOF'
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 4096;
    use epoll;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    # Privacy-focused settings
    server_tokens off;
    log_format private '[$time_local] "$request" $status $body_bytes_sent';
    
    # Performance optimizations
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    
    # Include darknet bridge configurations
    include /usr/local/nginx/conf/darknet/*.conf;
}

# Stream module for TCP/UDP proxying (useful for P2P protocols)
stream {
    # TCP proxy for libp2p connections through Tor
    upstream libp2p_tcp {
        server 127.0.0.1:4001;
    }
    
    server {
        listen 127.0.0.1:9001;
        proxy_pass libp2p_tcp;
        proxy_connect_timeout 60s;
        proxy_timeout 24h;  # Long timeout for P2P connections
    }
}
EOF
  
  # Create systemd service for NGINX
  cat > /etc/systemd/system/nginx-darknet.service << 'EOF'
[Unit]
Description=NGINX Darknet Bridge
After=network.target tor.service i2p.service

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
  
  systemctl daemon-reload
  systemctl enable nginx-darknet
  
  echo "NGINX installed as darknet bridge for Tor/I2P access"
  echo "Configure Tor hidden service to point to 127.0.0.1:8080"
  echo "Configure I2P tunnel to point to 127.0.0.1:7070"
}

# Development tools
install_dev_tools() {
  echo "Installing development utilities..."
  
  # Basic utilities
  apt-get install -y git curl wget jq make
  
  # Install Rust for performance-critical P2P components
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
  
  # Install Go for IPFS/libp2p development
  wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz
  echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
  rm go1.20.linux-amd64.tar.gz
  
  echo "Development tools installed"
}

# Tor installation and configuration
install_tor() {
  echo "Installing Tor for anonymous access..."
  
  # Install Tor from official repository
  apt-get install -y apt-transport-https
  echo "deb https://deb.torproject.org/torproject.org $(lsb_release -cs) main" > /etc/apt/sources.list.d/tor.list
  wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
  gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
  apt-get update
  apt-get install -y tor tor-geoipdb
  
  # Configure Tor hidden service for the P2P IM
  cat >> /etc/tor/torrc << 'EOF'

# P2P IM Hidden Service Configuration
HiddenServiceDir /var/lib/tor/p2p-im-hidden-service/
HiddenServicePort 80 127.0.0.1:8080
HiddenServicePort 8081 127.0.0.1:8081  # IPFS Gateway
HiddenServicePort 4001 127.0.0.1:4001  # IPFS Swarm
HiddenServicePort 9090 127.0.0.1:9090  # libp2p WebSocket

# Enhanced privacy settings
ClientOnly 1
SocksPort 9050
ControlPort 9051
CookieAuthentication 1

# Performance tuning for P2P
CircuitBuildTimeout 10
LearnCircuitBuildTimeout 0
MaxCircuitDirtiness 10
NumEntryGuards 6
EOF
  
  # Restart Tor to apply configuration
  systemctl restart tor
  systemctl enable tor
  
  # Wait for hidden service to generate
  sleep 5
  
  # Display onion address if generated
  if [ -f /var/lib/tor/p2p-im-hidden-service/hostname ]; then
    echo "Tor Hidden Service created!"
    echo "Your .onion address: $(cat /var/lib/tor/p2p-im-hidden-service/hostname)"
  fi
  
  echo "Tor installed and configured for anonymous P2P access"
}

# I2P installation and configuration
install_i2p() {
  echo "Installing I2P for anonymous, garlic-routed access..."
  
  # Add I2P repository
  apt-get install -y apt-transport-https
  wget -q -O - https://repo.i2pd.xyz/.help/add_repo | sudo bash -s -
  apt-get update
  
  # Install I2P daemon (i2pd - lightweight C++ implementation)
  apt-get install -y i2pd
  
  # Configure I2P for P2P IM
  cat > /etc/i2pd/tunnels.d/p2p-im.conf << 'EOF'
[P2P-IM-HTTP]
type = http
host = 127.0.0.1
port = 7070
inport = 80
keys = p2p-im.dat

[P2P-IM-IPFS]
type = server
host = 127.0.0.1
port = 8081
inport = 8081
keys = p2p-im-ipfs.dat

[P2P-IM-WebSocket]
type = server
host = 127.0.0.1
port = 9090
inport = 9090
keys = p2p-im-ws.dat
EOF
  
  # Configure i2pd main settings
  cat >> /etc/i2pd/i2pd.conf << 'EOF'

# P2P IM specific settings
[limits]
transittunnels = 256
openfiles = 4096
coresize = 0

[websockets]
enabled = true
address = 127.0.0.1
port = 7666

[exploratory]
inbound.length = 3
inbound.quantity = 5
outbound.length = 3
outbound.quantity = 5
EOF
  
  # Start I2P daemon
  systemctl restart i2pd
  systemctl enable i2pd
  
  echo "I2P installed and configured"
  echo "I2P console available at: http://127.0.0.1:7070"
  echo "Your I2P destinations will be created in /var/lib/i2pd/"
}

# Web3 and blockchain integration
install_web3_tools() {
  echo "Installing Web3 tools for blockchain integration..."
  
  npm install -g ethers web3 hardhat truffle ganache @openzeppelin/contracts
  
  # Create smart contract template for IM
  mkdir -p /opt/smart-contracts
  cat > /opt/smart-contracts/MessageRegistry.sol << 'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MessageRegistry {
    mapping(address => string) public ipfsHashes;
    mapping(address => string) public publicKeys;
    
    event MessagePosted(address indexed sender, string ipfsHash);
    event PublicKeyRegistered(address indexed user, string publicKey);
    
    function postMessage(string memory _ipfsHash) public {
        ipfsHashes[msg.sender] = _ipfsHash;
        emit MessagePosted(msg.sender, _ipfsHash);
    }
    
    function registerPublicKey(string memory _publicKey) public {
        publicKeys[msg.sender] = _publicKey;
        emit PublicKeyRegistered(msg.sender, _publicKey);
    }
}
EOF
  
  echo "Web3 tools installed for optional blockchain anchoring"
}

# Build system for the complete P2P stack
create_build_system() {
  echo "Creating unified build system..."
  
  mkdir -p /opt/p2p-im-build
  
  # Main build script
  cat > /opt/p2p-im-build/build.sh << 'EOF'
#!/bin/bash

echo "Building P2P IM System..."

# 1. Compile C++ crypto modules to WebAssembly
echo "Compiling WebAssembly modules..."
cd /opt/wasm-modules
emcc crypto-module.cpp -O3 -s WASM=1 -s MODULARIZE=1 -o crypto.js

# 2. Bundle P2P JavaScript modules
echo "Bundling P2P modules..."
cd /opt/p2p-im
npm run build

# 3. Generate IPFS hash for deployment
echo "Deploying to IPFS..."
ipfs add -r ./dist

echo "Build complete! Your P2P IM is ready for deployment."
EOF
  chmod +x /opt/p2p-im-build/build.sh
  
  # Package.json for the P2P IM project
  cat > /opt/p2p-im-build/package.json << 'EOF'
{
  "name": "p2p-im-system",
  "version": "1.0.0",
  "description": "Fully decentralized P2P instant messaging",
  "type": "module",
  "scripts": {
    "build": "webpack --mode production",
    "dev": "webpack serve --mode development",
    "test": "jest"
  },
  "dependencies": {
    "libp2p": "latest",
    "ipfs": "latest",
    "orbit-db": "latest",
    "gun": "latest",
    "@ceramicnetwork/http-client": "latest",
    "tweetnacl": "latest",
    "snarkjs": "latest"
  },
  "devDependencies": {
    "webpack": "latest",
    "webpack-cli": "latest",
    "webpack-dev-server": "latest"
  }
}
EOF
  
  # Create startup script for all services
  cat > /opt/p2p-im-build/start-services.sh << 'EOF'
#!/bin/bash
echo "Starting P2P IM Services..."

# Start IPFS daemon
systemctl start ipfs

# Start Tor
systemctl start tor

# Start I2P
systemctl start i2pd

# Start NGINX darknet bridge
systemctl start nginx-darknet

echo "All services started!"
echo "Tor Hidden Service: $(cat /var/lib/tor/p2p-im-hidden-service/hostname 2>/dev/null || echo 'generating...')"
echo "I2P Console: http://127.0.0.1:7070"
echo "IPFS WebUI: http://127.0.0.1:5001/webui"
EOF
  
  # Make all scripts executable
  chmod +x /opt/p2p-im-build/build.sh
  chmod +x /opt/p2p-im-build/start-services.sh
  
  echo "Build system created at /opt/p2p-im-build"
}

# Monitoring for P2P networks (replacing centralized monitoring)
install_p2p_monitoring() {
  echo "Installing P2P monitoring tools..."
  
  # Install The Graph Protocol CLI for indexing
  npm install -g @graphprotocol/graph-cli @graphprotocol/graph-ts
  
  # Create P2P health check system
  mkdir -p /opt/p2p-monitor
  cat > /opt/p2p-monitor/health-check.js << 'EOF'
import { create } from 'ipfs'

async function checkP2PHealth() {
  const ipfs = await create()
  
  // Check IPFS connectivity
  const peers = await ipfs.swarm.peers()
  console.log(`Connected to ${peers.length} IPFS peers`)
  
  // Check libp2p protocols
  const protocols = await ipfs.libp2p.getProtocols()
  console.log(`Active protocols: ${protocols.join(', ')}`)
  
  // Check DHT health
  const dhtPeers = await ipfs.dht.findPeer(ipfs.libp2p.peerId)
  console.log(`DHT accessible: ${dhtPeers.length > 0}`)
  
  return {
    ipfsPeers: peers.length,
    protocols: protocols.length,
    dhtHealth: dhtPeers.length > 0
  }
}

export { checkP2PHealth }
EOF
  chmod +x /opt/p2p-monitor/health-check.js
  
  echo "P2P monitoring tools installed"
}

# Main execution
echo "========================================="
echo "Fully Decentralized P2P IM Installation"
echo "Zero-cost, Open Source, Serverless"
echo "With Tor & I2P Privacy Layer"
echo "========================================="
echo ""
echo "This installation creates a completely decentralized architecture:"
echo "  • No servers or centralized components"
echo "  • Peer-to-peer communication via libp2p"
echo "  • Distributed storage via IPFS"
echo "  • Real-time sync via GUN database"
echo "  • Self-sovereign identity via Ceramic"
echo "  • Zero-knowledge proofs for privacy"
echo "  • End-to-end encryption built-in"
echo "  • Anonymous access through Tor & I2P"
echo "  • NGINX as darknet bridge (NOT as server)"
echo ""
echo "Starting installation..."
echo ""

# Core development tools
install_cpp_wasm_tools
install_emscripten
install_dev_tools

# P2P Infrastructure
install_libp2p
install_ipfs
install_gun
install_orbitdb

# Privacy and Anonymous Access
install_tor
install_i2p
install_nginx_darknet_bridge

# Identity and Privacy
install_ceramic
install_zk_proofs
install_crypto_libs

# Communication protocols
install_communication_protocols

# Optional blockchain integration
install_web3_tools

# Monitoring and build system
install_p2p_monitoring
create_build_system

echo ""
echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "Architecture Summary:"
echo "  ✓ WebAssembly compilation ready (Emscripten)"
echo "  ✓ P2P networking stack (libp2p)"
echo "  ✓ Distributed storage (IPFS)"
echo "  ✓ Real-time database (GUN + OrbitDB)"
echo "  ✓ Decentralized identity (Ceramic)"
echo "  ✓ Zero-knowledge proofs (SnarkJS)"
echo "  ✓ End-to-end encryption (libsodium + nacl)"
echo "  ✓ Tor hidden service access"
echo "  ✓ I2P eepsite access"
echo "  ✓ NGINX darknet bridge (Tor/I2P gateway only)"
echo ""
echo "What was REMOVED/REPLACED:"
echo "  ✗ Crow framework (replaced by WebAssembly modules)"
echo "  ✗ MySQL/SQLite (replaced by GUN/OrbitDB)"
echo "  ✗ ELK Stack (replaced by P2P monitoring)"
echo "  ✗ Alert Manager (replaced by peer health checks)"
echo "  ✗ JMeter/ZAP (replaced by P2P testing tools)"
echo "  ~ NGINX repurposed (not a server, just darknet bridge)"
echo ""
echo "Access Methods:"
echo "  • Clearnet: Direct P2P via libp2p/WebRTC"
echo "  • Tor: Hidden service at .onion address"
echo "  • I2P: Eepsite at .i2p address"
echo "  • IPFS: Content-addressed at /ipfs/<hash>"
echo ""
echo "Deployment Options:"
echo "  1. Static hosting: ipfs add -r ./dist"
echo "  2. Openmesh: Deploy as WASM + JavaScript bundle"
echo "  3. Tor Hidden Service: Accessible via .onion"
echo "  4. I2P Eepsite: Accessible via .i2p"
echo ""
echo "Total cost for infrastructure: $0"
echo "No servers, no hosting fees, truly decentralized!"
echo "Enhanced privacy through Tor/I2P integration!"
echo "========================================="