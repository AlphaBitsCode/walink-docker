<div align="center">
    <br />
    <p>
        <a href="https://alphabits.team?utm_source=github&utm_medium=1&utm_campaign=walink-docker"><img src="https://alphabits.team/logos/logo_header.png" title="Alpha Bits" alt="Alpha Bits Logo" width="300" /></a>
    </p>
    <br />
    <h1>🚀 WhatsApp Link - Docker Edition</h1>
    <p>
        <i>Enterprise-Grade WhatsApp API Gateway by <strong>Alpha Bits</strong></i><br />
        <i>Based on <a href="https://github.com/pedroslopez/whatsapp-web.js">whatsapp-web.js</a> v1.34.6</i>
    </p>
    <br />
    <p>
        <a href="https://hub.docker.com/r/Konductor-AI/walink-docker"><img src="https://img.shields.io/docker/v/Konductor-AI/walink-docker?sort=semver" alt="Docker Version"></a>
        <img src="https://img.shields.io/badge/WhatsApp_Web.js-v1.34.6-brightgreen.svg" alt="WhatsApp Web.js Version">
        <a href="https://github.com/Konductor-AI/walink-docker"><img src="https://img.shields.io/github/stars/Konductor-AI/walink-docker?style=social" alt="GitHub Stars"></a>
    </p>
    <br />
</div>

## 🎯 Quick Start for DevOps Engineers

### Docker Deployment
```bash
# Pull the image
docker pull alphabits/walink-docker:latest

# Run with default configuration
docker run -d \
  --name walink-gateway \
  -p 3000:3000 \
  alphabits/walink-docker:latest
```

### Local Development
```bash
npm install --legacy-peer-deps
cp .env.example .env   # Edit with your config
node main.js           # QR code will appear in terminal
```

### Environment Configuration
```bash
# Copy and edit the example env file
cp .env.example .env
```

| Variable | Description | Default |
|---|---|---|
| `DEVICE_NAME` | Custom name in WA linked devices | _(WA default)_ |
| `BROWSER_NAME` | Browser icon: Chrome, Firefox, Safari, Edge | _(gray icon)_ |
| `MQTT_ENABLE` | Enable MQTT bridge | `true` |
| `MQTT_BROKER_URL` | MQTT broker URL | `mqtt://localhost:1883` |
| `MQTT_USERNAME` | MQTT auth username | |
| `MQTT_PASSWORD` | MQTT auth password | |
| `MQTT_CLIENT_ID` | Unique MQTT client ID | `walink-client-12345` |
| `MQTT_INCOMING_TOPIC` | WA→MQTT messages | `walink/incoming` |
| `MQTT_OUTGOING_TOPIC` | MQTT→WA messages | `walink/outgoing` |

## 🔧 Node-RED Integration

### Dashboard Preview
![Node-RED Dashboard](docs/nodered-walink-dashboard.png)

### Flow Architecture
![Node-RED Flow](docs/nodered-walink-mqtt.png)

### Import Sample Flow
1. Open Node-RED Editor
2. Click **Menu → Import**
3. Copy the flow from `docs/sample-walink-flows.json`
4. Paste and click **Import**
5. Deploy the flow

## 📡 MQTT Message Protocol

### Incoming Messages (WhatsApp → MQTT)
**Topic:** `whatsapp/incoming`
```json
{
  "from": "1234567890@c.us",
  "body": "Hello World!",
  "type": "chat",
  "timestamp": 1634567890,
  "senderName": "John Doe"
}
```

### Outgoing Messages (MQTT → WhatsApp)
**Topic:** `whatsapp/outgoing`
```json
{
  "to": "1234567890@c.us",
  "body": "Hello from API!",
  "type": "chat"
}
```

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   WhatsApp Web  │    │   Walink Docker │    │    Node-RED     │
│                 │◄──►│                 │◄──►│                 │
│  (Browser API)  │    │   (MQTT Bridge)  │    │  (Dashboard)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                               │
                               ▼
                       ┌─────────────────┐
                       │   MQTT Broker   │
                       │                 │
                       │  (Message Bus)  │
                       └─────────────────┘
```

## 🚀 Production Deployment

### Docker Compose
```yaml
services:
  walink:
    image: kent000/whatsapp-mqtt:latest
    container_name: walink-docker-001
    deploy:
      resources:
        limits:
          memory: "1024m"
    environment:
      PUPPETEER_SKIP_CHROMIUM_DOWNLOAD: "true"
      PUPPETEER_EXECUTABLE_PATH: "/usr/bin/chromium-browser"
      MQTT_ENABLE: "true"
      MQTT_BROKER_URL: "mqtt://your-broker:1883"
      MQTT_USERNAME: "walink"
      MQTT_PASSWORD: "your-password"
      MQTT_CLIENT_ID: "walink-docker-001"
      MQTT_INCOMING_TOPIC: "wa/001/in"
      MQTT_OUTGOING_TOPIC: "wa/001/out"
    volumes:
      - ./data/auth:/usr/src/app/.wwebjs_auth
      - ./data/cache:/usr/src/app/.wwebjs_cache
    security_opt:
      - seccomp:unconfined
    shm_size: 2gb
    restart: unless-stopped
```

> **Note:** `shm_size: 2gb` and `seccomp:unconfined` are required for Chromium stability in Docker.

### Kubernetes Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: walink-gateway
spec:
  replicas: 2
  selector:
    matchLabels:
      app: walink
  template:
    metadata:
      labels:
        app: walink
    spec:
      containers:
      - name: walink
        image: alphabits/walink-docker:latest
        env:
        - name: MQTT_ENABLE
          value: "true"
        - name: MQTT_BROKER_URL
          value: "mqtt://mqtt-service:1883"
```

## 🔒 Security Best Practices

- **Session Management**: Persistent sessions stored in volumes
- **MQTT Authentication**: Username/password authentication
- **Network Isolation**: Docker networks for service communication
- **Health Checks**: Container health monitoring
- **Resource Limits**: CPU and memory constraints

## 📊 Monitoring & Logging

### Health Check Endpoint
```bash
curl http://localhost:3000/health
```

### Container Logs
```bash
docker logs walink-gateway -f
```

### MQTT Topics Monitoring
```bash
mosquitto_sub -t "whatsapp/+" -v
```

## 🤝 Contributing

We welcome contributions! Please see our [contribution guidelines](CONTRIBUTING.md).

## 📄 License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## 🏢 About Alpha Bits

[Alpha Bits](https://alphabits.team?utm_source=github&utm_medium=1&utm_campaign=walink-docker) is a leading provider of enterprise integration solutions, specializing in IoT automation, messaging platforms, and DevOps tools.

---

**Built for Devs by Devs 🧑🏻‍💻 [Alpha Bits](https://alphabits.team?utm_source=github&utm_medium=1&utm_campaign=walink-docker)**
