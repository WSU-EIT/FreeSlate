/* Slate Editor Hints drawer — open/close + copy-to-clipboard. Showcase-only. */
(function () {
  var fab = document.querySelector('.sh-fab');
  var drawer = document.querySelector('.sh-drawer');
  var backdrop = document.querySelector('.sh-backdrop');
  if (!fab || !drawer) return;
  var closeBtn = drawer.querySelector('.sh-close');

  function open() {
    drawer.classList.add('is-open');
    if (backdrop) backdrop.classList.add('is-open');
    fab.setAttribute('aria-expanded', 'true');
    if (closeBtn) closeBtn.focus();
  }
  function close() {
    drawer.classList.remove('is-open');
    if (backdrop) backdrop.classList.remove('is-open');
    fab.setAttribute('aria-expanded', 'false');
    fab.focus();
  }
  fab.addEventListener('click', open);
  if (closeBtn) closeBtn.addEventListener('click', close);
  if (backdrop) backdrop.addEventListener('click', close);
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && drawer.classList.contains('is-open')) close();
  });

  drawer.querySelectorAll('.sh-copy').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var code = btn.parentElement.querySelector('code');
      navigator.clipboard.writeText(code.textContent).then(function () {
        btn.textContent = 'Copied';
        btn.classList.add('copied');
        setTimeout(function () { btn.textContent = 'Copy'; btn.classList.remove('copied'); }, 1500);
      });
    });
  });
})();
