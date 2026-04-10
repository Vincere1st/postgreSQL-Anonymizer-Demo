<template>
  <div :class="['flex', 'flex-col', compact ? 'compact' : '']" style="width: 100%; max-width: 100%;">
    <div class="user-selector bg-gray-800 text-gray-200 px-2 py-1 rounded-t-md flex items-center gap-2 font-mono">
      <label for="user-select" class="cursor-pointer">Utilisateur:</label>
      <select 
        id="user-select" 
        v-model="currentUser" 
        @change="onUserChange" 
        class="bg-transparent text-gray-200 border-none outline-none appearance-none cursor-pointer w-full py-1"
      >
        <option v-for="availableUser in availableUsers" :key="availableUser" :value="availableUser.user">
          {{ availableUser.user }}
        </option>
      </select>
    </div>
    <div :class="['bg-gray-700', 'text-gray-200', 'font-mono', 'w-full', 'rounded-b-md', 'overflow-hidden', 'flex', 'flex-col']" :style="{ height: `${height}px`, width: '100%', 'max-width': '100%' }">
      <div class="flex-1 overflow-y-auto p-2 w-full" ref="output">
        <div v-for="(line, index) in lines" :key="index">
          <TerminalContent v-if="line.type === 'content'" :content="line.content" :content-type="line.contentType" />
          <TerminalTable v-else-if="line.type === 'table'" :results="line.results" :fields="line.fields" />
          <TerminalMessage v-else :type="line.type" :content="line.message" />
        </div>
      </div>
      <div class="terminal-input-container flex items-center p-2 bg-gray-800 font-mono">
        <span class="text-green-400 mr-2">$</span>
        <input 
          v-model="currentCommand" 
          @keyup.enter="executeCommand" 
          @keyup="handleKeyUp" 
          autofocus 
          ref="input"
          class="flex-1 bg-transparent border-none text-gray-200 font-mono outline-none cursor-text"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useApi } from '../composables/useApi';
import TerminalContent from './TerminalContent.vue';
import TerminalMessage from './TerminalMessage.vue';
import TerminalTable from './TerminalTable.vue';

const { executeQuery } = useApi();

const props = defineProps({
  height: {
    type: Number,
    default: 400
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
const lines = ref([
  { type: 'default', message: 'Bienvenue dans le terminal SQL.' },
  { type: 'info', message: 'Tapez "help" pour voir les commandes disponibles.' }
]);
const currentCommand = ref('');
const commandHistory = ref([]);
const historyIndex = ref(-1);
const currentUser = ref(props.user);
const currentPassword = ref(props.user === 'postgres' ? props.password : 'CHANGEME');
const output = ref(null);
const input = ref(null);
const commandAvailableList = new Set(['help', 'user', 'pass', 'clear', 'users']);
const availableUsers = ref([
  { user: 'postgres', password: 'postgres'},
  { user: 'paul', password: 'CHANGEME' },
  { user: 'pierre', password: 'CHANGEME' },
  { user: 'jack', password : 'CHANGEME'}]);



// Méthodes
const executeCommand = async () => {
  const command = currentCommand.value.trim();
  if (!command) return;

  lines.value.push({ type: 'default', message: `$ ${command}` });
  
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
    lines.value.push({ type: 'system', message: `Utilisateur changé pour: ${currentUser.value}` });
    availableUsers.value.forEach((availableUser) => {
      if (availableUser.user === currentUser.value) {
        currentPassword.value = availableUser.password
      }
    })
    console.log({password: currentPassword.value})
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
        lines.value.push({ type: 'system', message: 'Mot de passe changé' });
    }
    else if (command === 'users') {
        showUsers()
    }
}

const showHelp = () => {
lines.value.push(
        { type: 'success', message: 'Commandes disponibles:' },
        { type: 'info', message: '- help: Affiche cette aide' },
        { type: 'info', message: '- user [utilisateur]: Change l\'utilisateur de connexion' },
        { type: 'info', message: '- pass [motdepasse]: Change le mot de passe' },
        { type: 'info', message: '- users: Affiche la liste des utilisateurs disponibles' },
        { type: 'info', message: '- clear: Efface le terminal' },
        { type: 'info', message: '- Flèches haut/bas: Navigue dans l\'historique des commandes' }
    );
}

const showUsers = () => {
    lines.value.push(
        { type: 'success', message: 'Utilisateurs disponibles:' },
        { type: 'info', message: '- paul' },
        { type: 'info', message: '- pierre' },
        { type: 'info', message: '- jack' }
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
        lines.value.push({ type: 'success', message: '✓ Requête exécutée avec succès' });
        
        if (result.rowCount !== undefined) {
          lines.value.push({ type: 'info', message: `Lignes affectées: ${result.rowCount}` });
        }
        
        if (result.results && result.results.length > 0) {
          lines.value.push({ 
            type: 'table', 
            results: result.results, 
            fields: result.fields 
          });
        }
      } else {
        lines.value.push({ type: 'error', message: `✗ Erreur: ${result.error}` });
      }
    } catch (err) {
      lines.value.push({ type: 'error', message: `✗ Erreur: ${err.message || 'Erreur inconnue'}` });
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



onMounted(() => {
  if (input.value) {
    input.value.focus();
  }
});
</script>

<style scoped>
/* Styles pour le terminal qui nécessitent des bindings dynamiques */
.terminal-container {
  width: 100%;
}

.terminal {
  height: v-bind('`${height}px`');
}

/* Style pour le font-size dynamique basé sur le mode compact */
.compact .terminal, .compact input, .compact label, .compact select, .compact .terminal-message, .compact .terminal-table {
  font-size: 10px;
}

:not(.compact) .terminal, :not(.compact) input, :not(.compact) label, :not(.compact) select, :not(.compact) .terminal-message, :not(.compact) .terminal-table {
  font-size: 12px;
}

/* Style personnalisé pour le dropdown du select */
.user-selector select {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: transparent;
  padding-right: 1rem;
  cursor: pointer;
}

.user-selector select option {
  background-color: #252525;
  color: #e0e0e0;
}

/* Style pour la zone de saisie */
.terminal-input-container {
  display: flex;
  align-items: center;
  width: 100%;
}

.terminal-input-container input {
  flex: 1;
  cursor: text;
}
</style>