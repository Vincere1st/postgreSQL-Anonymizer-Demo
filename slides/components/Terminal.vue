<template>
  <div class="terminal">
    <div class="terminal-output" ref="output">
      <div v-for="(line, index) in lines" :key="index" v-html="line"></div>
    </div>
    <div class="terminal-input">
      <span class="prompt">$</span>
      <input v-model="currentCommand" @keyup.enter="executeCommand" autofocus />
    </div>
  </div>
</template>

<script>
import { useApi } from '../composables/useApi';

export default {
  setup() {
    const { executeQuery, loading, error, response } = useApi();
    
    return {
      executeQuery,
      loading,
      error,
      response
    };
  },
  data() {
    return {
      lines: ['Bienvenue dans le terminal SQL. Tapez "help" pour voir les commandes disponibles.'],
      currentCommand: '',
      currentUser: 'postgres',
      currentPassword: 'postgres'
    };
  },
  methods: {
    async executeCommand() {
      const command = this.currentCommand.trim();
      if (!command) return;

      this.lines.push(`<span class="prompt">$</span> ${command}`);
      this.currentCommand = '';

      if (command === 'help') {
        this.lines.push('Commandes disponibles:');
        this.lines.push('- help: Affiche cette aide');
        this.lines.push('- sql [requête]: Exécute une requête SQL');
        this.lines.push('- user [utilisateur]: Change l\'utilisateur de connexion');
        this.lines.push('- pass [motdepasse]: Change le mot de passe');
      }
      else if (command === 'clear') {
        this.lines = [];
      }
      else if (command.startsWith('user ')) {
        this.currentUser = command.substring(5);
        this.lines.push(`Utilisateur changé pour: ${this.currentUser}`);
      }
      else if (command.startsWith('pass ')) {
        this.currentPassword = command.substring(5);
        this.lines.push('Mot de passe changé');
      }
      else if (command.startsWith('sql ')) {
        const sql = command.substring(4);
        try {
          const result = await this.executeQuery(sql, 'POST', {
            user: this.currentUser,
            password: this.currentPassword
          });
          
          if (result.success) {
            this.lines.push('<span class="success">✓ Requête exécutée avec succès</span>');
            
            if (result.rowCount !== undefined) {
              this.lines.push(`<span class="info">Lignes affectées: ${result.rowCount}</span>`);
            }
            
            if (result.results && result.results.length > 0) {
              // Afficher les résultats sous forme de tableau
              const tableHtml = this.formatResultsAsTable(result.results, result.fields);
              this.lines.push(tableHtml);
            }
          } else {
            this.lines.push('<span class="error">✗ Erreur: ' + result.error + '</span>');
          }
        } catch (err) {
          this.lines.push('<span class="error">✗ Erreur: ' + (err.message || 'Erreur inconnue') + '</span>');
        }
      }
      else {
        this.lines.push('<span class="error">Commande inconnue: ' + command + '</span>');
      }

      this.$nextTick(() => {
        this.$refs.output.scrollTop = this.$refs.output.scrollHeight;
      });
    },
    formatResultsAsTable(results, fields) {
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
    }
  }
};
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
</style>