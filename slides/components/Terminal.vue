<script setup lang="ts">
    import { ref } from 'vue'

    const command = ref('')
    const terminalOutput = ref('')

    const executeCommand = async (command: string) => {
        try {
            const response = await fetch(`http://localhost:3001/query?sql=${encodeURIComponent(command)}&user=jack&password=CHANGEME`)
            const data = await response.json()
            terminalOutput.value = JSON.stringify(data, null, 2)
        } catch ( error) { 
            console.error('Error:', error)
        }
    }
</script>

<template>
    <div class="terminal">
        <div class="terminal-header">
            <div class="terminal-buttons">
                <span class="terminal-button terminal-button-close" />
                <span class="terminal-button terminal-button-minimize" />
                <span class="terminal-button terminal-button-maximize" />
            </div>
            <div class="terminal-title">Terminal</div>
        </div>
        <div class="terminal-body">
            <div class="terminal-input">
                <span class="terminal-prompt">$</span>
                <input type="text" v-model="command" @keyup.enter="executeCommand(command)" placeholder="Type a command and press Enter" />
            </div>
            <pre class="terminal-output">{{ terminalOutput }}</pre>
        </div>
    </div>
</template>