<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Carimbo — marca d’água e encerramento em lote</title>
<style>
:root{--bg:#13151b;--panel:#1a1d26;--line:#2b3040;--tx:#e9e7e2;--dim:#8e93a4;--acc:#f2b84b;--ok:#6fcf97;--err:#ef6b6b;color-scheme:dark}
*{box-sizing:border-box}
[hidden]{display:none!important}
body{margin:0;background:var(--bg);color:var(--tx);font:15px/1.5 "Avenir Next","Segoe UI",system-ui,sans-serif;font-variant-numeric:tabular-nums}
main{max-width:860px;margin:0 auto;padding:48px 20px 96px}
h1{font-size:42px;letter-spacing:-.025em;margin:0 0 6px;font-weight:700}
.lead{color:var(--dim);margin:0 0 26px;max-width:58ch}
.tl{display:flex;gap:3px;height:58px;margin-bottom:38px}
.tl div{position:relative;display:flex;align-items:center;padding:0 16px;font-size:13px;color:var(--dim);background:var(--panel);border:1px solid var(--line);border-radius:6px}
.tl .a{flex:5}.tl .b{flex:1.5;border-style:dashed}
.tl .a i{position:absolute;left:8px;bottom:7px;width:26px;height:10px;border-radius:2px;background:var(--acc)}
section{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:20px 22px;margin-bottom:18px}
h2{display:flex;align-items:baseline;gap:12px;font-size:18px;font-weight:600;margin:0 0 14px}
h2 b{color:var(--acc);font-weight:600}
h2 small{margin-left:auto;font-size:13px;font-weight:400;color:var(--dim)}
.drop{position:relative;display:block;border:1.5px dashed var(--line);border-radius:8px;padding:26px 16px;text-align:center;color:var(--dim);cursor:pointer;transition:border-color .15s,background .15s}
.drop:hover,.drop.on{border-color:var(--acc);background:rgba(242,184,75,.05);color:var(--tx)}
.drop:focus-within{outline:2px solid var(--tx);outline-offset:3px}
.drop u{color:var(--acc)}
.drop input{position:absolute;opacity:0;width:1px;height:1px}
.row{display:grid;grid-template-columns:1fr auto auto auto;gap:4px 14px;align-items:center;padding:10px 0;border-top:1px solid var(--line)}
.row:first-of-type{margin-top:14px}
.n{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.s{color:var(--dim);font-size:13px;white-space:nowrap}
.bar{grid-column:1/-1;height:4px;background:var(--line);border-radius:2px;overflow:hidden}
.bar i{display:block;height:100%;background:var(--acc);transition:width .3s}
.ok{color:var(--ok)}.er{color:var(--err)}
.x{background:none;border:0;color:var(--dim);cursor:pointer;font-size:13px;padding:2px 6px;border-radius:4px}
.x:hover,.x:focus-visible{color:var(--tx);outline:1px solid var(--line)}
.go{width:100%;padding:22px;font-family:inherit;font-weight:700;font-size:18px;line-height:1;letter-spacing:.08em;border:0;border-radius:8px;background:var(--acc);color:#1b1608;cursor:pointer}
.go:disabled{background:var(--line);color:var(--dim);cursor:not-allowed}
.go:focus-visible{outline:2px solid var(--tx);outline-offset:3px}
.hint{min-height:22px;margin:10px 0 0;color:var(--dim);font-size:13px}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin:20px 0 14px}
.stats div{font-size:13px;color:var(--dim)}
.stats b{display:block;font-size:28px;font-weight:600;color:var(--tx)}
.total{height:8px;background:var(--line);border-radius:4px;overflow:hidden}
.total i{display:block;height:100%;background:var(--acc);transition:width .3s}
a.btn{display:inline-block;color:var(--acc);text-decoration:none;font-size:13px;border:1px solid var(--line);border-radius:6px;padding:3px 12px}
a.btn:hover,a.btn:focus-visible{border-color:var(--acc)}
a.zip{background:var(--acc);color:#1b1608;font-weight:600;font-size:14px;padding:9px 18px;border-color:var(--acc)}
.empty{color:var(--dim);margin:14px 0 0;font-size:14px}
.banner{background:rgba(239,107,107,.1);border:1px solid var(--err);color:var(--tx);border-radius:8px;padding:12px 16px;margin:0 0 18px;font-size:14px}
.msg{margin:10px 0 0;font-size:14px}.msg.er{color:var(--err)}.msg.ok{color:var(--ok)}
.em{grid-column:1/-1;color:var(--err);font-size:13px;line-height:1.45}
.note{color:var(--dim);font-size:12.5px;margin:8px 0 0;line-height:1.45}
.studio{display:grid;grid-template-columns:minmax(200px,260px) 1fr;gap:28px;margin-top:22px}
.phone{position:relative;aspect-ratio:9/16;width:100%;max-width:260px;border:1px solid var(--line);border-radius:14px;overflow:hidden;background:#0e1016}
.phone img{width:100%;height:100%;object-fit:cover;display:block;transition:opacity .15s}
.phone.busy img{opacity:.55}
.phone img:not([src]){visibility:hidden}
.pvmsg{position:absolute;inset:0;margin:0;display:flex;align-items:center;justify-content:center;text-align:center;padding:18px;color:var(--dim);font-size:13px}
.seg{display:inline-flex;margin-top:10px;border:1px solid var(--line);border-radius:8px;overflow:hidden}
.seg button{background:none;border:0;color:var(--dim);padding:6px 14px;font:inherit;font-size:13px;cursor:pointer}
.seg button[aria-pressed=true]{background:var(--line);color:var(--tx)}
.seg button:focus-visible{outline:2px solid var(--tx);outline-offset:-2px}
#eye{display:block;width:100%;max-width:260px;margin-top:16px;border:1px solid var(--line);border-radius:8px;cursor:crosshair;background:repeating-conic-gradient(#2a2e3a 0 25%,#222633 0 50%) 0 0/14px 14px}
.ctl h3{font-size:14px;font-weight:600;margin:0 0 8px}.ctl h3:not(:first-child){margin-top:24px}
.color{display:flex;align-items:center;gap:12px;margin-bottom:6px;font-size:13px;color:var(--dim)}
.color code{color:var(--tx);font:inherit;font-size:13px}
input[type=color]{width:46px;height:30px;border:1px solid var(--line);background:none;border-radius:6px;padding:2px;cursor:pointer}
.sl{display:grid;grid-template-columns:132px 1fr auto;gap:12px;align-items:center;margin:9px 0;font-size:13px;color:var(--dim)}
.sl input[type=range]{width:100%;accent-color:var(--acc)}
.nv{display:inline-flex;align-items:baseline;gap:4px;min-width:84px;justify-content:flex-end}.nv i{font-style:normal;width:20px}
.nv input{width:58px;background:var(--bg);color:var(--tx);border:1px solid var(--line);border-radius:6px;padding:4px 6px;font:inherit;font-size:13px;text-align:right}
.nv input:focus-visible,.sl input[type=range]:focus-visible,input[type=color]:focus-visible{outline:2px solid var(--tx);outline-offset:2px}
@media(max-width:700px){.studio{grid-template-columns:1fr}.sl{grid-template-columns:1fr auto}.sl label{grid-column:1/-1}}
@media(max-width:560px){.stats{grid-template-columns:repeat(2,1fr)}h1{font-size:34px}.row{grid-template-columns:1fr auto}}
@media(prefers-reduced-motion:reduce){*{transition:none!important}}
</style>
</head>
<body>
<main>
  <h1>Carimbo</h1>
  <p class="lead">Envie os vídeos, a marca d’água e o encerramento. O servidor aplica tudo em cada vídeo, um a um, e entrega arquivos MP4 em 1080 × 1920 (9:16).</p>
  <div class="banner" id="banner" role="alert" hidden></div>
  <div class="tl" aria-hidden="true"><div class="a">vídeo original<i></i></div><div class="b">encerramento</div></div>

  <section>
    <h2><b>1</b> Vídeos originais <small id="c1"></small></h2>
    <label class="drop" id="d1"><input type="file" multiple accept="video/*,.mkv,.mov,.mp4,.avi,.webm">Arraste os vídeos aqui ou <u>escolha os arquivos</u></label>
    <div id="l1"></div>
    <p class="note" id="free"></p>
  </section>

  <section>
    <h2><b>2</b> Marca d’água <small id="c2"></small></h2>
    <label class="drop" id="d2"><input type="file" accept="image/*,video/*">Arraste a imagem ou o vídeo com fundo verde ou <u>escolha o arquivo</u></label>
    <div id="l2"></div>
    <div class="studio">
      <div class="stage">
        <div class="phone"><img id="pv" alt="Prévia 9:16 da marca d’água sobre o vídeo"><p class="pvmsg" id="pvmsg">Envie a marca d’água para ver a prévia.</p></div>
        <div class="seg" role="group" aria-label="Fundo da prévia"><button type="button" data-bg="video" aria-pressed="true">Vídeo</button><button type="button" data-bg="checker" aria-pressed="false">Xadrez</button></div>
        <canvas id="eye" hidden title="Clique no fundo verde para escolher a cor"></canvas>
        <p class="note" id="eyenote" hidden>Marca original: clique no fundo que deve sumir (conta-gotas).</p>
      </div>
      <div class="ctl">
        <h3>Chroma key</h3>
        <div class="color"><input id="color" type="color" aria-label="Cor do fundo a remover"><span>Cor do fundo <code id="hex"></code></span></div>
        <div id="g1"></div>
        <p class="note">Cor, intensidade e sombra seguem o CapCut; bordas e suavização são extras. As escalas de 0 a 100 são de referência e não equivalem aos números do aplicativo.</p>
        <h3>Marca d’água</h3>
        <div id="g2"></div>
        <p class="note">Posição: 0% = esquerda/topo, 100% = direita/base. Padrão: canto inferior esquerdo (horizontal 0, vertical 100). A prévia usa o mesmo filtro do processamento final.</p>
      </div>
    </div>
  </section>

  <section>
    <h2><b>3</b> Vídeo de encerramento <small id="c3"></small></h2>
    <label class="drop" id="d3"><input type="file" accept="video/*,.mkv,.mov,.mp4,.avi,.webm">Arraste o vídeo de encerramento aqui ou <u>escolha o arquivo</u></label>
    <div id="l3"></div>
  </section>

  <section>
    <h2><b>4</b> Processamento</h2>
    <button class="go" id="go" disabled>INICIAR PROCESSAMENTO</button>
    <p class="hint" id="hint" role="status"></p>
    <p class="msg" id="msg" role="alert"></p>
    <div class="stats">
      <div><b id="s-q">0</b>Na fila</div><div><b id="s-p">0</b>Em processamento</div>
      <div><b id="s-d">0</b>Concluídos</div><div><b id="s-e">0</b>Com erro</div>
    </div>
    <div class="total"><i id="tot" style="width:0"></i></div>
    <div id="l4"></div>
  </section>

  <section>
    <h2><b>5</b> Resultados <small id="c5"></small></h2>
    <div id="l5"><p class="empty">Os vídeos finalizados aparecem aqui.</p></div>
  </section>
</main>
<script>
const DESK = window.desktop; // só existe dentro do aplicativo de desktop (ponte criada pelo Electron)
const $ = s => document.querySelector(s), sleep = ms => new Promise(r => setTimeout(r, ms));
const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const fmt = n => n >= 2 ** 40 ? (n / 2 ** 40).toFixed(2) + ' TB' : n >= 2 ** 30 ? (n / 2 ** 30).toFixed(2) + ' GB' : n >= 2 ** 20 ? (n / 2 ** 20).toFixed(1) + ' MB' : Math.ceil(n / 1024) + ' KB';
let ST = { files: [], jobs: [], config: {}, health: { ok: true, problems: [] } }, UP = [], busy = false, cfgInit = false, seq = 0, CHUNK = 16 * 2 ** 20, offline = false;
const CFG = { color: '#00ff00', intensity: 60, shadow: 0, edge: 30, smooth: 30, wpx: 300, x: 0, y: 100, opacity: 100 }, BG = { v: 'video' };
// explica POR QUE não há conexão e o que fazer
function offMsg() {
  if (location.protocol === 'file:') return 'Você abriu o index.html direto do disco, e assim ele não tem servidor. Rode "node server.js" numa janela de terminal e abra http://localhost:3000 no navegador.';
  if (offline.stale) return 'O servidor que está rodando é de uma versão antiga. Feche-o (Ctrl+C no terminal dele), rode "node server.js" de novo com os arquivos novos e recarregue a página (Ctrl+F5).';
  if (offline.wrong && [502, 503, 504].includes(offline.status)) return `O proxy está no ar (HTTP ${offline.status}), mas o servidor Node por trás dele não respondeu. Rode "node server.js" (ou "pm2 restart carimbo") e confira se a porta do proxy é a mesma do servidor. Tentando reconectar…`;
  if (offline.wrong) return `Este endereço (${location.origin}) entrega a página, mas não é o servidor do Carimbo: ${offline.message} Servidores que só entregam arquivos (Live Server, Netlify, GitHub Pages, "python -m http.server") não funcionam. Rode "node server.js" e abra http://localhost:3000.`;
  if (offline.net) return `Não consigo falar com o servidor em ${location.origin}. Causas mais comuns: o terminal onde rodava "node server.js" foi fechado (abra-o e rode de novo), o endereço ou a porta mudou, ou o proxy está fora do ar. Tentando reconectar…`;
  return `${offline.message} Se estiver atrás de proxy, confira se o servidor Node está de pé. Tentando reconectar…`;
}
const say = (t, k = 'er') => { const m = $('#msg'); m.textContent = t || ''; m.className = 'msg ' + (t ? k : ''); };

async function api(m, u, b) {
  let r; try { r = await fetch(u, { method: m, headers: { 'X-Carimbo': '1', ...(b ? { 'Content-Type': 'application/json' } : {}) }, body: b ? JSON.stringify(b) : undefined }); }
  catch { throw Object.assign(new Error('Sem conexão com o servidor.'), { net: true }); }
  const ct = r.headers.get('content-type') || '';
  if (!ct.includes('json')) throw Object.assign(new Error(`${u} respondeu HTTP ${r.status} (${ct || 'sem tipo'}), que não é do servidor do Carimbo.`), { wrong: true, status: r.status });
  const j = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(j.error || `O servidor respondeu HTTP ${r.status}.`);
  return j;
}

// ----- upload em partes, retomável: o servidor informa o tamanho da parte e até onde recebeu -----
function add(role, files) {
  for (const f of files) { if (role !== 'video') UP = UP.filter(u => u.role !== role); UP.push({ id: ++seq, role, file: f, pct: 0, st: 'wait' }); }
  render(); run();
}
async function run() {
  if (busy) return; busy = true;
  for (let u; (u = UP.find(x => x.st === 'wait'));) {
    u.st = 'up'; render();
    try { await send(u); UP = UP.filter(x => x !== u); await poll(); } catch (e) { u.st = 'err'; u.err = e.message; }
    render();
  }
  busy = false;
}
async function httpErr(r, n) { // explica a causa e como resolver
  if (!r) return 'Sem conexão com o servidor. Verifique a internet e se o servidor está no ar, depois clique em Retomar: o envio continua de onde parou.';
  let m; try { m = (await r.json()).error; } catch {}
  if (m) return m;
  const mb = Math.ceil(n / 2 ** 20);
  if (r.status === 413) return `O proxy ou servidor recusou uma parte de ${mb} MB (HTTP 413). No nginx, aumente client_max_body_size para pelo menos ${mb * 2}m, ou reduza CHUNK_MB no servidor. Depois clique em Retomar.`;
  if ([502, 503, 504].includes(r.status)) return `O proxy não conseguiu falar com o servidor (HTTP ${r.status}). Confira se o servidor está rodando e aumente proxy_read_timeout. Depois clique em Retomar.`;
  return `O servidor respondeu HTTP ${r.status}. Clique em Retomar para tentar de novo.`;
}
async function send(u) {
  if (DESK) { await api('POST', '/api/register', { role: u.role, path: DESK.pathOf(u.file) }); return; } // aplicativo: usa o arquivo onde ele está, sem enviar nem copiar
  const f = u.file, b = { role: u.role, name: f.name, size: f.size, key: `${f.name}|${f.size}|${f.lastModified}` };
  const i = await api('POST', '/api/uploads', b); if (i.done) return;
  CHUNK = i.chunk || CHUNK; let off = i.offset;
  while (off < f.size) {
    const end = Math.min(off + CHUNK, f.size);
    for (let t = 0; ; t++) {
      let r = null;
      try { r = await fetch(`/api/uploads/${i.id}?offset=${off}`, { method: 'PUT', headers: { 'X-Carimbo': '1' }, body: f.slice(off, end) }); } catch {}
      if (r && r.status === 409) { off = (await r.json()).offset; break; }  // servidor está noutro ponto: retoma dali
      if (r && r.ok) { off = end; break; }
      const transient = !r || r.status >= 500 || r.status === 408 || r.status === 429;
      if (!transient || t >= 7) throw new Error(await httpErr(r, end - off)); // erro de configuração aparece na hora; só falha de rede tenta de novo
      u.note = `Reconectando… tentativa ${t + 1} de 8`; render(); await sleep(Math.min(1000 * 2 ** t, 10000)); u.note = '';
    }
    u.pct = off / f.size; render();
  }
  await api('POST', `/api/uploads/${i.id}/complete`, b);
}
const retry = id => { const u = UP.find(x => x.id === id); if (u) { u.st = 'wait'; u.err = ''; run(); } };
const drop = id => { UP = UP.filter(x => x.id !== id); render(); };
async function del(id) { try { await api('DELETE', '/api/files/' + id); say(''); } catch (e) { say(e.message); } poll(); }

// ----- renderização -----
const row = (n, s, st, pct, x, em) => `<div class="row"><span class="n" title="${esc(n)}">${esc(n)}</span><span class="s">${s}</span><span class="s">${st}</span>${x || '<span></span>'}${em ? `<div class="em">${esc(em)}</div>` : ''}${pct == null ? '' : `<div class="bar"><i style="width:${(pct * 100).toFixed(1)}%"></i></div>`}</div>`;
const upRow = u => u.st === 'err'
  ? row(u.file.name, fmt(u.file.size), '<span class="er">Falhou</span>', null, `<span><button class="x" onclick="retry(${u.id})">Retomar</button><button class="x" onclick="drop(${u.id})">✕</button></span>`, u.err)
  : row(u.file.name, fmt(u.file.size), u.note ? `<span class="er">${u.note}</span>` : u.st === 'wait' ? 'Aguardando' : DESK ? 'Lendo arquivo…' : `Enviando ${Math.round(u.pct * 100)}%`, u.pct);
const fileRow = f => row(f.name, fmt(f.size), `<span class="ok">${DESK ? 'Adicionado' : 'Enviado'}</span>`, null, `<button class="x" onclick="del('${f.id}')" aria-label="Remover ${esc(f.name)}">✕</button>`);
const pend = () => ST.files.filter(f => f.role === 'video' && !ST.jobs.some(j => j.fileId === f.id && j.status !== 'error')); // erro conta como pendente: dá para tentar de novo

function render() {
  const vids = ST.files.filter(f => f.role === 'video'), wm = ST.files.find(f => f.role === 'watermark'), ou = ST.files.find(f => f.role === 'outro');
  const ups = r => UP.filter(u => u.role === r);
  const bn = $('#banner'); bn.hidden = !(offline || pageErr || !ST.health.ok);
  bn.textContent = offline ? offMsg() : pageErr ? `Erro na página (não é falha de conexão): ${pageErr}. Recarregue com Ctrl+F5; se continuar, copie esta mensagem e envie ao suporte.` : ST.health.problems.join(' ');
  const isD = !!(DESK && ST.desktop);
  $('#free').textContent = isD ? 'Os vídeos são usados direto de onde estão no seu computador: nada é copiado nem alterado.' : typeof ST.free === 'number' ? `Espaço livre no servidor: ${fmt(ST.free)}. Não há limite de tamanho por arquivo; o limite é o espaço em disco.` : '';
  $('#l1').innerHTML = vids.map(fileRow).join('') + ups('video').map(upRow).join('');
  $('#c1').textContent = vids.length ? `${vids.length} enviado${vids.length > 1 ? 's' : ''}` : '';
  const single = (f, r, c) => { $(c.l).innerHTML = ups(r).map(upRow).join('') || (f ? fileRow(f) : ''); $(c.c).textContent = f && !ups(r).length ? `${f.meta.w}×${f.meta.h}` : ''; };
  single(wm, 'watermark', { l: '#l2', c: '#c2' }); single(ou, 'outro', { l: '#l3', c: '#c3' });

  const J = ST.jobs, n = s => J.filter(j => j.status === s).length;
  $('#s-q').textContent = n('queued'); $('#s-p').textContent = n('processing'); $('#s-d').textContent = n('done'); $('#s-e').textContent = n('error');
  $('#tot').style.width = (J.length ? J.reduce((a, j) => a + (j.status === 'done' ? 1 : j.progress || 0), 0) / J.length * 100 : 0) + '%';
  $('#l4').innerHTML = J.map(j => row(j.name, '',
    j.status === 'queued' ? 'Na fila' : j.status === 'processing' ? `Processando ${Math.round(j.progress * 100)}%` : j.status === 'done' ? '<span class="ok">Concluído</span>' : '<span class="er">Erro</span>',
    j.status === 'processing' || j.status === 'done' ? j.progress : null, '',
    j.status === 'error' ? (j.error || 'Erro desconhecido.') + (/INICIAR/.test(j.error || '') ? '' : ' Depois de corrigir, clique em INICIAR PROCESSAMENTO para tentar de novo.') : '')).join('');

  const done = J.filter(j => j.status === 'done');
  $('#c5').textContent = done.length ? `${done.length} pronto${done.length > 1 ? 's' : ''}` : '';
  const bar = isD ? `<p class="note" style="margin:0 0 10px">Os vídeos finais são salvos em <b>${esc(ST.outDir)}</b> <button class="x" onclick="DESK.openOutputDir()">Abrir pasta</button><button class="x" onclick="DESK.chooseOutputDir()">Trocar pasta</button></p>` : '';
  $('#l5').innerHTML = bar + (done.length
    ? (isD ? '' : `<p style="margin:0 0 4px"><a class="btn zip" href="/api/zip">Baixar todos em ZIP</a></p>`) + done.map(j => row(j.name, fmt(j.outSize), '', null,
        isD ? `<button class="x" data-reveal="${esc(j.out)}">Mostrar na pasta</button>` : `<a class="btn" href="/api/download/${j.id}" download>Baixar</a>`)).join('')
    : '<p class="empty">Os vídeos finalizados aparecem aqui.</p>');

  // botão: só fica desligado quando de fato falta algo, e a dica diz o quê
  const act = UP.filter(u => u.st === 'wait' || u.st === 'up').length, p = pend().length;
  const why = offline ? 'Sem conexão com o servidor.' : !ST.health.ok ? ST.health.problems[0]
    : !vids.length ? (act ? 'Aguarde o primeiro vídeo terminar de ser enviado.' : 'Envie ao menos um vídeo original.')
    : !wm ? 'Envie a marca d’água.' : !ou ? 'Envie o vídeo de encerramento.' : !p ? 'Todos os vídeos enviados já foram processados.' : '';
  $('#go').disabled = !!why;
  $('#hint').textContent = why || `${p} vídeo${p > 1 ? 's' : ''} pronto${p > 1 ? 's' : ''} para processar${act ? ` · ${act} ainda ${act > 1 ? 'estão sendo enviados' : 'está sendo enviado'} (inicie de novo quando terminar)` : ''}.`;
}

let pvKey = '', pageErr = '';
async function poll() {
  let st; try { st = await api('GET', '/api/state'); } catch (e) { offline = e; render(); return; }
  try {
    if (!Array.isArray(st.files) || !Array.isArray(st.jobs)) throw Object.assign(new Error('resposta inesperada de /api/state'), { wrong: true, status: 200 });
    ST = st; offline = false; pageErr = ''; CHUNK = ST.chunk || CHUNK;
    if (!ST.health) { ST.health = { ok: true, problems: [] }; offline = { stale: true }; }  // servidor antigo ainda rodando com a página nova
    if (!cfgInit) { cfgInit = true; Object.assign(CFG, ST.config); }
    const key = ((ST.files.find(f => f.role === 'watermark') || {}).id) + '|' + ((ST.files.find(f => f.role === 'video') || {}).id);
    if (key !== pvKey) { pvKey = key; loadEye(); schedPv(); }
    sync();
  } catch (e) { if (e.wrong) offline = e; else { pageErr = e.message; console.error(e); } }
  render();
}
(async function loop() { await poll(); setTimeout(loop, offline ? 3000 : ST.jobs.some(j => j.status === 'queued' || j.status === 'processing') ? 1000 : 3000); })();

// ----- controles de chroma key e marca d'água (valores vão ao servidor e valem para todo o lote) -----
const CTRL = [['#g1', 'intensity', 'Intensidade', 0, 100, ''], ['#g1', 'shadow', 'Sombra', 0, 100, ''], ['#g1', 'edge', 'Bordas', 0, 100, ''], ['#g1', 'smooth', 'Suavização', 0, 100, ''],
  ['#g2', 'scale', 'Escala', 1, 300, '%'], ['#g2', 'wpx', 'Tamanho', 16, 1080, 'px'], ['#g2', 'x', 'Posição horizontal', 0, 100, '%'], ['#g2', 'y', 'Posição vertical', 0, 100, '%'], ['#g2', 'opacity', 'Opacidade', 0, 100, '%']];
for (const [g, k, l, mn, mx, u] of CTRL) $(g).insertAdjacentHTML('beforeend',
  `<div class="sl"><label for="n-${k}">${l}</label><input type="range" id="r-${k}" min="${mn}" max="${mx}" step="1" aria-label="${l}"><span class="nv"><input type="number" id="n-${k}" min="${mn}" max="${mx}">${u ? `<i>${u}</i>` : '<i></i>'}</span></div>`);
const nat = () => { const w = ST.files.find(f => f.role === 'watermark'); return w ? w.meta.w : 1080; }; // largura original da marca
function sync() {
  const nw = nat(), val = { ...CFG, scale: Math.round(CFG.wpx / nw * 100) }; // Escala (% do arquivo original) e Tamanho (px no vídeo 1080) andam juntos
  $('#r-scale').max = $('#n-scale').max = Math.max(100, Math.ceil(1080 / nw * 100));
  for (const [, k] of CTRL) { if (document.activeElement !== $('#n-' + k)) $('#n-' + k).value = val[k]; $('#r-' + k).value = val[k]; }
  $('#color').value = CFG.color; $('#hex').textContent = CFG.color.toUpperCase();
}
document.addEventListener('input', e => {
  const id = e.target.id || '', k = id.slice(2), c = CTRL.find(x => x[1] === k);
  if (!/^[rn]-/.test(id) || !c) return;
  let v = Math.round(+e.target.value); if (isNaN(v)) return;
  v = Math.min(+$('#r-' + k).max, Math.max(c[3], v));
  if (k === 'scale') CFG.wpx = Math.min(1080, Math.max(16, Math.round(v / 100 * nat()))); else CFG[k] = v;
  sync(); changed();
});
$('#color').addEventListener('input', e => { CFG.color = e.target.value; sync(); changed(); });
let ct, pt;
function changed() { clearTimeout(ct); ct = setTimeout(() => api('POST', '/api/config', CFG).catch(() => {}), 300); schedPv(); }

// prévia 9:16 gerada pelo próprio FFmpeg do servidor (mesmo filtro do resultado final)
let pvc, pvUrl;
const schedPv = () => { clearTimeout(pt); pt = setTimeout(pv, 150); };
async function pv() {
  const wm = ST.files.find(f => f.role === 'watermark'), box = $('.phone'), msg = $('#pvmsg');
  if (!wm) { $('#pv').removeAttribute('src'); msg.textContent = 'Envie a marca d’água para ver a prévia.'; msg.hidden = false; return; }
  if (pvc) pvc.abort(); pvc = new AbortController(); box.classList.add('busy');
  try {
    const r = await fetch('/api/preview', { method: 'POST', headers: { 'Content-Type': 'application/json', 'X-Carimbo': '1' }, body: JSON.stringify({ ...CFG, bg: BG.v }), signal: pvc.signal });
    if (!r.ok) throw new Error((await r.json().catch(() => ({}))).error || 'HTTP ' + r.status);
    const u = URL.createObjectURL(await r.blob()); $('#pv').src = u; if (pvUrl) URL.revokeObjectURL(pvUrl); pvUrl = u;
    msg.hidden = true; box.classList.remove('busy');
  } catch (e) { if (e.name === 'AbortError') return; box.classList.remove('busy'); msg.textContent = 'Não foi possível gerar a prévia: ' + e.message; msg.hidden = false; }
}
document.querySelectorAll('.seg button').forEach(b => b.onclick = () => { BG.v = b.dataset.bg; document.querySelectorAll('.seg button').forEach(x => x.setAttribute('aria-pressed', x === b)); schedPv(); });

// conta-gotas: clique na marca original para escolher a cor do fundo
function loadEye() {
  const wm = ST.files.find(f => f.role === 'watermark'), cv = $('#eye'); cv.hidden = $('#eyenote').hidden = !wm; if (!wm) return;
  const im = new Image(); im.onload = () => { cv.width = im.width; cv.height = im.height; cv.getContext('2d', { willReadFrequently: true }).drawImage(im, 0, 0); };
  im.src = `/api/source/${wm.id}?t=${Date.now()}`;
}
$('#eye').addEventListener('click', e => {
  const cv = e.currentTarget, r = cv.getBoundingClientRect();
  const d = cv.getContext('2d').getImageData(Math.floor((e.clientX - r.left) * cv.width / r.width), Math.floor((e.clientY - r.top) * cv.height / r.height), 1, 1).data;
  if (d[3] < 200) return;
  CFG.color = '#' + [d[0], d[1], d[2]].map(v => v.toString(16).padStart(2, '0')).join(''); sync(); changed();
});

document.addEventListener('click', e => { const b = e.target.closest('[data-reveal]'); if (b && DESK) DESK.reveal(b.dataset.reveal); });
$('#go').onclick = async () => {
  say('');
  try { const r = await api('POST', '/api/process'); say(`${r.queued} vídeo${r.queued > 1 ? 's' : ''} adicionado${r.queued > 1 ? 's' : ''} à fila.`, 'ok'); }
  catch (e) { say(e.message); }
  poll();
};

// ----- arrastar e soltar -----
for (const [id, role, multi] of [['#d1', 'video', 1], ['#d2', 'watermark', 0], ['#d3', 'outro', 0]]) {
  const el = $(id), inp = el.querySelector('input');
  inp.onchange = () => { add(role, [...inp.files].slice(0, multi ? 1e9 : 1)); inp.value = ''; };
  ['dragenter', 'dragover'].forEach(e => el.addEventListener(e, ev => { ev.preventDefault(); el.classList.add('on'); }));
  ['dragleave', 'drop'].forEach(e => el.addEventListener(e, ev => { ev.preventDefault(); el.classList.remove('on'); }));
  el.addEventListener('drop', ev => add(role, [...ev.dataTransfer.files].slice(0, multi ? 1e9 : 1)));
}
['dragover', 'drop'].forEach(e => addEventListener(e, ev => ev.preventDefault()));
addEventListener('error', e => { pageErr = e.message; try { render(); } catch {} });
</script>
</body>
</html>
