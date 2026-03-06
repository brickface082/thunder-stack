#!/bin/bash
# ============================================================
# Thunder Compute Setup Script
# Installs: Ollama + Dolphin3 + Open WebUI
# Usage: bash thunder-setup.sh
# ============================================================

echo ">>> Starting Thunder Compute setup..."

# 1. Install Ollama
echo ">>> Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

# 2. Start Ollama in background with GPU
echo ">>> Starting Ollama with GPU..."
CUDA_VISIBLE_DEVICES=0 OLLAMA_KEEP_ALIVE=24h ollama serve &
sleep 5

# 3. Pull Dolphin3
echo ">>> Pulling Dolphin3 model..."
ollama pull dolphin3

# 4. Install pip if needed
echo ">>> Ensuring pip is available..."
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
rm get-pip.py

# 5. Install Open WebUI
echo ">>> Installing Open WebUI..."
pip install open-webui

# 6. Start Open WebUI in background
echo ">>> Starting Open WebUI..."
cd ~
open-webui serve &

# 7. Forward ports
echo ">>> Forwarding ports..."
tnr ports forward 0 --add 8080

echo ""
echo "============================================================"
echo "✓ Setup complete!"
echo "  Open WebUI: https://0gvx00s1-8080.thundercompute.net"
echo "  Ollama API: http://localhost:11434"
echo "============================================================"
