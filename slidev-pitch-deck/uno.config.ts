import { defineConfig } from 'unocss'

export default defineConfig({
    theme: {
        extend: {
            colors: {
                sf: {
                    emerald: '#10b981',
                    'emerald-deep': '#059669',
                    'emerald-light': '#d1fae5',
                    'emerald-mist': '#ecfdf5',
                    blue: '#3b82f6',
                    'blue-deep': '#1d4ed8',
                    slate: '#0f172a',
                    'slate-mid': '#334155',
                    'slate-soft': '#64748b',
                    warm: '#fafaf9',
                    surface: '#ffffff',
                    danger: '#dc2626',
                    amber: '#f59e0b',
                    purple: '#7c3aed',
                },
            },
            fontFamily: {
                sans: 'Plus Jakarta Sans, ui-sans-serif, system-ui, sans-serif',
                serif: 'Playfair Display, ui-serif, Georgia, serif',
                mono: 'JetBrains Mono, ui-monospace, monospace',
            },
            borderRadius: {
                sf: '16px',
                'sf-sm': '10px',
            },
            boxShadow: {
                'sf-card': '0 1px 3px rgba(15, 23, 42, 0.04), 0 4px 12px rgba(15, 23, 42, 0.06)',
                'sf-elevated': '0 4px 6px rgba(15, 23, 42, 0.04), 0 12px 32px rgba(15, 23, 42, 0.08)',
                'sf-hero': '0 8px 24px rgba(16, 185, 129, 0.15), 0 24px 64px rgba(16, 185, 129, 0.08)',
            },
        },
    },
    shortcuts: {},
})
