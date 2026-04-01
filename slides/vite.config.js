import { defineConfig } from 'vite'

export default defineConfig ({
    server: {
        host: '0.0.0.0',
        port: 3030,
        watch: {
            usePolling: true
        },
        hmr: {
            host: 'localhost',
            port: 3030
        }
    }
});