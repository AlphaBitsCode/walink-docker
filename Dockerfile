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
RUN npm ci --omit=dev --legacy-peer-deps && npm cache clean --force

# Copy app source code
COPY . .

# Create a non-privileged user that the app will run under
RUN addgroup -g 1001 -S nodejs && \
    adduser -S whatsapp -u 1001 -G nodejs

# Change ownership of the app directory to the nodejs user
RUN chown -R whatsapp:nodejs /usr/src/app
USER whatsapp

# Expose port (if needed for web interface)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "node.*main.js" > /dev/null || exit 1

# Start the application
CMD ["node", "main.js"]
