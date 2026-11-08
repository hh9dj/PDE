(() => {
  if (window.__pdeHints) { window.__pdeHints(); return; }
  const chars = 'abcehlmnpqswyz';
  const selector = 'a[href],button,input:not([type=hidden]),textarea,select,summary,[role=button],[role=link],[onclick],[tabindex]:not([tabindex="-1"])';
  const visible = (e) => {
    const r = e.getBoundingClientRect();
    if (r.width < 4 || r.height < 4 || r.bottom < 0 || r.right < 0 || r.top > innerHeight || r.left > innerWidth) return false;
    const s = getComputedStyle(e);
    return s.visibility !== 'hidden' && s.display !== 'none';
  };
  const els = [...document.querySelectorAll(selector)].filter(visible);
  const len = Math.max(1, Math.ceil(Math.log(els.length || 1) / Math.log(chars.length)));
  const label = (i) => {
    let s = '';
    for (let k = 0; k < len; k++) { s = chars[i % chars.length] + s; i = Math.floor(i / chars.length); }
    return s;
  };
  const box = document.createElement('div');
  box.style.cssText = 'position:fixed;top:0;left:0;z-index:2147483647;pointer-events:none';
  const tags = els.map((e, i) => {
    const r = e.getBoundingClientRect();
    const t = document.createElement('span');
    t.textContent = label(i);
    t.style.cssText = 'position:fixed;left:' + Math.max(0, r.left) + 'px;top:' + Math.max(0, r.top) + 'px;background:#df8e1d;color:#fff;font:bold 12px monospace;padding:1px 3px;border-radius:3px;text-transform:uppercase';
    box.appendChild(t);
    return t;
  });
  document.documentElement.appendChild(box);
  let typed = '';
  const stop = () => {
    document.removeEventListener('keydown', onKey, true);
    box.remove();
    window.__pdeHints = null;
  };
  const onKey = (ev) => {
    if (ev.ctrlKey || ev.altKey || ev.metaKey) return;
    ev.preventDefault();
    ev.stopPropagation();
    if (ev.key === 'Escape') { stop(); return; }
    if (ev.key === 'Backspace') typed = typed.slice(0, -1);
    else if (ev.key.length === 1) typed += ev.key.toLowerCase();
    tags.forEach((t) => { t.style.display = t.textContent.startsWith(typed) ? '' : 'none'; });
    const hit = els.filter((e, i) => label(i) === typed)[0];
    if (hit) {
      stop();
      if (/^(input|textarea|select)$/i.test(hit.tagName)) hit.focus();
      else if (ev.shiftKey && hit.href) window.open(hit.href, '_blank');
      else hit.click();
    }
  };
  window.__pdeHints = stop;
  window.focus();
  document.addEventListener('keydown', onKey, true);
})();
