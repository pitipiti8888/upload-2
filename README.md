{
  "name": "carimbo",
  "version": "1.0.0",
  "private": true,
  "engines": {
    "node": ">=22.2"
  },
  "scripts": {
    "start": "node server.js",
    "test": "node test/e2e.js",
    "test:ui": "python3 test/ui.py",
    "test:desktop": "node test/desktop.js && python3 test/ui-desktop.py && node test/electron-mock.js",
    "desktop": "electron .",
    "dist": "electron-builder --publish never"
  },
  "productName": "Carimbo",
  "description": "Marca d'água (chroma key) e vídeo de encerramento em lote, em 9:16",
  "main": "desktop/main.js",
  "dependencies": {
    "ffmpeg-static": "^5.2.0",
    "ffprobe-static": "^3.1.0"
  },
  "devDependencies": {
    "electron": "^37.0.0",
    "electron-builder": "^25.1.8"
  },
  "build": {
    "appId": "br.carimbo.app",
    "productName": "Carimbo",
    "directories": {
      "output": "dist",
      "buildResources": "build"
    },
    "files": [
      "server.js",
      "index.html",
      "desktop/**",
      "package.json"
    ],
    "asarUnpack": [
      "node_modules/ffmpeg-static/**",
      "node_modules/ffprobe-static/**"
    ],
    "win": {
      "target": [
        "nsis",
        "portable"
      ],
      "files": [
        "!node_modules/ffprobe-static/bin/darwin/**",
        "!node_modules/ffprobe-static/bin/linux/**",
        "!node_modules/ffprobe-static/bin/win32/ia32/**"
      ]
    },
    "nsis": {
      "oneClick": false,
      "allowToChangeInstallationDirectory": true,
      "artifactName": "Carimbo-Instalador-${version}.exe"
    },
    "portable": {
      "artifactName": "Carimbo-Portatil-${version}.exe"
    },
    "mac": {
      "target": "dmg",
      "category": "public.app-category.video",
      "files": [
        "!node_modules/ffprobe-static/bin/win32/**",
        "!node_modules/ffprobe-static/bin/linux/**"
      ]
    },
    "linux": {
      "target": "AppImage",
      "category": "Video",
      "files": [
        "!node_modules/ffprobe-static/bin/win32/**",
        "!node_modules/ffprobe-static/bin/darwin/**"
      ]
    }
  }
}