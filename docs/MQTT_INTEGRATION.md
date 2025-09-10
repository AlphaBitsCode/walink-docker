# MQTT Integration for WhatsApp Web.js

This WhatsApp Web.js application now includes MQTT integration to forward messages between WhatsApp and external systems.

## Features

- **Incoming Messages**: All WhatsApp messages are forwarded to MQTT topic
- **Outgoing Messages**: Messages from MQTT are sent via WhatsApp
- **Configurable**: All MQTT settings via environment variables
- **Optional**: Can be disabled by setting `MQTT_ENABLE=false`

## Configuration

Configure MQTT settings via environment variables (see `.env.example`):

```bash
MQTT_ENABLE=true
MQTT_BROKER_URL=mqtt://localhost:1883
MQTT_USERNAME=
MQTT_PASSWORD=
MQTT_CLIENT_ID=whatsapp-web-client
MQTT_INCOMING_TOPIC=whatsapp/incoming
MQTT_OUTGOING_TOPIC=whatsapp/outgoing
```

## Message Formats

### Incoming Messages (WhatsApp → MQTT)

Messages received on WhatsApp are published to `MQTT_INCOMING_TOPIC` with this JSON format:

```json
{
  "id": "message_id_here",
  "from": "1234567890@c.us",
  "to": "0987654321@c.us",
  "body": "Hello, this is a test message",
  "type": "chat",
  "timestamp": 1640995200,
  "fromMe": false,
  "hasMedia": false,
  "isGroup": false,
  "author": null,
  "deviceType": "android"
}
```

### Outgoing Messages (MQTT → WhatsApp)

To send messages via WhatsApp, publish to `MQTT_OUTGOING_TOPIC` with this JSON format:

```json
{
  "to": "1234567890@c.us",
  "body": "Hello from MQTT!",
  "options": {
    "linkPreview": false
  }
}
```

**Required fields:**
- `to`: WhatsApp ID (phone number with @c.us for individuals, @g.us for groups)
- `body`: Message text

**Optional fields:**
- `options`: WhatsApp message options (linkPreview, etc.)

## Docker Setup

The docker-compose.yml includes MQTT configuration. To use with an external MQTT broker:

1. Update `MQTT_BROKER_URL` in docker-compose.yml
2. Set credentials if required:
   ```yaml
   environment:
     MQTT_USERNAME: "your_username"
     MQTT_PASSWORD: "your_password"
   ```

## Testing with Local MQTT Broker

1. Install Mosquitto MQTT broker:
   ```bash
   # macOS
   brew install mosquitto
   brew services start mosquitto
   
   # Ubuntu/Debian
   sudo apt install mosquitto mosquitto-clients
   sudo systemctl start mosquitto
   ```

2. Update docker-compose.yml:
   ```yaml
   MQTT_BROKER_URL: "mqtt://host.docker.internal:1883"
   ```

3. Test incoming messages:
   ```bash
   mosquitto_sub -h localhost -t whatsapp/incoming
   ```

4. Test outgoing messages:
   ```bash
   mosquitto_pub -h localhost -t whatsapp/outgoing -m '{"to":"1234567890@c.us","body":"Test from MQTT"}'
   ```

## Troubleshooting

- **Connection refused**: Ensure MQTT broker is running and accessible
- **Authentication failed**: Check MQTT_USERNAME and MQTT_PASSWORD
- **Messages not sending**: Verify WhatsApp client is authenticated and ready
- **Invalid message format**: Ensure JSON is valid and includes required fields

## Logs

MQTT events are logged with `MQTT:` prefix:
- Connection status
- Message publishing/receiving
- Error messages

View logs with:
```bash
docker logs walink-docker -f
```