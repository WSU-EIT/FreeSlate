/* ════════════════════════════════════════════════════════════════════════
   WSU EIT FORMS — plain-English glossary (showcase-only)
   Jargon in the explanatory text gets a dotted underline + a tooltip on
   hover/focus, PLUS a clickable (i) button that opens the same explanation
   as a popover (better for touch + keyboard). The full list also collapses
   into the About chapter. Showcase aid only — ships nothing to Slate.
   ════════════════════════════════════════════════════════════════════════ */
(function () {
  var TERMS = {
    'token': 'A named setting (a CSS variable) that holds one brand value in one place.',
    'custom property': 'Another name for a CSS variable, like --wsu-eit-brand.',
    'rem': "A text-size unit that scales with the visitor's browser font-size setting.",
    'em': "A size relative to the current element's own font size (it compounds when nested).",
    'px': "Pixels — a fixed size that does not follow the visitor's text-size setting.",
    'pseudo-element': 'A decorative bit CSS draws (e.g. ::before) that is not written in the HTML.',
    'BEM': 'A class-naming style: block, block__piece, block--variant.',
    'fieldset': 'An HTML box that groups related form questions together.',
    'legend': 'The shared question or title for a group of choices inside a fieldset.',
    'aria-label': 'Hidden text that gives an element its spoken name for screen readers.',
    'aria-live': 'A region screen readers announce when it changes, without moving focus.',
    'focus-visible': "The keyboard-only focus outline; mouse clicks don't trigger it.",
    'prefers-reduced-motion': 'A visitor setting that asks for less animation; the kit honors it.',
    'scroll-snap': 'A swipe/scroll carousel that snaps into place with no JavaScript.',
    'lockup': 'The fixed, approved arrangement of the cougar head and the wordmark.',
    'hairline': 'A thin, one-pixel divider line.',
    'viewport': 'The visible area of the screen.',
    'contrast ratio': 'How readable text is against its background — higher is clearer.',
    'WCAG': 'The international Web Content Accessibility Guidelines.',
    'alt text': "A written description of an image for people who can't see it.",
    'semantic HTML': 'Using the meaningful tag for the job — e.g. a real <button>, not a styled div.',
    'XSLT': 'The template language Slate uses to wrap every page in its HTML shell.'
  };

  var keys = Object.keys(TERMS).sort(function (a, b) { return b.length - a.length; });
  var lc = {}; keys.forEach(function (k) { lc[k.toLowerCase()] = k; });
  function esc(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }
  var re = new RegExp('\\b(' + keys.map(esc).join('|') + ')\\b', 'i');
  var SCOPE = '.wsu-eit-fine, .ref-note, .ref-intro, .seen-on, .tune-hint, .tune-intro, .sim-note, .wsu-eit-caption';
  var uid = 0;

  function wrap(el) {
    var seen = {};
    var walker = document.createTreeWalker(el, NodeFilter.SHOW_TEXT, {
      acceptNode: function (n) {
        var p = n.parentNode;
        while (p && p !== el) {
          var t = p.tagName;
          if (t === 'CODE' || t === 'A' || t === 'BUTTON' || t === 'PRE' || (p.classList && p.classList.contains('gloss'))) return NodeFilter.FILTER_REJECT;
          p = p.parentNode;
        }
        return re.test(n.nodeValue) ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP;
      }
    });
    var nodes = [], n;
    while ((n = walker.nextNode())) nodes.push(n);
    nodes.forEach(function (node) {
      var m = re.exec(node.nodeValue);
      if (!m) return;
      var canon = lc[m[1].toLowerCase()];
      if (!canon || seen[canon]) return;
      seen[canon] = 1;
      var i = m.index, match = node.nodeValue.substr(i, m[1].length);
      var before = node.nodeValue.slice(0, i), after = node.nodeValue.slice(i + m[1].length);
      var popId = 'gloss-pop-' + (++uid);

      var span = document.createElement('span');
      span.className = 'gloss';
      span.tabIndex = 0;
      span.setAttribute('role', 'note');
      span.setAttribute('aria-label', canon + ': ' + TERMS[canon]);
      span.textContent = match;
      var pop = document.createElement('span');
      pop.className = 'gloss__pop'; pop.id = popId;
      pop.setAttribute('aria-hidden', 'true');
      pop.textContent = TERMS[canon];
      span.appendChild(pop);

      var ibtn = document.createElement('button');
      ibtn.type = 'button';
      ibtn.className = 'gloss__i';
      ibtn.setAttribute('aria-label', 'Explain: ' + canon);
      ibtn.setAttribute('aria-expanded', 'false');
      ibtn.setAttribute('aria-controls', popId);
      ibtn.textContent = 'i';

      var frag = document.createDocumentFragment();
      if (before) frag.appendChild(document.createTextNode(before));
      frag.appendChild(span);
      frag.appendChild(ibtn);
      if (after) frag.appendChild(document.createTextNode(after));
      node.parentNode.replaceChild(frag, node);
    });
  }
  document.querySelectorAll(SCOPE).forEach(wrap);

  /* (i) button = click/keyboard popover; Esc or outside-click closes */
  function closeAll(except) {
    document.querySelectorAll('.gloss--open').forEach(function (g) {
      if (g === except) return;
      g.classList.remove('gloss--open');
      var prev = g.nextElementSibling;
      if (prev && prev.classList.contains('gloss__i')) prev.setAttribute('aria-expanded', 'false');
    });
  }
  document.addEventListener('click', function (e) {
    var btn = e.target.closest && e.target.closest('.gloss__i');
    if (btn) {
      e.preventDefault();
      var term = btn.previousElementSibling;
      if (term && term.classList.contains('gloss')) {
        var open = term.classList.toggle('gloss--open');
        btn.setAttribute('aria-expanded', String(open));
        closeAll(open ? term : null);
      }
      return;
    }
    closeAll(null);
  });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeAll(null); });

  /* full glossary, collapsed, at the top of the About chapter */
  var about = document.getElementById('chap-cat-about');
  if (about) {
    var det = document.createElement('details');
    det.className = 'gloss-legend';
    var esc = function (s) {
      return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    };
    var rows = keys.slice().sort().map(function (k) {
      return '<dt>' + esc(k) + '</dt><dd>' + esc(TERMS[k]) + '</dd>';
    }).join('');
    det.innerHTML = '<summary>Plain-English glossary &mdash; CSS &amp; kit terms</summary><dl>' + rows + '</dl>';
    var after = about.querySelector('.ref-legend') || about.querySelector('.ref-intro') || about.querySelector('h2');
    if (after) after.insertAdjacentElement('afterend', det);
  }
})();
