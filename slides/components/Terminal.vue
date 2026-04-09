<template>
  <div class="terminal-container">
    <div class="user-selector">
      <label for="user-select">Utilisateur:</label>
      <select id="user-select" v-model="currentUser" @change="onUserChange">
        <option v-for="user in availableUsers" :key="user" :value="user">
          {{ user }}
        </option>
      </select>
    </div>
    <div class="terminal">
      <div class="terminal-output" ref="output">
        <div v-for="(line, index) in lines" :key="index">
          <TerminalContent v-if="line.type" :content="line.content" :content-type="line.type" />
          <span v-else v-html="line"></span>
        </div>
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
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useApi } from '../composables/useApi';
import TerminalContent from './TerminalContent.vue';

const { executeQuery, loading, error, response } = useApi();

const props = defineProps({
  height: {
    type: Number,
    default: 400
  },
  width: {
    type: String,
    default: '100%'
  },
  compact: {
    type: Boolean,
    default: false
  },
  user: {
    type: String,
    default: 'postgres'
  },
  password: {
    type: String,
    default: 'postgres'
  }
});


// État réactif
const lines = ref(['Bienvenue dans le terminal SQL. Tapez "help" pour voir les commandes disponibles.']);
const currentCommand = ref('');
const commandHistory = ref([]);
const historyIndex = ref(-1);
const currentUser = ref(props.user);
const currentPassword = ref(props.password);
const output = ref(null);
const input = ref(null);
const commandAvailableList = new Set(['help', 'user', 'pass', 'clear', 'users']);
const availableUsers = ref(['postgres', 'paul', 'pierre', 'jack']);

// Méthodes
const executeCommand = async () => {
  const command = currentCommand.value.trim();
  if (!command) return;

  lines.value.push(`<span class="prompt">$</span> ${command}`);
  
  // Ajouter à l'historique avant d'exécuter
  addToHistory(command);
  
  currentCommand.value = '';
  
  if (commandAvailableList.has(command)) {
    commandManager(command)
  } else {
    // Si ce n'est pas une commande spéciale, essayer de l'exécuter comme requête SQL
    await executeQuerySql(command)
  }
    await nextTick();
  if (output.value) {
    output.value.scrollTop = output.value.scrollHeight;
  }
};

const onUserChange = () => {
    lines.value.push(`<span class="system-message">Utilisateur changé pour: ${currentUser.value}</span>`);
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
        lines.value.push(`<span class="system-message">Utilisateur changé pour: ${currentUser.value}</span>`);
    }
    else if (command.startsWith('pass ')) {
        currentPassword.value = command.substring(5);
        lines.value.push('<span class="system-message">Mot de passe changé</span>');
    }
    else if (command === 'users') {
        showUsers()
    }
}

const showHelp = () => {
lines.value.push(
        'Commandes disponibles:',
        '- help: Affiche cette aide',
        '- user [utilisateur]: Change l\'utilisateur de connexion',
        '- pass [motdepasse]: Change le mot de passe',
        '- users: Affiche la liste des utilisateurs disponibles',
        '- clear: Efface le terminal',
        '- Flèches haut/bas: Navigue dans l\'historique des commandes'
    );
}

const showUsers = () => {
    lines.value.push(
        '<span class="system-message">Utilisateurs disponibles:</span>',
        '<span class="system-message">- paul</span>',
        '<span class="system-message">- pierre</span>',
        '<span class="system-message">- jack</span>'
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

const executeQuerySql = async (query) => {
    try {
      const result = await executeQuery(query, 'POST', {
        user: currentUser.value,
        password: currentPassword.value
      });
      
      if (result.success) {
        lines.value.push({ type: 'success', content: '✓ Requête exécutée avec succès'});
        
        if (result.rowCount !== undefined) {
          lines.value.push({ type: 'info', content: `Lignes affectées: ${result.rowCount}`});
        }
        
        if (result.results && result.results.length > 0) {
          const tableHtml = `<div class="result-table-wrapper">${formatResultsAsTable(result.results, result.fields)}</div>`;
          lines.value.push(tableHtml);
        }
      } else {
        lines.value.push({ type: 'error', content: '✗ Erreur: ' + result.error });
      }
    } catch (err) {
      lines.value.push({ type: 'error', content: '✗ Erreur: ' + (err.message || 'Erreur inconnue')});
    }
}

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
.terminal-container {
  display: flex;
  flex-direction: column;
  width: v-bind('`${width}%`');
}

.user-selector {
  background-color: #252525;
  color: #e0e0e0;
  padding: 8px 10px;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
  font-family: 'Courier New', monospace;
  font-size: v-bind('compact ? "10px" : "12px"');
}

.user-selector label {
  margin-right: 10px;
}

.user-selector select {
  background-color: #1e1e1e;
  color: #e0e0e0;
  border: 1px solid #444;
  border-radius: 3px;
  padding: 3px 5px;
  font-family: 'Courier New', monospace;
  font-size: v-bind('compact ? "10px" : "12px"');
  outline: none;
}

.terminal {
  background-color: #1e1e1e;
  color: #e0e0e0;
  font-family: 'Courier New', monospace;
  font-size: v-bind('compact ? "10px" : "12px"');
  height: v-bind('`${height}px`');
  width: 100%;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
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

.system-message {
  color: #4CAF50;
  font-style: italic;
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
  font-size: v-bind('compact ? "10px" : "12px"');
  outline: none;
}

.result-table {
  border-collapse: collapse;
  width: 100%;
  margin: 0;
  border: none;
  table-layout: fixed;
  font-size: 10px;
}

.result-table-wrapper {
  overflow: auto;
  max-width: 100%;
  margin: 8px 0;
  border: 1px solid #444;
  border-radius: 4px;
  max-height: 100%;
}

.result-table th,
.result-table td {
  padding: 4px 6px;
  border-bottom: 1px solid #333;
  border-right: 1px solid #222;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.result-table th {
  background-color: #2a2a2a;
  color: #bbb;
  position: sticky;
  top: 0;
  z-index: 10;
  font-weight: normal;
}

.result-table td {
  max-width: 150px;
  min-width: 50px;
  width: 1%;
}

.result-table tr:hover {
  background-color: #252525;
}

.result-table th:last-child,
.result-table td:last-child {
  border-right: none;
}

/* Style pour les lignes paires/impaires */
.result-table tr:nth-child(even) {
  background-color: #1a1a1a;
}

.result-table tr:nth-child(odd) {
  background-color: #1e1e1e;
}

.result-table tr:hover {
  background-color: #2a2a2a;
}
</style>