/* Variant tabs — swap [data-variant] on a target element. Showcase-only. */
(function () {
  document.querySelectorAll('.vtabs').forEach(function (bar) {
    var sel = bar.getAttribute('data-target');
    var target = sel ? document.querySelector(sel) : document.body;
    var tabs = Array.prototype.slice.call(bar.querySelectorAll('.vtab'));
    function set(v) {
      if (target) target.setAttribute('data-variant', v);
      tabs.forEach(function (t) {
        var on = t.getAttribute('data-variant') === v;
        t.classList.toggle('is-active', on);
        t.setAttribute('aria-selected', on ? 'true' : 'false');
      });
    }
    tabs.forEach(function (t) { t.addEventListener('click', function () { set(t.getAttribute('data-variant')); }); });
    var init = bar.querySelector('.vtab.is-active') || tabs[0];
    if (init) set(init.getAttribute('data-variant'));
  });
})();
