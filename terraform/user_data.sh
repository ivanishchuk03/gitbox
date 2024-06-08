#!/bin/bash

# Update the package index
sudo apt-get update -y

# Install Nginx
sudo apt-get install -y nginx

# Remove default Nginx configuration
sudo rm /etc/nginx/sites-enabled/default

# Start Nginx and enable it to start on boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Python3, pip, and virtualenv
sudo apt-get install -y python3 python3-pip python3-venv

# Create a directory for the Flask application
sudo mkdir -p /var/www/flaskapp
cd /var/www/flaskapp

# Create a virtual environment for the Flask application
python3 -m venv venv

# Activate the virtual environment and install Flask
source venv/bin/activate
pip install Flask

# Create a simple Flask application
cat <<EOF > /var/www/flaskapp/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello, World!"

if __name__ == '__main__':
    app.run(host='0.0.0.0')
EOF

# Configure Nginx to proxy requests to the Flask application
cat <<EOF > /etc/nginx/sites-available/flaskapp
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Remove existing symlink if it exists
sudo rm /etc/nginx/sites-enabled/flaskapp

# Enable the new Nginx configuration and restart Nginx
sudo ln -s /etc/nginx/sites-available/flaskapp /etc/nginx/sites-enabled
sudo systemctl restart nginx

# Create a systemd service for the Flask application
cat <<EOF > /etc/systemd/system/flaskapp.service
[Unit]
Description=Flask Application

[Service]
User=www-data
WorkingDirectory=/var/www/flaskapp
Environment="PATH=/var/www/flaskapp/venv/bin"
ExecStart=/var/www/flaskapp/venv/bin/python /var/www/flaskapp/app.py

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the Flask application service
sudo systemctl start flaskapp
sudo systemctl enable flaskapp
