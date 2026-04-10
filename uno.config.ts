import { defineConfig } from 'unocss'

export default defineConfig({
  shortcuts: {
    // 'nom-de-la-classe': 'liste des utilitaires UnoCSS'
    'brand-title': 'text-5xl text-blue-600 font-bold tracking-tight',
    'brand-body': 'text-lg text-gray-700 leading-relaxed',
    'important-note': 'bg-yellow-100 text-yellow-900 px-2 py-1 rounded',
    'terminal-select': 'bg-gray-700 text-gray-200 border border-gray-600 rounded px-2 py-1 text-sm focus:outline-none',
    'terminal-input': 'flex-1 bg-transparent border-none text-gray-200 font-mono focus:outline-none'
  }
})