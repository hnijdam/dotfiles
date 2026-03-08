#!/usr/bin/env bash
set -e

echo "💡 Starting chezmoi bootstrap for Cosmic Atomic Fedora..."

# --- 1️⃣ Detect Atomic Fedora ---
if command -v rpm-ostree >/dev/null; then
    echo "✅ Atomic Fedora detected"

    # --- 2️⃣ Remove old containers if they exist ---
    for c in dev devtoolbox; do
        if toolbox list | grep -q "^$c"; then
            echo "🗑 Removing existing container: $c"
            sudo toolbox rm -f "$c"
        fi
    done

    # --- 3️⃣ Create dev container ---
    echo "🛠 Creating new dev container..."
    toolbox create dev || true

    # --- 4️⃣ Install development tools in container ---
    echo "📦 Installing development tools inside dev container..."
    toolbox run --container dev dnf group install -y "Development Tools"
    toolbox run --container dev dnf install -y \
        python3 \
        python3-pip \
        nodejs \
        npm \
        gcc \
        gcc-c++ \
        make \
        cmake \
        gdb \
        clang \
        clang-tools-extra \
        cppcheck \
        clang-format \
        clang-tidy \
        gyp \
        gyp-next \
        git \
        curl \
        wget

    echo "✅ Development container ready. Enter it with: toolbox enter dev"

else
    echo "⚠️ Classic Fedora detected, installing dev tools on host..."
    sudo dnf group install -y "Development Tools"
    sudo dnf install -y python3 python3-pip nodejs npm gcc clang cmake make gdb
fi

# --- 5️⃣ Apply chezmoi dotfiles ---
echo "📁 Applying chezmoi dotfiles..."
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:hnijdam/dotfiles.git

echo "🎉 Bootstrap complete!"
echo "Tip: Use 'toolbox enter dev' to enter your development environment."
