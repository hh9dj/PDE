import * as zebar from 'https://esm.sh/zebar@3.3.1';

// Each provider is optional: a failed provider is skipped.
const providers = zebar.createProviderGroup({
  glazewm: { type: 'glazewm' },
  date: { type: 'date', formatting: 'dd/MM - HH:mm', refreshInterval: 1000 },
  keyboard: { type: 'keyboard' },
});

const $workspaces = document.getElementById('workspaces');
const $window = document.getElementById('window');
const $clock = document.getElementById('clock');
const $floating = document.getElementById('floating');
const $keyboard = document.getElementById('keyboard');

function render() {
  const { glazewm, date, keyboard } = providers.outputMap;

  if (glazewm) {
    $workspaces.replaceChildren(
      ...glazewm.currentWorkspaces.map(ws => {
        const el = document.createElement('button');
        el.className = 'ws';
        if (ws.hasFocus) el.classList.add('focused');
        else if (ws.isDisplayed) el.classList.add('displayed');
        el.textContent = ws.displayName ?? ws.name;
        el.onclick = () => glazewm.runCommand(`focus --workspace ${ws.name}`);
        return el;
      }),
    );

    const win = glazewm.focusedContainer;
    const isWindow = win?.type === 'window';
    $window.textContent = isWindow ? (win.title ?? '') : '';
    $floating.textContent =
      isWindow && win.state?.type === 'floating' ? 'floating' : '';
  }

  $clock.textContent = date?.formatted ?? '';
  $keyboard.textContent = keyboard?.layout ?? '';
}

providers.onOutput(render);
render();
