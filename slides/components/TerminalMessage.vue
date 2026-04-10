<template>
  <div :class="messageClasses">
    <slot>{{ content }}</slot>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  type: {
    type: String,
    default: 'default',
    validator: (value) => ['default', 'success', 'error', 'info', 'system'].includes(value)
  },
  content: {
    type: String,
    default: ''
  }
});

const messageClasses = computed(() => {
  const baseClasses = 'font-mono';
  
  const typeClasses = {
    default: 'text-gray-200',
    success: 'text-green-400',
    error: 'text-red-400',
    info: 'text-blue-300',
    system: 'text-green-400 italic'
  };
  
  return `${baseClasses} ${typeClasses[props.type] || typeClasses.default}`;
});
</script>