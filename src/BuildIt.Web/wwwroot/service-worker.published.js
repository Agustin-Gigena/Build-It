// Service worker publicado: se inyecta en wwwroot/service-worker.js al publicar en Release.
// Blazor WASM lo genera automáticamente para cachear los assets estáticos y permitir PWA offline.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', () => self.clients.claim());
