# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Dockerized version of the WhatsApp Web.js library - a Node.js library that creates a WhatsApp API client by automating the WhatsApp Web browser application using Puppeteer. The library provides programmatic access to WhatsApp features through an unofficial API.

## Development Commands

### Testing
- Run all tests: `npm test` (uses Mocha with 5000ms timeout)
- Run single test: `npm run test-single` (basic Mocha execution)

### Code Quality
- ESLint configuration available: `.eslintrc.json`
- Linting rules: 4-space indentation, single quotes, semicolons required
- Code style: ES6+ with Node.js v18+ requirement

### Docker Operations
- Build Docker image: `docker build -t walink-docker .`
- Run container: `docker run -it --rm walink-docker`

## Architecture

### Core Components
- **Client** (`src/Client.js`): Main class extending EventEmitter, handles WhatsApp Web automation
- **Structures** (`src/structures/`): Data models for WhatsApp entities (Chat, Message, Contact, etc.)
- **Auth Strategies** (`src/authStrategies/`): Session management (LocalAuth, RemoteAuth, NoAuth)
- **Utilities** (`src/util/`): Helper classes including Puppeteer wrapper and constants

### Key Architecture Patterns
- Event-driven design using Node.js EventEmitter
- Puppeteer-based browser automation for WhatsApp Web interaction
- Factory pattern for creating WhatsApp entity objects
- Strategy pattern for authentication methods
- Session persistence for maintaining login state

### Docker Configuration
- Based on Node.js 22 Alpine image
- Includes Chromium for Puppeteer browser automation
- Uses non-privileged user for security
- Health check monitoring for application status

### Important Dependencies
- **puppeteer**: Browser automation (WhatsApp Web interaction)
- **mqtt**: Message queuing for real-time updates
- **qrcode**: QR code generation for authentication
- **fluent-ffmpeg**: Media processing for WhatsApp messages
- **node-webpmux**: WebP sticker handling

### Authentication Flow
1. Client initializes with selected auth strategy
2. QR code generated for phone scanning (or phone pairing)
3. Session data stored/retrieved based on auth strategy
4. Puppeteer browser connects to WhatsApp Web
5. Event listeners handle real-time message updates

### Key Constants
- WhatsApp Web version: `2.3000.1034282225`
- Default viewport: null (full browser size)
- User agent configured to mimic Chrome on macOS
- Authentication timeout and retry settings configurable

## File Structure
- `src/Client.js`: Main client implementation
- `src/structures/`: WhatsApp entity models
- `src/authStrategies/`: Authentication implementations
- `src/util/`: Utility classes and constants
- `src/webCache/`: Web caching implementations
- `index.js`: Main export file
- `Dockerfile`: Container configuration