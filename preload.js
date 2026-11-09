# Gera o instalador do Carimbo na nuvem do GitHub (grátis), sem instalar nada no seu computador.
# Como usar: aba "Actions" -> "Construir aplicativo" -> "Run workflow". Em ~10 min baixe o resultado em "Artifacts".
# NÃO testado (escrito sem acesso à rede/Windows); se um passo falhar, o log do GitHub mostra qual e por quê.
name: Construir aplicativo
on:
  workflow_dispatch:
  push:
    tags: ['v*']
jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os: [windows-latest, macos-latest, ubuntu-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
      - run: npm install
      - name: Conferir o FFmpeg embutido
        run: node desktop/check-ffmpeg.js
      - name: Construir
        run: npx electron-builder --publish never
        env:
          CSC_IDENTITY_AUTO_DISCOVERY: 'false'
      - uses: actions/upload-artifact@v4
        with:
          name: Carimbo-${{ matrix.os }}
          path: |
            dist/*.exe
            dist/*.dmg
            dist/*.AppImage
          if-no-files-found: error
