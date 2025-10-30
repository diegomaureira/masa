#!/usr/bin/env bash
set -euo pipefail

# =============================
# Configuration
# =============================
DATA_DIR="${DATA_DIR:-/media/disk/dm_test}"
masa_DIR="${masa_DIR:-/media/disk/masa}"
IMAGE_NAME="${IMAGE_NAME:-masa-image}"
CONTAINER_NAME="${CONTAINER_NAME:-masa-container}"
PIP_CACHE_DIR="${PIP_CACHE_DIR:-$HOME/.cache/pip}"

# =============================
# Pre-flight checks
# =============================
if [ ! -d "$DATA_DIR" ]; then
    echo "❌ ERROR: Data directory not found: $DATA_DIR"
    exit 1
fi

if [ ! -d "$masa_DIR" ]; then
    echo "❌ ERROR: masa directory not found: $masa_DIR"
    exit 1
fi

mkdir -p "$PIP_CACHE_DIR"

# =============================
# Startup info
# =============================
echo "🚀 Starting masa container..."
echo "   🧩 Image:       $IMAGE_NAME"
echo "   📦 Container:   $CONTAINER_NAME"
echo "   💻 Mount code:  $masa_DIR → /workspace/masa"
echo "   📂 Mount data:  $DATA_DIR → /workspace/masa/data"
echo "   🧰 Pip cache:   $PIP_CACHE_DIR → /root/.cache/pip"
echo ""

# =============================
# Container entry command
# =============================
SETUP_CMD=$(cat <<'EOF'
set -e
echo "🔍 Installing masa dependencies..."
sh install_dependencies.sh
cd /workspace/masa
echo ""
echo "✅ masa environment ready!"
exec bash
EOF
)

# =============================
# Run container
# =============================
docker run --gpus all \
    --name "$CONTAINER_NAME" \
    --rm \
    --shm-size=8g \
    -it \
    -v "${masa_DIR}:/workspace/masa" \
    -v "${DATA_DIR}:/workspace/masa/data" \
    -v "${PIP_CACHE_DIR}:/root/.cache/pip" \
    --network host \
    -e PYTHONPATH=/workspace/masa:${PYTHONPATH:-} \
    -w /workspace/masa \
    "$IMAGE_NAME" \
    bash #-c "$SETUP_CMD"
