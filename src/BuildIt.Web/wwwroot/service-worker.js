// Service worker de desarrollo: no cachea nada (se reemplaza por el published al compilar en Release).
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', () => self.clients.claim());
