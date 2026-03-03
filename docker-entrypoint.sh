#!/bin/sh

# Fix permissions for auth and cache directories if they exist
if [ -d "/usr/src/app/.wwebjs_auth" ]; then
    # Check if we can write to the directory, if not fix permissions
    if ! mkdir -p /usr/src/app/.wwebjs_auth/test 2>/dev/null; then
        # Running as root, fix ownership
        if [ "$(id -u)" = "0" ]; then
            chown -R whatsapp:nodejs /usr/src/app/.wwebjs_auth
            chmod -R 755 /usr/src/app/.wwebjs_auth
        fi
    else
        rmdir /usr/src/app/.wwebjs_auth/test 2>/dev/null
    fi
fi

if [ -d "/usr/src/app/.wwebjs_cache" ]; then
    if ! mkdir -p /usr/src/app/.wwebjs_cache/test 2>/dev/null; then
        if [ "$(id -u)" = "0" ]; then
            chown -R whatsapp:nodejs /usr/src/app/.wwebjs_cache
            chmod -R 755 /usr/src/app/.wwebjs_cache
        fi
    else
        rmdir /usr/src/app/.wwebjs_cache/test 2>/dev/null
    fi
fi

# Switch to whatsapp user if running as root
if [ "$(id -u)" = "0" ]; then
    exec su-exec whatsapp "$@"
else
    exec "$@"
fi
