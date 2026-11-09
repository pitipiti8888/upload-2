"""Teste em navegador real (Chromium via Playwright): upload -> clique em INICIAR PROCESSAMENTO -> download,
mais os cenários de falha mais comuns. Uso: python3 test/ui.py   (precisa de: pip install playwright && playwright install chromium)"""
import os, subprocess, sys, time, json, shutil, tempfile, urllib.request as u
from playwright.sync_api import sync_playwright
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE); T = tempfile.mkdtemp(prefix='carimbo-ui-')
NODE = shutil.which('node'); fails = 0
def ok(c, m, d=''):
    global fails; print(f"  {'✔' if c else '✘'} {m}" + (f"  ({d})" if d else '')); fails += (not c)
def ff(*a): subprocess.run(['ffmpeg', '-v', 'error', '-y', *a], check=True)
M = {n: os.path.join(T, n) for n in ('orig.mp4', 'outro.mp4', 'wm.png', 'grande.mp4')}
ff('-f', 'lavfi', '-i', 'color=c=0xcc3377:s=1280x720:r=30:d=4', '-f', 'lavfi', '-i', 'sine=d=4', '-shortest', '-pix_fmt', 'yuv420p', M['orig.mp4'])
ff('-f', 'lavfi', '-i', 'color=c=navy:s=720x1280:r=30:d=2', '-f', 'lavfi', '-i', 'sine=f=880:d=2', '-shortest', '-pix_fmt', 'yuv420p', M['outro.mp4'])
ff('-f', 'lavfi', '-i', 'color=c=0x00ff00:s=400x160', '-vf', 'drawbox=x=20:y=30:w=360:h=100:color=white:t=fill,drawbox=x=60:y=60:w=100:h=40:color=red:t=fill', '-frames:v', '1', M['wm.png'])
ff('-f', 'lavfi', '-i', 'testsrc2=s=1280x720:r=30:d=30', '-pix_fmt', 'yuv420p', '-b:v', '6M', M['grande.mp4'])   # ~20 MB: maior que o limite de 1 MB do proxy de teste

