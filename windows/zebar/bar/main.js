import * as zebar from 'https://esm.sh/zebar@3.3.1';

// Each provider is optional: a failed provider is skipped.
const providers = zebar.createProviderGroup({
  glazewm: { type: 'glazewm' },
  date: { type: 'date', formatting: 'dd/MM - HH:mm', refreshInterval: 1000 },
  keyboard: { type: 'keyboard' },
  cpu: { type: 'cpu', refreshInterval: 2000 },
  memory: { type: 'memory', refreshInterval: 2000 },
});

const $workspaces = document.getElementById('workspaces');
const $window = document.getElementById('window');
const $clock = document.getElementById('clock');
const $state = document.getElementById('state');
const $cpu = document.getElementById('cpu');
const $memory = document.getElementById('memory');
const $keyboard = document.getElementById('keyboard');

function render() {
  const { glazewm, date, keyboard, cpu, memory } = providers.outputMap;

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
    // state type: tiling, floating, fullscreen or minimized
    $state.textContent = isWindow ? (win.state?.type ?? '') : '';
  }

  $cpu.textContent = cpu ? `cpu ${Math.round(cpu.usage)}%` : '';
  $memory.textContent = memory ? `mem ${Math.round(memory.usage)}%` : '';

  $clock.textContent = date?.formatted ?? '';
  $keyboard.textContent = keyboard?.layout ?? '';
}

providers.onOutput(render);
render();
