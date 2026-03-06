#!/bin/bash
# ============================================================
# Thunder Compute Setup Script
# Installs: Ollama + Dolphin3 + Open WebUI + OpenClaw
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

# 7. Install OpenClaw
echo ">>> Installing OpenClaw..."
curl -fsSL https://openclaw.ai/install.sh | bash

# 8. Copy OpenClaw config from GitHub repo
echo ">>> Restoring OpenClaw config..."
git clone https://brickface082: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@github.com/brickface082/openclaw-setup.git ~/openclaw-setup-repo
cp ~/openclaw-setup-repo/openclaw.json ~/.openclaw/openclaw.json

# 9. Set Dolphin3 as primary model
echo ">>> Setting Dolphin3 as primary model..."
openclaw config set agents.defaults.model.primary ollama/dolphin3

# 10. Start OpenClaw gateway in background
echo ">>> Starting OpenClaw gateway..."
openclaw gateway --port 18789 --allow-unconfigured &
sleep 3

echo ""
echo "============================================================"
echo "✓ Setup complete!"
echo "  Ollama API:     http://localhost:11434"
echo "  Telegram bot:   @MadChatterBot"
echo ""
echo "  Run this on your LOCAL Ubuntu to expose ports:"
echo "  tnr ports forward 0 --add 8080 --add 18789"
echo ""
echo "  Then open:"
echo "  Open WebUI:  https://0gvx00s1-8080.thundercompute.net"
echo "  OpenClaw:    https://0gvx00s1-18789.thundercompute.net"
echo "============================================================"
