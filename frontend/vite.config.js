import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Vite configuration for the Bingo React front‑end.  This config loads the
// React plugin and leaves other settings at their defaults.  The front‑end
// files live under `src/` and will be served at the root when built.

export default defineConfig({
  plugins: [react()],
});
