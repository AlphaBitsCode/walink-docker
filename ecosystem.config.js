module.exports = {
    apps: [{
        name: 'walink-gateway',
        script: './main.js',
        instances: 1,
        exec_mode: 'fork',
        autorestart: true,
        watch: false,
        max_memory_restart: '1G',
        env: {
            NODE_ENV: 'production',
            MQTT_ENABLE: true,
            MQTT_BROKER_URL: 'mqtt://170.64.147.8:7777',
            MQTT_USERNAME: 'skyeye',
            MQTT_PASSWORD: 'skyeyepacific2026',
            MQTT_CLIENT_ID: 'whatsapp-web-client',
            MQTT_INCOMING_TOPIC: 'wa/001/in',
            MQTT_OUTGOING_TOPIC: 'wa/001/out',
            DEVICE_NAME: '',
            BROWSER_NAME: '',
            PROXY_USERNAME: '',
            PROXY_PASSWORD: ''
        },
        error_file: './logs/pm2-error.log',
        out_file: './logs/pm2-out.log',
        log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
        merge_logs: true,
        kill_timeout: 5000,
        wait_ready: false,
        autostart: true
    }]
};
