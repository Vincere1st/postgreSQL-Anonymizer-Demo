<script setup>
    const props = defineProps({
        content: String,
        contentType: { type: String }
    })
</script>
<template>
<span :class="contentType">{{ content }}</span>
</template>
<style scoped>
.success {
  color: #4CAF50;
}

.error {
  color: #F44336;
}

.info {
  color: #2196F3;
}
</style>