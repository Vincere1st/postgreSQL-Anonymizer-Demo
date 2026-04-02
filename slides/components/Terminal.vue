<template>
  <div class="terminal">
    <div class="terminal-output" ref="output">
      <div v-for="(line, index) in lines" :key="index" v-html="line"></div>
    </div>
    <div class="terminal-input">
      <span class="prompt">$</span>
      <input 
        v-model="currentCommand" 
        @keyup.enter="executeCommand" 
        @keyup="handleKeyUp" 
        autofocus 
        ref="input"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useApi } from '../composables/useApi';

const { executeQuery, loading, error, response } = useApi();

// État réactif
const lines = ref(['Bienvenue dans le terminal SQL. Tapez "help" pour voir les commandes disponibles.']);
const currentCommand = ref('');
const commandHistory = ref([]);
const historyIndex = ref(-1);
const currentUser = ref('postgres');
const currentPassword = ref('postgres');
const output = ref(null);
const input = ref(null);
const commandAvailableList = ['help', 'user', 'pass', 'clear'];

// Méthodes
const executeCommand = async () => {
  const command = currentCommand.value.trim();
  if (!command) return;

  lines.value.push(`<span class="prompt">$</span> ${command}`);
  
  // Ajouter à l'historique avant d'exécuter
  addToHistory(command);
  
  currentCommand.value = '';
  
  if (commandAvailableList.includes(command)) {
    commandManager(command)
  } else {
    // Si ce n'est pas une commande spéciale, essayer de l'exécuter comme requête SQL
    try {
      const result = await executeQuery(command, 'POST', {
        user: currentUser.value,
        password: currentPassword.value
      });
      
      if (result.success) {
        lines.value.push('<span class="success">✓ Requête exécutée avec succès</span>');
        
        if (result.rowCount !== undefined) {
          lines.value.push(`<span class="info">Lignes affectées: ${result.rowCount}</span>`);
        }
        
        if (result.results && result.results.length > 0) {
          const tableHtml = formatResultsAsTable(result.results, result.fields);
          lines.value.push(tableHtml);
        }
      } else {
        lines.value.push('<span class="error">✗ Erreur: ' + result.error + '</span>');
      }
    } catch (err) {
      lines.value.push('<span class="error">✗ Erreur: ' + (err.message || 'Erreur inconnue') + '</span>');
    }
  }

  await nextTick();
  if (output.value) {
    output.value.scrollTop = output.value.scrollHeight;
  }
};

const commandManager = (command) => {
    if (command === 'help') {
        showHelp()
    }
    else if (command === 'clear') {
        lines.value = [];
    }
    else if (command.startsWith('user ')) {
        currentUser.value = command.substring(5);
        lines.value.push(`Utilisateur changé pour: ${currentUser.value}`);
    }
    else if (command.startsWith('pass ')) {
        currentPassword.value = command.substring(5);
        lines.value.push('Mot de passe changé');
    }
}

const showHelp = () => {
lines.value.push(
        'Commandes disponibles:',
        '- help: Affiche cette aide',
        '- user [utilisateur]: Change l\'utilisateur de connexion',
        '- pass [motdepasse]: Change le mot de passe',
        '- clear: Efface le terminal',
        '- Flèches haut/bas: Navigue dans l\'historique des commandes'
    );
}
const handleKeyUp = (event) => {
  // Navigation dans l'historique avec flèches haut/bas
  if (event.key === 'ArrowUp' && commandHistory.value.length > 0) {
    if (historyIndex.value === -1) {
      // Sauvegarder la commande actuelle avant de naviguer dans l'historique
      historyIndex.value = commandHistory.value.length;
    }
    if (historyIndex.value > 0) {
      historyIndex.value--;
      currentCommand.value = commandHistory.value[historyIndex.value];
    }
  } else if (event.key === 'ArrowDown') {
    if (historyIndex.value !== -1) {
      historyIndex.value++;
      if (historyIndex.value < commandHistory.value.length) {
        currentCommand.value = commandHistory.value[historyIndex.value];
      } else {
        // Retour à la commande initiale
        currentCommand.value = '';
        historyIndex.value = -1;
      }
    }
  }
};

const addToHistory = (command) => {
  if (command && command.trim() && 
      !['help', 'clear'].includes(command.trim()) &&
      commandHistory.value.indexOf(command) !== 0) {
    // Ajouter à l'historique seulement si ce n'est pas une commande système
    // et éviter les doublons consécutifs
    if (commandHistory.value.length === 0 || 
        commandHistory.value[commandHistory.value.length - 1] !== command) {
      commandHistory.value.push(command);
    }
    // Limiter la taille de l'historique
    if (commandHistory.value.length > 50) {
      commandHistory.value.shift();
    }
  }
};

const formatResultsAsTable = (results, fields) => {
  let html = '<table class="result-table">';
  
  // Header
  html += '<thead><tr>';
  if (fields && fields.length) {
    fields.forEach(field => {
      html += `<th>${field}</th>`;
    });
  } else if (results.length > 0) {
    Object.keys(results[0]).forEach(key => {
      html += `<th>${key}</th>`;
    });
  }
  html += '</tr></thead>';
  
  // Body
  html += '<tbody>';
  results.forEach(row => {
    html += '<tr>';
    Object.values(row).forEach(value => {
      html += `<td>${value}</td>`;
    });
    html += '</tr>';
  });
  html += '</tbody></table>';
  
  return html;
};

onMounted(() => {
  if (input.value) {
    input.value.focus();
  }
});
</script>

<style scoped>
.terminal {
  background-color: #1e1e1e;
  color: #e0e0e0;
  font-family: 'Courier New', monospace;
  height: 500px;
  width: 800px;
  border-radius: 5px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.terminal-output {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  user-select: text; /* Permet la sélection de texte */
  -webkit-user-select: text;
  -moz-user-select: text;
  -ms-user-select: text;
}

.terminal-input {
  display: flex;
  padding: 10px;
  background-color: #252525;
}

.prompt {
  margin-right: 10px;
  color: #4CAF50;
}

input {
  flex: 1;
  background: transparent;
  border: none;
  color: #e0e0e0;
  font-family: 'Courier New', monospace;
  outline: none;
}

.success {
  color: #4CAF50;
}

.error {
  color: #F44336;
}

.info {
  color: #2196F3;
}

.result-table {
  border-collapse: collapse;
  width: 100%;
  margin: 10px 0;
  border: 1px solid #444;
}

.result-table th {
  background-color: #333;
  color: #fff;
  padding: 8px;
  text-align: left;
  border-bottom: 1px solid #444;
}

.result-table td {
  padding: 8px;
  border-bottom: 1px solid #444;
}

.result-table tr:hover {
  background-color: #2a2a2a;
}
</style>