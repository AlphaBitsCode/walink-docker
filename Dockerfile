# Use official Node.js 22 Alpine image for smaller size
FROM node:22-alpine

# Install necessary packages for Chromium and Puppeteer
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Tell Puppeteer to skip installing Chromium. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install app dependencies
RUN npm install --legacy-peer-deps && npm cache clean --force

# Copy app source code
COPY . .

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Install su-exec for privilege dropping
RUN apk add --no-cache su-exec

# Create a non-privileged user that the app will run under
RUN addgroup -g 1001 -S nodejs && \
    adduser -S whatsapp -u 1001 -G nodejs

# Create auth and cache directories
RUN mkdir -p /usr/src/app/.wwebjs_auth /usr/src/app/.wwebjs_cache && \
    chown -R whatsapp:nodejs /usr/src/app/.wwebjs_auth /usr/src/app/.wwebjs_cache

# Change ownership of the app directory to the nodejs user
RUN chown -R whatsapp:nodejs /usr/src/app

# Expose port (if needed for web interface)
EXPOSE 3000

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "node.*main.js" > /dev/null || exit 1

# Start the application
CMD ["node", "main.js"]
