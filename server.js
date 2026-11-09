# Carimbo

Marca d'água (chroma key) + vídeo de encerramento em lote. Saída: MP4 1080×1920 (9:16), H.264 yuv420p, AAC, CRF 18.

## Aplicativo de computador (recomendado): nada para instalar além dele
O aplicativo leva o FFmpeg dentro. Os vídeos são **usados de onde estão** no seu computador (nada é enviado, copiado ou alterado) e os finais são salvos numa pasta que você escolhe na primeira abertura (dá para trocar depois, na seção 5). Vídeos finais **nunca** são apagados automaticamente e o aplicativo **nunca** apaga os seus originais.

### Como obter o instalador sem instalar nada no seu computador (GitHub Actions, grátis)
1. Crie uma conta em github.com e um repositório novo (pode ser privado).
2. Envie todo o conteúdo desta pasta para o repositório (botão *Add file → Upload files*; inclua a pasta oculta `.github`).
3. Abra a aba **Actions → Construir aplicativo → Run workflow**.
4. Em cerca de 10 minutos, abra a execução e baixe o arquivo em **Artifacts**: `Carimbo-windows-latest` (instalador `.exe` e versão portátil), `Carimbo-macos-latest` (`.dmg`) ou `Carimbo-ubuntu-latest` (`.AppImage`).
5. O passo "Conferir o FFmpeg embutido" falha o build se o FFmpeg do pacote não tiver H.264/AAC/filtros necessários, para o instalador nunca sair quebrado.

Os instaladores **não são assinados**: o Windows mostra "O Windows protegeu o computador", e você clica em *Mais informações → Executar assim mesmo*. No Mac, clique com o botão direito no app e escolha *Abrir*.

### Para quem tem Node.js e quer gerar/rodar localmente
```
npm install
npm run desktop     # abre o aplicativo
npm run dist        # gera o instalador na pasta dist/ (do sistema em que você está)
```

### Testes do modo aplicativo
```
npm run test:desktop    # servidor em modo desktop, interface com ponte simulada, casca Electron simulada
```
A casca Electron (`desktop/main.js`, `desktop/preload.js`) é testada com uma API do Electron **simulada**; abrir o aplicativo de verdade só é possível com o Electron instalado.

## Versão servidor (navegador)

```
node server.js            # http://localhost:3000   (precisa de Node 22.2+ e FFmpeg 5+ com libx264)
node test/e2e.js          # teste de ponta a ponta pela API (servidor rodando; URL=http://host:porta)
python3 test/ui.py        # teste no navegador real (pip install playwright && playwright install chromium)
```

## Rodar no seu computador (grátis, sem limite de tamanho)
Para uso pessoal esta é a melhor opção: o envio é local (instantâneo), não há proxy nem limite de hospedagem, e a CPU do seu PC costuma codificar mais rápido que qualquer servidor grátis.
1. Instale o **Node.js LTS** (nodejs.org, versão 22 ou mais nova) e o **FFmpeg**.
   Windows: `winget install Gyan.FFmpeg` · Mac: `brew install ffmpeg` · Ubuntu/Debian: `sudo apt install ffmpeg`
2. Windows: dê dois cliques em `iniciar.bat`. Mac/Linux: `./iniciar.sh`. O navegador abre em http://localhost:3000.
3. Mantenha a janela do servidor aberta enquanto usa. Os arquivos ficam na pasta `data/` (mude com `DATA_DIR`).

## Por que não funciona na Netlify (nem em hospedagem só de arquivos)
A Netlify entrega arquivos estáticos e funções curtas. Suas funções aceitam no máximo 6 MB por requisição (256 KB nas funções de segundo plano), não têm disco permanente, não rodam FFmpeg e não mantêm processos ligados. Por isso a página abre, mas `/api/state` devolve 404 e aparece "Este endereço entrega a página, mas não é o servidor do Carimbo". O mesmo vale para GitHub Pages, Vercel e similares.
Para ficar online é preciso um servidor de verdade (VPS ou máquina própria) rodando `node server.js`. Opção gratuita: Oracle Cloud "Always Free" (exige cartão, disponibilidade de CPU Arm varia, 200 GB de disco no total; serve para arquivos de até algumas dezenas de GB, não para 50 GB+).

## Variáveis de ambiente
| Variável | Padrão | Função |
|---|---|---|
| `PORT` | 3000 | Porta |
| `DATA_DIR` | ./data | Uploads, resultados e fila. **Aponte para um disco grande.** |
| `CHUNK_MB` | 16 | Tamanho de cada parte do upload (o proxy precisa aceitar mais que isso) |
| `CONCURRENCY` | 1 | Vídeos processados ao mesmo tempo |
| `TTL_HOURS` | 72 | Prazo da limpeza automática (envios incompletos, originais e resultados) |
| `X264_CRF` / `X264_PRESET` | 18 / veryfast | Qualidade / velocidade (`slow` comprime melhor e demora mais) |

## Onde o limite de tamanho de arquivo pode estar (o código não impõe nenhum)
1. **Disco**: o servidor guarda uma cópia do original e o vídeo final. Planeje ≥ 2× o tamanho do lote. O servidor recusa o envio na hora se não houver espaço (`507`).
2. **Proxy**: `client_max_body_size` ≥ `CHUNK_MB` (veja `deploy/nginx.conf`). Cloudflare plano gratuito/Pro: 100 MB por requisição, então `CHUNK_MB` ≤ 90.
3. **Sistema de arquivos**: FAT32 limita a 4 GB por arquivo. Use ext4, xfs, NTFS ou exFAT.
4. **Hospedagem**: plataformas com disco efêmero ou limite de requisição pequeno (Vercel, Netlify, Heroku, planos gratuitos) não servem. Use VPS ou servidor com disco próprio.
5. **Armazenamento em nuvem (S3 etc.)** não está implementado: tudo usa o sistema de arquivos.
