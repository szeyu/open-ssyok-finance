import { defineConfig } from 'unocss'

export default defineConfig({
    theme: {
        extend: {
            colors: {
                pitch: {
                    primary: '#10b981',
                    secondary: '#3b82f6',
                    accent: '#f59e0b',
                    success: '#10b981',
                    danger: '#ef4444',
                    warning: '#f59e0b',
                },
                brand: {
                    green: '#10b981',
                    blue: '#3b82f6',
                    amber: '#f59e0b',
                },
            },
            fontFamily: {
                sans: 'Inter, ui-sans-serif, system-ui, sans-serif',
                serif: 'Merriweather, ui-serif, Georgia, serif',
                mono: 'Fira Code, ui-monospace, monospace',
            },
        },
    },
    shortcuts: {
        // Button shortcuts
        'btn-primary': 'px-4 py-2 rounded-lg bg-green-500 text-white hover:bg-green-600 transition-colors',
        'btn-secondary': 'px-4 py-2 rounded-lg bg-blue-500 text-white hover:bg-blue-600 transition-colors',
        'btn-outline': 'px-4 py-2 rounded-lg border-2 border-green-500 text-green-500 hover:bg-green-50 dark:hover:bg-green-900/20 transition-colors',

        // Card shortcuts
        'card': 'p-6 rounded-xl bg-white dark:bg-gray-800 shadow-lg border border-gray-200 dark:border-gray-700',
        'card-hover': 'card transition-all hover:shadow-2xl hover:-translate-y-1',

        // Text shortcuts
        'heading-primary': 'text-4xl font-bold text-green-500',
        'heading-secondary': 'text-2xl font-semibold text-blue-500',
        'text-muted': 'text-gray-600 dark:text-gray-400',

        // Layout shortcuts
        'section': 'py-8 px-6',
        'container': 'max-w-6xl mx-auto',

        // Badge shortcuts
        'badge': 'px-3 py-1 rounded-full text-xs font-medium',
        'badge-success': 'badge bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100',
        'badge-warning': 'badge bg-yellow-100 text-yellow-800 dark:bg-yellow-800 dark:text-yellow-100',
        'badge-danger': 'badge bg-red-100 text-red-800 dark:bg-red-800 dark:text-red-100',

        // Gradient backgrounds
        'bg-gradient-success': 'bg-gradient-to-br from-green-500 to-green-600',
        'bg-gradient-primary': 'bg-gradient-to-br from-blue-500 to-blue-600',
        'bg-gradient-soft': 'bg-gradient-to-br from-green-50 to-blue-50 dark:from-green-900/20 dark:to-blue-900/20',
    },
})
