"""Interface no modo desktop, em navegador real, com uma 'ponte' simulada no lugar do Electron.  Uso: python3 test/ui-desktop.py"""
import os, subprocess, sys, time, shutil, tempfile, json, urllib.request as u
from playwright.sync_api import sync_playwright
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); T = tempfile.mkdtemp(prefix='carimbo-uid-'); fails = 0; PORT = 3990
def ok(c, m, d=''):
    global fails; print(f"  {'✔' if c else '✘'} {m}" + (f"  ({d})" if d else '')); fails += (not c)
def ff(*a): subprocess.run(['ffmpeg', '-v', 'error', '-y', *a], check=True)
for d in ('orig', 'dados', 'finais'): os.makedirs(f'{T}/{d}')
V, WM, OU = f'{T}/orig/Meu video.mp4', f'{T}/orig/marca.png', f'{T}/orig/fim.mp4'
ff('-f', 'lavfi', '-i', 'color=c=0xcc3377:s=1280x720:r=30:d=3', '-f', 'lavfi', '-i', 'sine=d=3', '-shortest', '-pix_fmt', 'yuv420p', V)
ff('-f', 'lavfi', '-i', 'color=c=0x00ff00:s=400x160', '-vf', 'drawbox=x=20:y=30:w=360:h=100:color=white:t=fill', '-frames:v', '1', WM)
ff('-f', 'lavfi', '-i', 'color=c=navy:s=720x1280:r=30:d=2', '-f', 'lavfi', '-i', 'sine=f=880:d=2', '-shortest', '-pix_fmt', 'yuv420p', OU)
srv = subprocess.Popen(['node', f'{ROOT}/server.js'], env={**os.environ, 'DESKTOP': '1', 'PORT': str(PORT), 'DATA_DIR': f'{T}/dados', 'OUT_DIR': f'{T}/finais'}, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
for _ in range(50):
    try: u.urlopen(f'http://127.0.0.1:{PORT}/api/state', timeout=1); break
    except Exception: time.sleep(.1)
BRIDGE = """window.__paths = {}; window.__calls = [];
window.desktop = { pathOf: f => window.__paths[f.name] || '', openOutputDir: () => window.__calls.push('open'), chooseOutputDir: () => window.__calls.push('choose'), reveal: n => window.__calls.push('reveal:' + n) };"""
def wait(pg, cond, secs=40):
    t = time.time()
    while time.time() - t < secs:
        if pg.evaluate(cond): return True
        time.sleep(.25)
    return False
with sync_playwright() as pw:
    br = pw.chromium.launch(); ctx = br.new_context(viewport={'width': 1100, 'height': 900}); ctx.add_init_script(BRIDGE); pg = ctx.new_page(); errs = []
    pg.on('pageerror', lambda e: errs.append(str(e))); pg.goto(f'http://127.0.0.1:{PORT}')
    print('1) Arquivo cujo caminho o aplicativo não consegue descobrir')
    pg.set_input_files('#d1 input', V); wait(pg, "document.querySelector('#l1').innerText.includes('Falhou')", 8)
    ok('descobrir onde esse arquivo está' in pg.inner_text('#l1'), 'mensagem clara em vez de falha misteriosa', pg.inner_text('#l1').replace('\n', ' ')[:110])
    pg.click('#l1 >> text=✕'); time.sleep(.3)
    print('2) Fluxo normal: escolher 3 arquivos, iniciar, ver resultado na pasta')
    pg.evaluate("p => Object.assign(window.__paths, p)", {'Meu video.mp4': V, 'marca.png': WM, 'fim.mp4': OU})
    pg.set_input_files('#d1 input', V); pg.set_input_files('#d2 input', WM); pg.set_input_files('#d3 input', OU)
    ok(wait(pg, "!document.querySelector('#go').disabled", 20), 'botão habilita na hora (sem esperar "upload")', pg.inner_text('#hint'))
    ok('Adicionado' in pg.inner_text('#l1') and 'copiado' in pg.inner_text('#free'), 'tela diz "Adicionado" e que nada é copiado', pg.inner_text('#free'))
    ok(wait(pg, "document.querySelector('#pv').naturalWidth===540", 10), 'prévia 9:16 funciona com arquivos usados no lugar')
    pg.click('#go'); ok(wait(pg, "document.querySelector('#s-d').textContent==='1'", 60), 'processamento concluiu')
    ok(pg.query_selector('#l5 a[download]') is None and pg.query_selector('#l5 a.zip') is None, 'não há "Baixar" nem ZIP (arquivo já está na pasta)')
    ok(f'{T}/finais' in pg.inner_text('#l5') and 'Abrir pasta' in pg.inner_text('#l5') and 'Trocar pasta' in pg.inner_text('#l5'), 'seção 5 mostra a pasta de resultados com Abrir/Trocar', pg.inner_text('#l5').replace('\n', ' ')[:140])
    pg.click('text=Mostrar na pasta'); pg.click('text=Abrir pasta'); pg.click('text=Trocar pasta'); calls = pg.evaluate('window.__calls')
    ok(calls == ['reveal:Meu video_final.mp4', 'open', 'choose'], 'botões chamam a ponte do aplicativo com o nome certo', str(calls))
    ok(os.path.exists(f'{T}/finais/Meu video_final.mp4'), 'arquivo final está na pasta escolhida, com nome legível')
    ok(not os.listdir(f'{T}/dados/uploads'), 'nenhuma cópia foi feita')
    ok(not errs, 'nenhum erro de JavaScript', str(errs)); br.close()
srv.terminate(); print(f"\n{fails} verificação(ões) FALHARAM" if fails else "\nTUDO OK"); sys.exit(1 if fails else 0)
