// Testa desktop/main.js e desktop/preload.js com uma API do Electron SIMULADA (não precisa do Electron instalado).
// Não substitui abrir o app de verdade, mas pega erros de lógica: porta, pasta de saída, segurança da janela, IPC, preload.
const { spawnSync, execFileSync } = require('child_process'), fs = require('fs'), os = require('os'), path = require('path'), Module = require('module');
const which = b => execFileSync('sh', ['-c', `command -v ${b}`]).toString().trim();

if (process.argv[2] === 'child') {           // --- processo filho: roda o main.js com o Electron falso e imprime o que aconteceu
  const [, , , userData, videos, chosen, mode] = process.argv, calls = { dialogs: [] }, ipc = {}, ev = {};
  const fake = {
    app: { requestSingleInstanceLock: () => true, quit() { calls.quit = 1; }, whenReady: async () => {}, getPath: n => ({ userData, videos })[n],
      on: (e, f) => { ev[e] = f; }, relaunch() { calls.relaunch = 1; }, exit(c) { calls.exit = c; } },
    BrowserWindow: class { constructor(o) { calls.win = o; this.webContents = { setWindowOpenHandler: f => { calls.openHandler = f(); }, on: (e, f) => { if (e === 'will-navigate') calls.nav = f; } }; }
      once(e, f) { if (e === 'ready-to-show') f(); } show() { calls.shown = 1; } loadURL(u) { calls.url = u; } isMinimized() { return false; } focus() {} restore() {} },
    dialog: { showOpenDialogSync: (...a) => { calls.dialogs.push(a.length); return chosen ? [calls.dialogs.length === 1 ? chosen : chosen + '_trocada'] : undefined; }, showMessageBoxSync: () => 0, showErrorBox: (...a) => { calls.error = a; } },
    ipcMain: { handle: (n, f) => { ipc[n] = f; } },
    shell: { openPath: p => { calls.open = p; }, showItemInFolder: p => { calls.reveal = (calls.reveal || []).concat(p); } },
  };
  const real = Module._load;
  Module._load = function (req, ...r) { if (req === 'electron') return fake; if (req === 'ffmpeg-static') return which('ffmpeg'); if (req === 'ffprobe-static') return { path: which('ffprobe') }; return real.call(this, req, ...r); };
  require('../desktop/main.js');
  (async () => {
    for (let i = 0; i < 100 && !calls.url; i++) await new Promise(r => setTimeout(r, 100));
    const dialogsAtStart = calls.dialogs.length;
    const out = { url: calls.url, dialogsAtStart, shown: calls.shown, win: calls.win && calls.win.webPreferences, dialogs: calls.dialogs, error: calls.error, env: { DESKTOP: process.env.DESKTOP, HOST: process.env.HOST, OUT_DIR: process.env.OUT_DIR, DATA_DIR: process.env.DATA_DIR, FFMPEG_PATH: process.env.FFMPEG_PATH } };
    if (calls.url) {
      out.state = await (await fetch(calls.url + '/api/state')).json();
      out.nav_blocked = (() => { let prevented = false; calls.nav({ preventDefault() { prevented = true; } }, 'https://site-de-fora.com'); return prevented; })();
      out.nav_inside = (() => { let prevented = false; calls.nav({ preventDefault() { prevented = true; } }, calls.url + '/x'); return prevented; })();
      out.popup = calls.openHandler;
      await ipc['open-out'](); await ipc['reveal']({}, '../segredo.txt'); await ipc['reveal']({}, 'video_final.mp4'); await ipc['reveal']({}, 'sub/pasta.mp4');
      out.open = calls.open; out.reveal = calls.reveal;
      if (mode === 'choose') { out.chose = await ipc['choose-out'](); out.relaunch = calls.relaunch; out.exit = calls.exit; }
    }
    console.log('@@' + JSON.stringify(out)); process.exit(0);
  })();
} else {                                      // --- processo pai: orquestra e confere
  const T = fs.mkdtempSync(path.join(os.tmpdir(), 'carimbo-el-')), U = path.join(T, 'userData'), V = path.join(T, 'Videos'), CH = path.join(T, 'escolhida'), CH2 = path.join(T, 'nova');
  [V, CH, CH2].forEach(d => fs.mkdirSync(d)); let fails = 0; const ok = (c, m, d = '') => { console.log(`  ${c ? '✔' : '✘'} ${m}${d ? '  (' + d + ')' : ''}`); if (!c) fails++; };
  const run = (...a) => { const r = spawnSync(process.execPath, [__filename, 'child', ...a], { encoding: 'utf8', timeout: 30000 }); const l = (r.stdout || '').split('\n').find(x => x.startsWith('@@')); if (!l) { console.log(r.stdout, r.stderr); return null; } return JSON.parse(l.slice(2)); };
  console.log('1) Primeira abertura: pergunta a pasta, sobe o servidor, abre a janela');
  const a = run(U, V, CH, 'choose'); if (!a) { console.log('  ✘ main.js não abriu a janela'); process.exit(1); }
  ok(a.dialogsAtStart === 1, 'perguntou a pasta dos vídeos finais uma vez', String(a.dialogsAtStart));
  ok(/^http:\/\/127\.0\.0\.1:\d+$/.test(a.url) && a.shown === 1, 'janela abre em 127.0.0.1 numa porta livre', a.url);
  ok(a.state && a.state.desktop === true && a.state.outDir === CH && a.state.health.ok, 'servidor interno em modo desktop, FFmpeg ok, usando a pasta escolhida', a.state && a.state.outDir);
  ok(a.env.HOST === '127.0.0.1' && a.env.DATA_DIR === U && a.env.OUT_DIR === CH && a.env.FFMPEG_PATH.includes('ffmpeg'), 'variáveis de ambiente do servidor corretas');
  ok(a.win.contextIsolation === true && a.win.nodeIntegration === false && a.win.sandbox === true && a.win.preload.endsWith('preload.js'), 'janela segura: sem Node, isolada, sandbox, com preload');
  ok(a.nav_blocked === true && a.nav_inside === false && a.popup.action === 'deny', 'janela não navega para sites de fora nem abre pop-ups');
  ok(a.open === CH, 'Abrir pasta abre a pasta dos vídeos finais');
  ok(JSON.stringify(a.reveal) === JSON.stringify([path.join(CH, 'video_final.mp4')]), 'Mostrar na pasta só aceita nome de arquivo (bloqueia ../ e subpastas)', JSON.stringify(a.reveal));
  ok(a.chose === true && a.relaunch === 1 && a.exit === 0, 'Trocar pasta reinicia o aplicativo');
  ok(JSON.parse(fs.readFileSync(path.join(U, 'config.json'), 'utf8')).outDir === CH + '_trocada', 'Trocar pasta grava a NOVA pasta na configuração', JSON.parse(fs.readFileSync(path.join(U, 'config.json'), 'utf8')).outDir);
  console.log('2) Segunda abertura: lembra da pasta e não pergunta de novo');
  fs.writeFileSync(path.join(U, 'config.json'), JSON.stringify({ outDir: CH }));
  const b = run(U, V, '', ''); ok(b && b.dialogsAtStart === 0 && b.state.outDir === CH, 'usa a pasta salva sem perguntar', b && JSON.stringify(b.dialogs));
  console.log('3) Pasta salva sumiu (HD externo desconectado, apagada…): pergunta de novo');
  fs.writeFileSync(path.join(T, 'arquivo.txt'), 'x'); fs.writeFileSync(path.join(U, 'config.json'), JSON.stringify({ outDir: path.join(T, 'arquivo.txt', 'pasta') })); // pasta salva ficou impossível de criar
  const c = run(U, V, CH2, ''); ok(c && c.dialogsAtStart === 1 && c.state.outDir === CH2, 'pergunta de novo e passa a usar a nova pasta', c && c.state && c.state.outDir);
  console.log('4) Preload (ponte segura)');
  const exposed = {}, invoked = []; const real = Module._load;
  Module._load = function (req, ...r) { if (req === 'electron') return { contextBridge: { exposeInMainWorld: (n, o) => { exposed[n] = o; } }, ipcRenderer: { invoke: (...a) => { invoked.push(a); return Promise.resolve(); } }, webUtils: { getPathForFile: f => { if (!f.name) throw new Error('x'); return '/caminho/' + f.name; } } }; return real.call(this, req, ...r); };
  require('../desktop/preload.js'); Module._load = real; const d = exposed.desktop;
  ok(Object.keys(d).sort().join() === 'chooseOutputDir,openOutputDir,pathOf,reveal', 'expõe só 4 funções (sem acesso ao disco nem ao Node)', Object.keys(d).join());
  ok(d.pathOf({ name: 'a.mp4' }) === '/caminho/a.mp4' && d.pathOf({ path: '/velho/b.mp4' }) === '/velho/b.mp4', 'pathOf usa webUtils e cai para File.path se preciso');
  d.openOutputDir(); d.reveal('x.mp4'); d.chooseOutputDir(); ok(JSON.stringify(invoked) === JSON.stringify([['open-out'], ['reveal', 'x.mp4'], ['choose-out']]), 'botões viram mensagens ao processo principal');
  console.log(fails ? `\n${fails} verificação(ões) FALHARAM` : '\nTUDO OK'); process.exit(fails ? 1 : 0);
}