def start(port, data, env=None, node=NODE):
    e = {**os.environ, 'PORT': str(port), 'DATA_DIR': data, **(env or {})}
    p = subprocess.Popen([node, os.path.join(ROOT, 'server.js')], env=e, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for _ in range(50):
        try: u.urlopen(f'http://localhost:{port}/api/state', timeout=1); return p
        except Exception: time.sleep(.1)
    raise RuntimeError('servidor não subiu')
def proxy(port, target, limit):
    code = f"const h=require('http');h.createServer((q,s)=>{{if(+q.headers['content-length']>{limit}){{s.writeHead(413,{{'Content-Type':'text/html'}});return s.end('413')}}const r=h.request({{port:{target},path:q.url,method:q.method,headers:q.headers}},x=>{{s.writeHead(x.statusCode,x.headers);x.pipe(s)}});q.pipe(r)}}).listen({port})"
    p = subprocess.Popen([NODE, '-e', code]); time.sleep(.5); return p
def files(pg, v='orig.mp4'):
    pg.set_input_files('#d1 input', M[v]); pg.set_input_files('#d2 input', M['wm.png']); pg.set_input_files('#d3 input', M['outro.mp4'])
def wait(pg, cond, secs=40):
    t = time.time()
    while time.time() - t < secs:
        if pg.evaluate(cond): return True
        time.sleep(.25)
    return False
def px(f, t, x, y):
    r = subprocess.run(['ffmpeg', '-v', 'error', '-ss', str(t), '-i', f, '-frames:v', '1', '-vf', f'format=rgb24,crop=1:1:{x}:{y}', '-f', 'rawvideo', '-'], capture_output=True).stdout
    return list(r)

with sync_playwright() as pw:
    br = pw.chromium.launch()
    print('1) Fluxo normal: enviar 3 arquivos, ajustar um controle, clicar em INICIAR PROCESSAMENTO, baixar')
    srv = start(3401, T + '/d1'); pg = br.new_page(accept_downloads=True, viewport={'width': 1100, 'height': 900}); errs = []
    pg.on('pageerror', lambda e: errs.append(str(e))); pg.goto('http://localhost:3401'); files(pg)
    ok(wait(pg, "!document.querySelector('#go').disabled"), 'botão habilita sozinho depois dos envios', pg.inner_text('#hint'))
    ok(wait(pg, "document.querySelector('#pv').naturalWidth===540", 10), 'prévia 9:16 (540x960) apareceu')
    pg.fill('#n-wpx', '400'); time.sleep(.6)                                  # Tamanho: 400 px (padrão 300)
    pg.click('#go')
    ok(wait(pg, "document.querySelector('#s-d').textContent==='1'", 60), 'job foi para a fila, processou e concluiu (Concluídos = 1)', ' / '.join(pg.inner_text(x) for x in ('#s-q', '#s-p', '#s-d', '#s-e')))
    with pg.expect_download() as d: pg.click('#l5 a[download]')
    out = os.path.join(T, 'baixado.mp4'); d.value.save_as(out)
    pr = json.loads(subprocess.run(['ffprobe', '-v', 'error', '-print_format', 'json', '-show_streams', out], capture_output=True, text=True).stdout)['streams']
    v = [s for s in pr if s['codec_type'] == 'video'][0]; ok((v['width'], v['height'], v['codec_name'], v['pix_fmt']) == (1080, 1920, 'h264', 'yuv420p'), 'MP4 baixado pelo navegador: 1080x1920 H.264 yuv420p', f"{v['width']}x{v['height']}")
    ok(subprocess.run(['ffmpeg', '-v', 'error', '-i', out, '-f', 'null', '-'], capture_output=True).returncode == 0, 'arquivo baixado decodifica sem erros')
    ok(px(out, 1, 400, 1828) == [255, 255, 255] or min(px(out, 1, 400, 1828)) > 235, 'o Tamanho 400 px escolhido na tela chegou ao vídeo final (caixa branca vai até x≈412)', str(px(out, 1, 400, 1828)))
    ok(px(out, 1, 436, 1828)[1] < 120, 'e nada de marca além disso', str(px(out, 1, 436, 1828)))
    ok(min(px(out, 3.8, 232, 1828)) > 235, 'marca presente até o fim do original (t=3,8 s)')
    ok(px(out, 5, 232, 1828)[2] > 100 and px(out, 5, 232, 1828)[1] < 80, 'encerramento (t=5 s, depois dos 4 s do original) sem marca', str(px(out, 5, 232, 1828)))
    ok(not pg.is_enabled('#go'), 'depois de concluir, botão informa que não há novos vídeos', pg.inner_text('#hint'))
    print('2) Servidor cai e volta')
    srv.terminate(); srv.wait(); ok(wait(pg, "!document.querySelector('#banner').hidden", 10), 'aviso "Sem conexão com o servidor" aparece', pg.inner_text('#banner')[:60])
    srv = start(3401, T + '/d1'); ok(wait(pg, "document.querySelector('#banner').hidden", 12), 'aviso some quando o servidor volta')
    ok(not errs, 'nenhum erro de JavaScript na página', str(errs)); pg.close(); srv.terminate()

    print('3) Proxy rejeita partes grandes (nginx padrão: client_max_body_size 1m) — causava "Aguarde o fim dos envios" para sempre')
    srv = start(3402, T + '/d2'); px_ = proxy(3403, 3402, 1048576); pg = br.new_page(); pg.goto('http://localhost:3403'); files(pg, 'grande.mp4'); t0 = time.time()
    ok(wait(pg, "document.querySelector('#l1').innerText.includes('client_max_body_size')", 20), 'erro de 413 aparece em segundos, com causa e solução', f"{time.time() - t0:.1f}s")
    ok('Retomar' in pg.inner_text('#l1'), 'botão Retomar disponível')
    px_.terminate(); px_.wait(); px_ = proxy(3403, 3402, 64 * 1048576)           # administrador corrige o proxy
    pg.click('text=Retomar'); ok(wait(pg, "document.querySelector('#l1').innerText.includes('Enviado')", 30), 'depois de corrigir o proxy, Retomar conclui o envio sem recomeçar')
    pg.close(); px_.terminate(); srv.terminate()

    print('4) FFmpeg ausente no servidor — antes: "formato não reconhecido" e botão preso')
    os.makedirs(T + '/nobin', exist_ok=True); srv = start(3404, T + '/d3', env={'PATH': T + '/nobin'})
    pg = br.new_page(); pg.goto('http://localhost:3404'); wait(pg, "!document.querySelector('#banner').hidden", 8)
    ok('ffmpeg não encontrado' in pg.inner_text('#banner').lower() and 'apt install ffmpeg' in pg.inner_text('#banner'), 'faixa de aviso explica o problema e como instalar', pg.inner_text('#banner')[:70])
    files(pg); wait(pg, "document.querySelector('#l1').innerText.includes('Falhou')", 8)
    ok('ffmpeg' in pg.inner_text('#l1').lower() and 'reconheceu' not in pg.inner_text('#l1'), 'envio é recusado na hora com a causa real (não "formato inválido")')
    ok(not pg.is_enabled('#go'), 'botão desabilitado com o motivo na dica', pg.inner_text('#hint')[:60]); pg.close(); srv.terminate()

    print('5) Um job falha (disco sem permissão) e o usuário tenta de novo')
    srv = start(3405, T + '/d4'); pg = br.new_page(); pg.goto('http://localhost:3405'); files(pg); wait(pg, "!document.querySelector('#go').disabled")
    shutil.rmtree(T + '/d4/out'); pg.click('#go'); wait(pg, "document.querySelector('#s-e').textContent==='1'", 20)
    ok('Não consigo gravar' in pg.inner_text('#l4'), 'erro mostra causa e como resolver', pg.inner_text('#l4')[:110].replace('\n', ' '))
    ok(pg.is_enabled('#go'), 'botão continua habilitado para tentar de novo')
    os.makedirs(T + '/d4/out'); pg.click('#go'); ok(wait(pg, "document.querySelector('#s-d').textContent==='1'", 40), 'depois de corrigir, o mesmo botão conclui o processamento')
    pg.close(); srv.terminate(); br.close()
print(f"\n{fails} verificação(ões) FALHARAM" if fails else "\nTUDO OK"); sys.exit(1 if fails else 0)
