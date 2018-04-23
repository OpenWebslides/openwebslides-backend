#!/bin/bash
#
# docker-entrypoint.sh - Start server
#

# Correct permissions
chown -R openwebslides:openwebslides /app/

# Remove stale lock files
rm -f /app/tmp/pids/server.pid

# Run as regular user
su - openwebslides

# Migrate relational data
bundle exec rake db:migrate

# Override API_URL on runtime
erb /app/web/app/lib/api/api.js.erb > /app/web/dist/config.js

# Copy assets
[[ ! -d /app/public/ ]] && mkdir -p /app/public/
rm -rf /app/public/*
cp -r /app/web/dist/* /app/public/

# Clear temporary files
rm -rf /app/tmp/uploads/*

# Start app server
bundle exec puma
