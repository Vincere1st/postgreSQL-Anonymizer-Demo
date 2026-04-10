<template>
  <div class="overflow-x-auto w-full my-2 border border-gray-600 rounded max-w-full">
    <table class="w-full border-collapse result-table">
      <thead>
        <tr class="bg-gray-600 text-gray-300">
          <th 
            v-for="(field, index) in fields" 
            :key="index" 
            class="border-b border-gray-500 text-left sticky top-0 bg-gray-600 font-size-4 col-term-padding"
          >
            {{ field }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr 
          v-for="(row, rowIndex) in results" 
          :key="rowIndex"
          :class="rowIndex % 2 === 0 ? 'bg-gray-700 hover:bg-gray-600' : 'bg-gray-800 hover:bg-gray-600'"
        >
          <td 
            v-for="(value, colIndex) in Object.values(row)" 
            :key="colIndex"
            class="border-b border-gray-600 font-size-4 col-term-padding"
            >
            {{ value }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
const props = defineProps({
  results: {
    type: Array,
    required: true
  },
  fields: {
    type: Array,
    required: true
  }
});
</script>
<style lang="css" scoped>
.col-term-padding {
  padding: 1px !important;
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