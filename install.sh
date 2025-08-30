#!/bin/bash

# Courtesy to https://github.com/DMaroo/fakwin/issues/2

# Variables
SERVICE_NAME="fakwin.service"
SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_PATH="$SERVICE_DIR/$SERVICE_NAME"
EXECUTABLE="$HOME/.local/bin/fakwin"

# Build the binary
mkdir -p build
cd build
cmake ..
make
mkdir -p "$(dirname "$EXECUTABLE")"
mv fakwin "$EXECUTABLE"

# Ensure the service directory exists
mkdir -p "$SERVICE_DIR"

# Create the service file
cat << EOF > "$SERVICE_PATH"
[Unit]
Description=Run fakwin binary to fix shutdowns on custom WM plasma.

# For running before shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target poweroff.target

[Service]
ExecStart=$EXECUTABLE
Restart=always
Type=simple

[Install]
# run before shutdown
WantedBy=shutdown.target
EOF

# Reload systemd to recognize the new service
systemctl --user daemon-reload
# Enable the service to start on boot or before shutdown
systemctl --user enable "$SERVICE_NAME"
# Start the service immediately (optional)
systemctl --user start "$SERVICE_NAME"
