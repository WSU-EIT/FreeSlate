/* ════════════════════════════════════════════════════════════════════════
   wsu-eit-showcase.js — THE SHOWCASE PAGE'S OWN BRAIN (index.html only)
   ═══════════════════════════════════════════════════════════════════════
   WHY THIS FILE EXISTS: Slate's static file host serves /shared/ pages
   with a Content-Security-Policy that permits external same-origin
   scripts but BLOCKS inline <script> blocks. The showcase's interactivity
   (search, tag filters, chapter/class ordering, pretty⇄minified snippets,
   copy inspiration, icon copy, vision simulator, per-example docs) used
   to live inline and silently died under that CSP — page rendered,
   nothing clicked. Externalized 2026-06-12; load order preserved exactly
   (the blocks below run in their original document order, after the DOM
   is parsed, via defer).

   NEVER reference this file from build.xslt — it styles/scripts the
   showcase only. The deployed kit remains build.css + build-fonts.css +
   wsu-eit-extras.css + wsu-eit-a11y.js + wsu-eit-extras.js.
   ════════════════════════════════════════════════════════════════════ */

/* ── block 1 of 9 (original inline position preserved) ── */
document.getElementById('fixture-alert-btn').addEventListener('click', function () {
  var d = document.createElement('div');
  d.className = 'wsu-eit-sim-dialog';
  d.innerHTML = '<span>3 required fields were not completed.</span>';
  document.body.appendChild(d);
  setTimeout(function () { if (d.parentNode) d.parentNode.removeChild(d); }, 4000);
});

/* ── block 2 of 9 (original inline position preserved) ── */
/* Showcase-page-only script (search, tag filter, icon copy). The deployed
   kit ships no JS for styling — this page is an internal tool. */
(function () {
  var q = document.getElementById('show-q');
  var count = document.getElementById('show-count');
  var pats = Array.prototype.slice.call(document.querySelectorAll('.pat'));
  var icons = Array.prototype.slice.call(document.querySelectorAll('.ic-grid li'));
  var chaps = Array.prototype.slice.call(document.querySelectorAll('.chap'));
  var activeTag = '';

  function apply() {
    var needle = q.value.trim().toLowerCase();
    var shown = 0;
    pats.forEach(function (p) {
      var hay = (p.getAttribute('data-title') || '') + ' ' + (p.getAttribute('data-tags') || '') + ' ' + p.textContent.toLowerCase();
      var ok = (!needle || hay.indexOf(needle) !== -1) &&
               (!activeTag || (' ' + (p.getAttribute('data-tags') || '') + ' ').indexOf(' ' + activeTag + ' ') !== -1);
      p.hidden = !ok; if (ok) shown++;
    });
    icons.forEach(function (li) {
      var ok = (!activeTag || activeTag === 'icon') &&
               (!needle || li.querySelector('.ic').getAttribute('data-name').indexOf(needle) !== -1);
      li.hidden = !ok; if (ok) shown++;
    });
    chaps.forEach(function (c) {
      var any = c.querySelector('.pat:not([hidden])') || c.querySelector('.ic-grid li:not([hidden])');
      c.hidden = !any;
    });
    count.textContent = shown + ' results' + (activeTag ? ' · tag: ' + activeTag : '');
  }
  q.addEventListener('input', apply);
  document.querySelectorAll('.tagchip').forEach(function (chip) {
    chip.setAttribute('aria-pressed', 'false');
    chip.addEventListener('click', function () {
      activeTag = (activeTag === chip.getAttribute('data-tag')) ? '' : chip.getAttribute('data-tag');
      document.querySelectorAll('.tagchip').forEach(function (c) {
        c.setAttribute('aria-pressed', String(c.getAttribute('data-tag') === activeTag));
      });
      apply();
    });
  });
  apply();

  /* icon click-to-copy: FETCHES the real wsu-eit-icon-*.svg sitting beside
     this page (same files the grid renders), converts it to the accessible
     inline contract, and copies that. Nothing is hardcoded: if the file
     isn't uploaded, the tile is broken AND the copy fails loudly — the
     page can't pretend an asset exists. */
  var ICONS = window.WSU_EIT_ICONS || {};
  /* render every grid tile from the baked data — no <img>, no file uploads */
  document.querySelectorAll('.ic').forEach(function (btn) {
    var d = ICONS[btn.getAttribute('data-name')];
    var glyph = btn.querySelector('.ic-glyph');
    if (d && glyph) glyph.outerHTML = '<svg class="ic-glyph" viewBox="' + d.vb + '" aria-hidden="true" focusable="false">' + d.inner + '</svg>';
  });
  document.querySelectorAll('.ic').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var name = btn.getAttribute('data-name');
      var label = btn.querySelector('.ic-name'), orig = label.textContent;
      function flash(msg) {
        btn.classList.add('copied'); label.textContent = msg;
        setTimeout(function () { btn.classList.remove('copied'); label.textContent = orig; }, 1400);
      }
      var d = ICONS[name];
      if (!d) { flash('No data'); return; }
      var snippet = '<svg class="wsu-eit-icon" viewBox="' + d.vb + '" aria-hidden="true" focusable="false">' + d.inner + '</svg>';
      navigator.clipboard.writeText(snippet).then(
        function () { flash('Copied!'); },
        function () { flash('Copy blocked'); });
    });
  });
})();

/* ── block 3 of 9 (original inline position preserved) ── */
/* Every example must carry the HTML that produces its rendered preview.
   Most patterns ship a hand-written snippet; for any .pat that has a demo
   but no snippet (brand-guidance cards, logos, photography, the fixtures),
   this generates one FROM THE DEMO'S OWN MARKUP — the snippet is the
   preview, byte for byte, so they can never drift apart. Runs BEFORE the
   Pretty/Minified toolbar script so generated snippets get toolbars too. */
(function () {
  document.querySelectorAll('.pat').forEach(function (p) {
    var demo = p.querySelector('.pat-demo');
    if (!demo) return;
    if (p.querySelector('pre.snip')) return;   /* already has real markup */
    var details = document.createElement('details');
    details.className = 'wsu-eit-faq';
    var summary = document.createElement('summary');
    summary.textContent = p.closest('#chap-cat-fixtures')
      ? 'Markup (as Slate emits it — for study, not pasting)'
      : 'Markup to paste';
    var pre = document.createElement('pre');
    pre.className = 'snip';
    var code = document.createElement('code');
    /* sanitize: the live DOM can carry the preview host's direct-edit
       instrumentation (data-om-id / data-cc-id / data-dm-ref). Those attrs
       aren't ours and must never reach an editor's clipboard. */
    code.textContent = demo.innerHTML.trim()
      .replace(/\s+data-(?:om-id|cc-id|dm-ref)="[^"]*"/g, '');
    pre.appendChild(code);
    details.appendChild(summary);
    details.appendChild(pre);
    p.appendChild(details);
  });
})();

/* ── block 4 of 9 (original inline position preserved) ── */
/* Pretty ⇄ Minified swap on every "Markup to paste" block.
   Source snippets are stored minified (that's what editors should paste —
   Slate's editor mangles multi-line HTML less when it's one line); the
   pretty view is generated for READING by a small indenting tokenizer. */
(function () {
  var VOID = { img: 1, br: 1, hr: 1, input: 1, meta: 1, link: 1, source: 1, area: 1, col: 1, wbr: 1 };
  /* phrasing/inline elements: when these (and text) are the ONLY children of
     a block, the block stays on one line (open + content + close together) so
     a closing tag never strands onto its own line after trailing text. */
  var INLINE = { a: 1, abbr: 1, b: 1, bdi: 1, bdo: 1, cite: 1, code: 1, data: 1, dfn: 1,
    em: 1, i: 1, kbd: 1, mark: 1, q: 1, s: 1, samp: 1, small: 1, span: 1, strong: 1,
    sub: 1, sup: 1, time: 1, u: 1, 'var': 1, br: 1, wbr: 1, img: 1 };

  function escText(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
  function escAttr(s) { return s.replace(/&/g, '&amp;').replace(/"/g, '&quot;'); }
  function pad(d) { return new Array(d + 1).join('  '); }

  /* A REAL pretty-printer: parse the snippet into a detached DOM (no scripts
     run, nothing touches the page), then walk the tree applying block/inline
     rules. Replaces the old regex tokenizer that broke only at >< seams and
     stranded close tags after text (e.g. "…full.</p>"). */
  function prettyPrint(src) {
    var tpl = document.createElement('template');
    tpl.innerHTML = src;

    function attrStr(el) {
      var s = '';
      for (var i = 0; i < el.attributes.length; i++) {
        var a = el.attributes[i];
        s += (a.value === '') ? ' ' + a.name : ' ' + a.name + '="' + escAttr(a.value) + '"';
      }
      return s;
    }
    function tagOf(n) { return n.nodeName.toLowerCase(); }
    function isVoid(n) { return VOID[tagOf(n)] === 1; }
    function isSvgLeaf(n) { return n.namespaceURI && n.namespaceURI.indexOf('svg') > -1 && !n.childNodes.length; }
    /* Block-vs-inline is CONTEXTUAL, not just by tag name. An element gets its
       own line(s) when it's a block-level tag OR when it's an inline tag that
       wraps block content — HTML5 lets <a> (or <span>) contain <h3>/<p>, and
       such a wrapper must format as a block or its children collapse. */
    function rendersBlock(n) {
      if (n.nodeType !== 1 || isVoid(n) || isSvgLeaf(n)) return false;
      if (!INLINE[tagOf(n)]) return true;          // genuine block-level tag
      return childRendersBlock(n);                  // inline tag wrapping blocks
    }
    function childRendersBlock(el) {
      for (var i = 0; i < el.childNodes.length; i++) if (rendersBlock(el.childNodes[i])) return true;
      return false;
    }
    /* serialize an element's content as a single inline string */
    function inlineStr(el) {
      var s = '';
      el.childNodes.forEach(function (n) {
        if (n.nodeType === 3) { s += escText(n.nodeValue.replace(/\s+/g, ' ')); return; }
        if (n.nodeType !== 1) return;
        var tag = tagOf(n);
        if (isVoid(n)) { s += '<' + tag + attrStr(n) + '>'; }
        else if (isSvgLeaf(n)) { s += '<' + tag + attrStr(n) + ' />'; }
        else { s += '<' + tag + attrStr(n) + '>' + inlineStr(n) + '</' + tag + '>'; }
      });
      return s;
    }

    var lines = [];
    function walk(parent, depth) {
      parent.childNodes.forEach(function (n) {
        if (n.nodeType === 3) {
          var t = n.nodeValue.replace(/\s+/g, ' ').trim();
          if (t) lines.push(pad(depth) + escText(t));
          return;
        }
        if (n.nodeType !== 1) return;
        var tag = tagOf(n);
        if (isVoid(n)) { lines.push(pad(depth) + '<' + tag + attrStr(n) + '>'); return; }
        if (isSvgLeaf(n)) { lines.push(pad(depth) + '<' + tag + attrStr(n) + ' />'); return; }
        if (!childRendersBlock(n)) {
          lines.push(pad(depth) + '<' + tag + attrStr(n) + '>' + inlineStr(n).trim() + '</' + tag + '>');
        } else {
          lines.push(pad(depth) + '<' + tag + attrStr(n) + '>');
          walk(n, depth + 1);
          lines.push(pad(depth) + '</' + tag + '>');
        }
      });
    }
    walk(tpl.content, 0);
    return lines.join('\n');
  }

  document.querySelectorAll('pre.snip').forEach(function (pre) {
    var code = pre.querySelector('code');
    if (!code) return;
    /* state lives ON the pre so the copy-inspiration browser (a separate
       script) can swap in alternate copy and re-render the same snippet */
    /* pristine markup. Three passes, because published copies of this page
       pass through upload tools that re-indent HTML — tabs have shown up
       INSIDE code blocks on the hosted copy that don't exist in the repo:
       1) join lines, eating indentation around each break (incl. tabs left
          BEFORE the newline, which the old \n\s* pattern missed),
       2) any tab that still survives mid-line becomes one space,
       3) collapse space runs. Single meaningful spaces in text are kept. */
    pre._base = code.textContent.trim()
      .replace(/\s*\n\s*/g, '')
      .replace(/\t+/g, ' ')
      .replace(/ {2,}/g, ' ');
    pre._alt = null;        /* markup with an inspiration message swapped in */
    pre._view = 'pretty';
    pre._render = function () {
      var eff = pre._alt || pre._base;
      code.textContent = pre._view === 'min' ? eff : prettyPrint(eff);
    };
    pre._render();

    var bar = document.createElement('div');
    bar.className = 'snip-bar';
    /* only offer the Pretty/Minified toggle when they actually differ — a
       single-block snippet (e.g. one <p> of inline text) is identical either
       way, so the toggle would look broken. Those get just Copy. */
    var expands = prettyPrint(pre._base) !== pre._base;
    bar.innerHTML = (expands
        ? '<button type="button" class="snip-view" data-v="pretty" aria-pressed="true">Pretty</button>'
          + '<button type="button" class="snip-view" data-v="min" aria-pressed="false">Minified</button>'
        : '<span class="snip-single">single line</span>')
      + '<button type="button" class="snip-copy">Copy</button>';
    pre.parentNode.insertBefore(bar, pre);

    bar.querySelectorAll('.snip-view').forEach(function (b) {
      b.addEventListener('click', function () {
        pre._view = b.getAttribute('data-v');
        pre._render();
        bar.querySelectorAll('.snip-view').forEach(function (x) {
          x.setAttribute('aria-pressed', String(x === b));
        });
      });
    });
    bar.querySelector('.snip-copy').addEventListener('click', function () {
      var btn = bar.querySelector('.snip-copy');
      var eff = pre._alt || pre._base;
      navigator.clipboard.writeText(pre._view === 'min' ? eff : prettyPrint(eff)).then(function () {
        btn.textContent = pre._view === 'min' ? 'Copied minified!' : 'Copied pretty!';
        setTimeout(function () { btn.textContent = 'Copy'; }, 1400);
      });
    });
  });
})();

/* ── block 5 of 9 (original inline position preserved) ── */
/* Class-name surfacing + "organize by CSS class" mode (showcase-only).
   Every pattern header grows a row of monospace chips naming the exact
   wsu-eit-* classes its demo uses (clicking one searches for it), and the
   rail's By chapter / By CSS class toggle physically regroups the pattern
   cards under alphabetized class headings. Nodes are MOVED, never cloned,
   so the snippet toolbars keep their listeners. */
(function () {
  var qInput = document.getElementById('show-q');
  var content = document.querySelector('.show-content');
  var PRIORITY = ['banner', 'note', 'warn', 'btn', 'badge', 'steps', 'timeline', 'cards', 'stats', 'table', 'faq', 'reel', 'cols', 'hi', 'pane', 'edge', 'mark', 'rule', 'fine'];
  function baseOf(c) { return c.replace('wsu-eit-', '').split('--')[0]; }
  function rank(c) { var i = PRIORITY.indexOf(baseOf(c)); return i < 0 ? 99 : i; }
  /* primary HTML element of a demo, for the "By HTML type" view */
  var HTMLPRI = ['table', 'form', 'fieldset', 'dl', 'ol', 'ul', 'blockquote', 'figure', 'details', 'dialog', 'select', 'textarea', 'input', 'button', 'a', 'img', 'time', 'mark', 'h2', 'h3', 'p', 'span', 'div'];
  function primaryTag(demo) { if (!demo) return 'div'; var els = demo.querySelectorAll('*'), set = {}; for (var i = 0; i < els.length; i++) set[els[i].tagName.toLowerCase()] = 1; for (var j = 0; j < HTMLPRI.length; j++) if (set[HTMLPRI[j]]) return HTMLPRI[j]; var ks = Object.keys(set); return ks.length ? ks[0] : 'div'; }

  /* inventory every pattern's kit classes from its live demo.
     [data-ref] cards are the About chapter's citation cards — pure reference,
     no kit-class demo — so they're excluded from class chips and class-view. */
  var info = Array.prototype.map.call(document.querySelectorAll('.pat:not([data-ref])'), function (p) {
    var demo = p.querySelector('.pat-demo');
    var found = demo ? (demo.innerHTML.match(/wsu-eit-[a-z]+(?:--[a-z-]+)?/g) || []) : [];
    var uniq = Array.from(new Set(found)).sort(function (a, b) { return rank(a) - rank(b) || a.localeCompare(b); });
    return { el: p, classes: uniq, htmlKey: primaryTag(demo), parent: p.parentNode, next: p.nextSibling };
  });

  /* header chips — the class names become visible, searchable plain text */
  info.forEach(function (it) {
    var bar = document.createElement('div');
    bar.className = 'pat-classes';
    var list = it.classes.length ? it.classes : ['plain HTML — no kit class needed'];
    list.forEach(function (c) {
      var b = document.createElement('button');
      b.type = 'button'; b.className = 'cls-chip'; b.textContent = c;
      if (c.indexOf('wsu-eit-') === 0) {
        b.title = 'Search for ' + c;
        b.addEventListener('click', function () {
          qInput.value = c;
          qInput.dispatchEvent(new Event('input'));
          window.scrollTo({ top: 0, behavior: 'smooth' });
        });
      } else { b.disabled = true; }
      bar.appendChild(b);
    });
    var h3 = it.el.querySelector('h3');
    if (h3) h3.insertAdjacentElement('afterend', bar);
  });

  /* class-view: groups built once, patterns moved in/out on toggle */
  var byClass = document.createElement('div');
  byClass.id = 'byclass'; byClass.hidden = true;
  content.appendChild(byClass);
  /* by-HTML-type view: same move-not-clone approach, keyed by primary element */
  var byHtml = document.createElement('div');
  byHtml.id = 'byhtml'; byHtml.hidden = true;
  content.appendChild(byHtml);
  var hgroups = null;
  function buildHtmlGroups() {
    if (hgroups) return;
    hgroups = {};
    info.forEach(function (it) { (hgroups[it.htmlKey] = hgroups[it.htmlKey] || []).push(it); });
    var navUl = document.querySelector('#nav-html ul');
    Object.keys(hgroups).sort().forEach(function (k) {
      var sec = document.createElement('section');
      sec.className = 'chap htmlgrp'; sec.id = 'htm-' + k;
      sec.innerHTML = '<h2><code>&lt;' + k + '&gt;</code> <span class="wsu-eit-fine">(' + hgroups[k].length + ')</span></h2>';
      byHtml.appendChild(sec);
      var li = document.createElement('li');
      li.innerHTML = '<a href="#htm-' + k + '">&lt;' + k + '&gt; <span>' + hgroups[k].length + '</span></a>';
      navUl.appendChild(li);
    });
  }
  var groups = null;
  function buildGroups() {
    if (groups) return;
    groups = {};
    info.forEach(function (it) {
      var key = it.classes.length ? 'wsu-eit-' + baseOf(it.classes[0]) : 'plain-html';
      (groups[key] = groups[key] || []).push(it);
    });
    var navUl = document.querySelector('#nav-classes ul');
    Object.keys(groups).sort().forEach(function (k) {
      var sec = document.createElement('section');
      sec.className = 'chap clsgrp'; sec.id = 'cls-' + k;
      var label = k === 'plain-html' ? 'plain HTML (no kit class)' : k;
      sec.innerHTML = '<h2><code>' + label + '</code> <span class="wsu-eit-fine">(' + groups[k].length + ')</span></h2>';
      byClass.appendChild(sec);
      var li = document.createElement('li');
      li.innerHTML = '<a href="#cls-' + k + '">' + label + ' <span>' + groups[k].length + '</span></a>';
      navUl.appendChild(li);
    });
  }
  function restore() {
    /* move every card back to its original spot (reverse order so a card's
       remembered next-sibling is already in place before we insert ahead). */
    for (var i = info.length - 1; i >= 0; i--) {
      var it = info[i];
      if (it.next && it.next.parentNode === it.parent) it.parent.insertBefore(it.el, it.next);
      else it.parent.appendChild(it.el);
    }
  }
  function setMode(mode) {
    restore();
    byClass.hidden = true; byHtml.hidden = true;
    if (mode === 'class') {
      buildGroups();
      info.forEach(function (it) {
        var key = it.classes.length ? 'wsu-eit-' + baseOf(it.classes[0]) : 'plain-html';
        document.getElementById('cls-' + key).appendChild(it.el);
      });
      byClass.hidden = false;
    } else if (mode === 'html') {
      buildHtmlGroups();
      info.forEach(function (it) { document.getElementById('htm-' + it.htmlKey).appendChild(it.el); });
      byHtml.hidden = false;
    }
    document.getElementById('nav-chapters').hidden = (mode !== 'chapter');
    document.getElementById('nav-classes').hidden = (mode !== 'class');
    document.getElementById('nav-html').hidden = (mode !== 'html');
    document.querySelectorAll('.viewswap button').forEach(function (b) {
      b.setAttribute('aria-pressed', String(b.getAttribute('data-mode') === mode));
    });
    /* re-run the filter pass so empty chapters/groups hide correctly */
    qInput.dispatchEvent(new Event('input'));
  }
  /* inject the third view toggle + its nav list before wiring click handlers */
  (function () {
    var vs = document.querySelector('.viewswap');
    if (vs && !vs.querySelector('[data-mode="html"]')) {
      var b = document.createElement('button');
      b.type = 'button'; b.className = 'vsw'; b.setAttribute('data-mode', 'html'); b.setAttribute('aria-pressed', 'false');
      b.textContent = 'By HTML type';
      vs.appendChild(b);
    }
    if (!document.getElementById('nav-html')) {
      var nav = document.createElement('nav');
      nav.id = 'nav-html'; nav.hidden = true; nav.setAttribute('aria-label', 'HTML element types');
      nav.innerHTML = '<ul></ul>';
      var nc = document.getElementById('nav-classes');
      if (nc) nc.insertAdjacentElement('afterend', nav);
    }
  })();
  document.querySelectorAll('.viewswap button').forEach(function (b) {
    b.addEventListener('click', function () { setMode(b.getAttribute('data-mode')); });
  });

  /* keep class groups in sync with search/tag filtering (runs after the
     original filter listener, since it was attached later) */
  function fixGroups() {
    document.querySelectorAll('.clsgrp, .htmlgrp').forEach(function (g) {
      g.hidden = !g.querySelector('.pat:not([hidden])');
    });
  }
  qInput.addEventListener('input', fixGroups);
  document.querySelectorAll('.tagchip').forEach(function (c) { c.addEventListener('click', fixGroups); });
})();

/* ── block 6 of 9 (original inline position preserved) ── */
/* Live index counts: while a search/tag filter is active, every chapter (or
   class-group) link in the rail shows "matching / total" and grays out when
   nothing inside it qualifies. Attached last, so it always runs after the
   filtering listeners have updated [hidden] states. */
(function () {
  var qInput = document.getElementById('show-q');

  function sectionFor(a) {
    var id = a.getAttribute('href').slice(1);
    return document.getElementById('chap-' + id)   /* chapter links (#cat-x) */
        || document.getElementById(id);            /* class-group links (#cls-x) */
  }
  function counts(sec) {
    var pats = sec.querySelectorAll('.pat'), icons = sec.querySelectorAll('.ic-grid li');
    var vis = sec.querySelectorAll('.pat:not([hidden])').length
            + sec.querySelectorAll('.ic-grid li:not([hidden])').length;
    return { total: pats.length + icons.length, vis: vis };
  }
  function filterActive() {
    if (qInput.value.trim()) return true;
    return !!document.querySelector('.tagchip[aria-pressed="true"]');
  }
  function syncIndex() {
    var active = filterActive();
    document.querySelectorAll('.show-rail nav:not([hidden]) li').forEach(function (li) {
      var a = li.querySelector('a'), span = li.querySelector('a span');
      if (!a || !span) return;
      var sec = sectionFor(a);
      if (!sec) return;
      var c = counts(sec);
      if (!span.hasAttribute('data-total')) span.setAttribute('data-total', String(c.total));
      var total = span.getAttribute('data-total');
      span.textContent = active ? (c.vis + ' / ' + total) : total;
      li.classList.toggle('nav-dim', active && c.vis === 0);
    });
  }
  /* run after the filter listeners (registered earlier) on every trigger */
  qInput.addEventListener('input', syncIndex);
  document.querySelectorAll('.tagchip').forEach(function (c) { c.addEventListener('click', syncIndex); });
  document.querySelectorAll('.viewswap button').forEach(function (b) { b.addEventListener('click', syncIndex); });
  syncIndex();
})();

/* ── block 7 of 9 (original inline position preserved) ── */
/* EVERY EXAMPLE DOCUMENTED (showcase-only script).
   Each pattern card gets: (1) a one-line BRIEF under its class chips —
   what it is and when to reach for it; (2) an expandable "Full notes"
   panel answering what/why/how/when-where, naming the exact SLATE
   click-path to use it, and linking Wikipedia (the underlying concept)
   plus a pre-built Google search to learn more. Docs are written per
   PURPOSE-KIND (same routing as the inspiration banks), so related
   patterns share accurate, hand-written guidance. */
(function () {
  /* Slate click-paths, shared across kinds */
  var P = {
    ins: "Slate → Forms → your form → Edit Form → drag the Instructions tool from the palette to where this belongs → Status: Active → open the Label's HTML editor, switch to Source, paste the markup → Save, then Preview.",
    field: "Slate → Forms → your form → Edit Form → click the question → paste this text into the field's help/instruction area (plain text works) → Save.",
    event: "Slate → Events → your event or template → Edit → Description tab → switch the editor to Source, paste → Save. It renders above the registration form.",
    deliver: "Slate → Deliver → your mailing → Edit Message → Source view → paste → send yourself a test first.",
    portal: "Slate → Database → Portals → your portal → edit the static content block in Source view → paste. Data-driven parts (names, statuses) come from the method query as merge fields/Liquid.",
    comm: "Slate → Forms → your form → Edit Communications (or the confirmation page) → paste into the message body's Source view → Save, then submit a test registration.",
    set: "Prefer the NATIVE setting: Slate → Forms/Events → Edit → use registration deadline, activation date (with its custom message), and the closed-registration message fields instead of pasted HTML."
  };
  /* [brief-what, why, how, when/where, slate path, wikiTitle, wikiSlug, google query] */
  var D = {
    welcome:["A branded opener that tells people what the form is and how long it takes.","First impressions set completion rates — an unexplained form gets abandoned.","One wsu-eit-banner div pasted above the questions; headline + one sentence.","Top of page 1 on inquiry, RSVP, and application forms.",P.ins,"Onboarding","Onboarding","form welcome message UX best practices"],
    required:["The one-line key explaining the * marker.","Slate's own docs recommend an asterisk key; screen-reader users and skimmers both need the legend.","A single wsu-eit-fine paragraph; the kit adds the stars to required fields automatically.","Directly under the form's H1, every form.",P.ins,"Web Content Accessibility Guidelines","Web_Content_Accessibility_Guidelines","required field asterisk accessibility best practice"],
    time:["A time-to-complete estimate.","Knowing the cost up front reduces abandonment mid-form.","One fine-print line; be honest, round up.","Form openers; pair with the have-ready checklist.",P.ins,"User experience","User_experience","form completion time estimate conversion"],
    deadline:["A dated urgency notice.","Deadlines drive action — but only when visible before the questions start.","wsu-eit-warn block with the date in bold; never invent fake urgency.","Form/event tops while the date is real; remove after.",P.set + " Use this pasted block only for messaging BEFORE the deadline hits.","Time limit","Time_limit","admissions deadline reminder messaging examples"],
    save:["A save-and-resume reassurance note.","People stop mid-form; telling them their work survives brings them back.","wsu-eit-note block; only promise it on forms where Slate's save-for-later is on.","Long forms and applications.",P.ins,"Autosave","Autosave","save and resume form UX"],
    prep:["A have-these-ready checklist.","Gathering documents mid-form is the #1 stall; prep prevents it.","wsu-eit-note with a short ul; 3–4 items max.","Openers of forms needing transcripts/IDs.",P.ins,"Checklist","Checklist","form preparation checklist UX"],
    help:["A get-help block with real contact channels.","Stuck users abandon silently unless help is one tap away.","Links use tel: and mailto: so phones dial directly.","Form openers, footers, and confirmation pages.",P.ins,"Customer service","Customer_service","contact help box form design"],
    routing:["An are-you-in-the-right-place redirect.","Wrong-audience submissions waste the student's time and your staff's.","wsu-eit-note naming who this form is for, linking the alternative.","Top of forms with commonly-confused siblings (first-year vs transfer vs grad).",P.ins,"Information architecture","Information_architecture","form audience routing UX pattern"],
    progress:["A page-position line for multi-page forms.","Orientation reduces abandonment: people finish what they can size.","One fine-print line per page; Slate's rail gives the full map.","Each page of multi-page forms.",P.ins,"Progress bar","Progress_bar","multi step form progress indicator UX"],
    name:["Help text for legal-vs-preferred name fields.","Name mismatches split records; warmth matters — explain both.","Plain text in the field's help area.","Any name question.",P.field,"Personal name","Personal_name","legal name preferred name form design higher ed"],
    dob:["Help text explaining why birthdate is asked.","Unexplained DOB questions feel invasive; one sentence fixes it.","Plain text: matching only, never used in review.","Every DOB field.",P.field,"Record linkage","Record_linkage","date of birth why we ask form privacy"],
    ssn:["Help text for optional SSN fields.","SSN anxiety is real; explain optionality, encryption, and the FAFSA link.","Plain text in field help.","Anywhere SSN is requested.",P.field,"Social Security number","Social_Security_number","SSN optional form privacy language"],
    email:["Help text steering to a durable inbox.","Expiring school emails are the top cause of missed decisions.","Plain text in field help.","Every email field.",P.field,"Email address","Email_address","email field help text form best practice"],
    phone:["Help text with texting consent.","SMS consent is a compliance line AND a deliverability win.","Plain text incl. STOP language.","Phone fields where texting follows.",P.field,"SMS","SMS","SMS opt in consent language higher ed"],
    address:["Help text for address blocks.","Bad addresses bounce admit packets; small hints prevent big misses.","Plain text in field help.","Mailing address questions.",P.field,"Address","Address","address form field UX best practices"],
    school:["Help text for the school search/lookup.","The lookup speeds matching by days — when people know how to use it.","Plain text above/below Slate's school search widget.","School questions.",P.field,"College Board","College_Board","CEEB code school lookup help"],
    gpa:["Help text for GPA entry.","Scale confusion creates junk data; saying 'estimates fine' lowers anxiety.","Plain text in field help.","GPA questions.",P.field,"Grading in education","Grading_in_education","GPA field self report form help text"],
    test:["The test-optional statement.","'Optional' only works if students believe blank ≠ penalty — say it.","Plain text in field help or an instructions block above the section.","Score questions on test-optional forms.",P.field,"Test-optional admissions","Test-optional_movement","test optional statement admissions wording"],
    residency:["Help text de-stressing the residency question.","Residency reads as high-stakes; 'best guess, easy to fix' keeps people moving.","Plain text in field help.","Residency questions.",P.field,"In-state tuition","Undocumented_immigrant_tuition_policies_in_the_United_States","residency question form help text university"],
    pronouns:["Help text for optional pronoun fields.","Clarity about who sees it makes the question welcoming instead of worrying.","Plain text in field help.","Pronoun questions.",P.field,"Preferred gender pronoun","Preferred_gender_pronoun","pronoun field form best practice"],
    infonote:["A neutral informational callout.","Reassurance ('free, no obligation') removes silent objections.","wsu-eit-note div around one or two sentences.","Anywhere a fact lowers anxiety.",P.ins,"Information design","Information_design","callout box content design"],
    warning:["A time-sensitive or don't-do-this caution.","Amber framing earns attention — if reserved for genuinely cautionary content.","wsu-eit-warn div; one warning per view, or none land.","Deadlines, document rules, capacity.",P.ins,"Warning label","Warning_label","warning callout UX writing"],
    success:["A submission-received confirmation message.","Closure: people need to know it worked and what happens next.","Confirmation page/communication content; pair with whatnext steps.","Post-submit surfaces.",P.comm,"Feedback","Feedback","form confirmation message UX examples"],
    intl:["A pointer for international applicants.","Their checklist differs; surfacing it early avoids dead-end submissions.","wsu-eit-note linking the international checklist.","Forms international students use.",P.ins,"International student","International_student","international applicant checklist content"],
    vets:["A military/veteran benefits pointer.","Benefit-eligible students often don't know who to ask; name the office.","wsu-eit-note with the certifying-official contact.","Inquiry/application forms and event pages.",P.ins,"G.I. Bill","G.I._Bill","veteran student benefits page content university"],
    access:["An accommodation-request invitation.","Asking is a barrier; an explicit invitation lowers it.","Fine-print or note with the Access Center contact.","Event pages and form footers.",P.ins,"Reasonable accommodation","Reasonable_accommodation","event accommodation statement example university"],
    waiver:["Fee-waiver reassurance.","The fee deters exactly the students you most want to keep; say waivers exist.","wsu-eit-note near any mention of cost.","Application/payment contexts.",P.ins,"Waiver","Waiver","application fee waiver language admissions"],
    cta:["A primary action button (link styled as button).","One unmistakable next step beats three competing links.","a.wsu-eit-btn; one primary per view.","Form openers, event pages, decision moments.",P.ins,"Call to action (marketing)","Call_to_action_(marketing)","call to action button copy higher ed"],
    portal:["A portal sign-in prompt.","The portal answers most 'what's my status' calls — route people there.","wsu-eit-note + button to the portal URL.","Confirmations, emails, status content.",P.comm,"Web portal","Web_portal","applicant portal login CTA content"],
    logistics:["Arrival logistics: parking, check-in, maps.","Day-of confusion sours a visit before it starts.","Plain paragraphs with map links; keep lot/room names exact.","Event descriptions and reminder emails.",P.event,"Wayfinding","Wayfinding","campus visit parking check in instructions"],
    status:["Status lines with colored badge pills.","Color PLUS text scans instantly and survives color-blindness.","wsu-eit-badge spans with --done/--wait/--todo/--info modifiers.","Portals and status emails.",P.portal,"Workflow","Workflow","application status checklist UI"],
    deposit:["The deposit call-to-action.","The yield moment: deadline + amount + one button, nothing else.","wsu-eit-warn + button; date in bold.","Admitted-student portals/comms.",P.portal,"College admissions in the United States","College_admissions_in_the_United_States","enrollment deposit reminder messaging"],
    whatnext:["A what-happens-next sequence.","Post-submit silence breeds calls; three numbered steps prevent them.","ol.wsu-eit-steps with bolded leads.","Confirmation pages and emails.",P.comm,"User journey","User_journey","what happens next confirmation page steps"],
    invite:["Event invitation copy.","Specific, warm, family-inclusive invitations out-convert generic ones.","Banner + date/place block in the event description.","Event landing/registration pages.",P.event,"Campus tour","Campus_tour","campus visit day invitation copy"],
    capacity:["A capacity/waitlist notice.","Honest scarcity drives registration; Slate enforces the actual cap.","wsu-eit-warn; numbers hand-set or omitted — Slate closes at limit natively.","Filling events.",P.event,"Scarcity","Scarcity","event capacity waitlist messaging"],
    agenda:["A day-of agenda or bring-list.","Knowing the shape of the day reduces no-shows.","Timeline ul or note with a short list.","Event descriptions and reminders.",P.event,"Agenda (meeting)","Agenda_(meeting)","event agenda what to bring content"],
    wrap:["Post-event thanks and next step.","The visit is the warmest moment — bank it with one follow-up action.","Note + one link (apply/tour again).","Post-event emails/survey pages.",P.deliver,"Letter of thanks","Letter_of_thanks","post event thank you email next step"],
    tableintro:["A framed, scrollable data table.","Pasted tables overflow phones and lose their headers; the wrapper fixes both.","div.wsu-eit-table[tabindex=0][role=region][aria-label] around an ordinary table.","Deadlines, costs, contacts, sessions.",P.ins,"Table (information)","Table_(information)","accessible responsive HTML table pattern"],
    faq:["Native-element FAQ accordion.","Progressive disclosure: questions scan; answers appear on demand — keyboard/SR support is built into details/summary.","Stacked details.wsu-eit-faq blocks.","FAQ sections, policy text.",P.ins,"FAQ","FAQ","details summary accordion accessibility"],
    glossary:["A plain-language term definition.","Jargon (FAFSA, CEEB) silently blocks first-gen families.","Bold term + one-sentence definition + the key fact.","Wherever a term first appears.",P.ins,"Glossary","Glossary","plain language glossary higher ed"],
    testimonial:["A short student quote.","Proof beats promises; one authentic sentence outperforms paragraphs of marketing.","wsu-eit-note with em quote + fine-print attribution.","Landing/event pages, sparingly.",P.ins,"Testimonial","Testimonial","student testimonial content marketing"],
    stats:["Big-number stat tiles.","Numbers as heroes scan in a glance.","div.wsu-eit-stats; strong = the number, rest = label. 3–4 tiles max.","Landing/event/scholarship content.",P.ins,"Infographic","Infographic","stat tiles design pattern"],
    programs:["Auto-fit program/option cards.","The grid packs columns to fit any screen with zero breakpoint work; link cards lift.","div.wsu-eit-cards with a (linked) or div (static) children.","Program highlights, option pickers.",P.ins,"Academic major","Academic_major","card grid layout CSS auto-fit"],
    captions:["Real photography with honest captions/alt text.","Images without alt text exclude screen-reader users; captions ground the photo.","figure + img (re-hosted in Slate Files) + figcaption; alt describes, caption adds.","Event/landing imagery.",P.event,"Alt attribute","Alt_attribute","writing good alt text images"],
    closed:["A closed/ended terminal message.","A dead-end without alternatives loses the student; always offer a door.","Heading + short paragraph + 1–2 alternative links.","Closed forms/events.",P.set,"Error message","Error_message","form closed message UX alternatives"],
    legal:["Compliance fine print.","Required language doesn't have to shout; fine-print styling keeps it present but quiet.","p.wsu-eit-fine at the bottom of the relevant content.","SMS consent, photo notice, nondiscrimination.",P.ins,"Fine print","Fine_print","SMS consent disclosure wording"],
    social:["A social-channels row.","Students verify you're real on social before they submit anything.","One line of links; never icon-only without labels.","Footers and thank-you pages.",P.ins,"Social media","Social_media","university admissions social media links page"],
    recommendation:["Recommender-facing intro copy.","Recommenders are volunteers; tell them the ask is small and bounded.","Opener note on the recommendation form.","Recommendation request forms.",P.ins,"Letter of recommendation","Letter_of_recommendation","recommendation request form instructions"],
    scholarship:["A scholarship summary section.","Aid is the #1 question; stats + dates + one action answer it fast.","Stats band + timeline + button.","Cost/aid content, admitted comms.",P.ins,"Scholarship","Scholarship","scholarship section content university page"],
    brand:["A brand-rules demonstration.","Brand consistency is enforced by the kit's tokens — these cards show the rules the CSS encodes.","Use the kit's classes; never hand-type hex values into content.","Reference for editors; not usually pasted into forms.","Reference only — colors and the gradient ship inside build.css; if content seems to need a new color, email brand@lists.wsu.edu instead of overriding.","Brand management","Brand_management","university brand guidelines color usage"],
    prefill:["A pre-filled form link via query string parameters.","Native Slate: fields arrive already answered, friction drops, attribution improves.","Append ?export_key=value pairs to the form URL; use in Deliver links and QR codes.","Mailings, posters, counselor handouts.","Build the link anywhere (Deliver → Edit Message works well); the export keys come from Slate → Forms → your form → Edit Form → each field's Export Key setting.","Query string","Query_string","Slate query string parameters prefill form"],
    fixtures:["Slate's emitted markup with planted defects, repaired live.","Proof that the kit handles real Slate output — study it, don't paste it.","Open DevTools and watch wsu-eit-a11y.js's repairs in the DOM.","Reference for admins and auditors.","Nothing to paste — this mirrors what Slate emits on its own. To verify on a real form: render it in the test instance and inspect with WAVE/DevTools.","WAI-ARIA","WAI-ARIA","WAVE accessibility evaluation form labels"],
    a11ydemo:["A pattern that exists for assistive technology — the visual part is the smaller half.","Roughly 1 in 4 adults has a disability; forms are where access failures cost applications.","Copy the markup exactly — the aria/tabindex/label plumbing IS the pattern.","Any form or page; these compose with every other kit component.","Paste via the Instructions tool or field settings like any pattern; then verify in the test instance with WAVE (wave.webaim.org) before publishing.","Web accessibility","Web_accessibility","WCAG form accessibility patterns screen reader"],
    iconusage:["The accessible inline-SVG icon contract.","Icon fonts break screen readers; inline SVG inherits color and size cleanly.","Click any icon in the grid to copy a self-contained snippet.","Beside text in any pasted content.",P.ins,"Scalable Vector Graphics","Scalable_Vector_Graphics","inline SVG icon accessibility currentColor"]
  };
  var MAP = {1:'welcome',2:'required',3:'time',4:'deadline',5:'save',6:'prep',7:'help',8:'routing',9:'progress',10:'welcome',11:'name',12:'dob',13:'ssn',14:'email',15:'phone',16:'address',17:'school',18:'gpa',19:'test',20:'residency',21:'pronouns',22:'routing',23:'infonote',24:'warning',25:'success',26:'intl',27:'vets',28:'access',29:'waiver',30:'warning',31:'cta',32:'cta',33:'portal',34:'help',35:'help',36:'logistics',37:'logistics',38:'cta',39:'status',40:'status',41:'portal',42:'deposit',43:'whatnext',44:'whatnext',45:'status',46:'status',47:'invite',48:'invite',49:'capacity',50:'agenda',51:'prep',52:'logistics',53:'agenda',54:'wrap',55:'wrap',56:'deadline',57:'tableintro',58:'tableintro',59:'tableintro',60:'tableintro',61:'tableintro',62:'tableintro',63:'faq',64:'faq',65:'glossary',66:'testimonial',67:'stats',68:'programs',69:'programs',70:'faq',71:'captions',72:'captions',73:'captions',74:'programs',75:'programs',76:'captions',77:'success',78:'closed',79:'capacity',80:'capacity',81:'success',82:'closed',83:'closed',84:'routing',85:'help',86:'help',87:'legal',88:'legal',89:'legal',90:'access',91:'legal',92:'social',93:'welcome',94:'invite',95:'portal',96:'infonote',97:'logistics',98:'recommendation',99:'scholarship',100:'help',101:'stats',102:'deadline',103:'infonote',104:'infonote',105:'status',106:'programs',107:'programs',108:'waiver'};

  /* FRAMEWORK PATTERNS — when an example leans on a kit convention, name
     the convention and why to follow it. Written for editors who know CSS
     and the old system: enough to transfer the idea, no lecture. */
  var ONEWRAP = "One-wrapper pattern: a single kit class on the outer div does all the styling; everything inside is ordinary HTML. Gray note = neutral info, amber warn = genuine caution — pick by meaning, never by looks.";
  var FIELDTEXT = "Plain-text pattern: field help needs NO markup — Slate renders it under the label and the kit styles it. Reach for HTML only in Instructions blocks; pasted styling inside field help fights the form builder.";
  var BTN = "Class-on-a-link pattern: wsu-eit-btn turns a real <a> into the brand button — it still works with JS off. Corollary: any custom button in content must carry SOME class, or the kit assumes it's a Slate submit button and paints it crimson.";
  var BADGE = "Base + modifier pattern (the kit's --grammar): class=\"wsu-eit-badge wsu-eit-badge--done\". The base carries the pill shape; the --variant only swaps colors; a modifier is never used alone. Same grammar across the whole kit.";
  var BANNERPAT = "Component + __piece pattern: wsu-eit-banner is the component; wsu-eit-banner__kicker (double underscore) is a named piece that only makes sense inside it. Don't move pieces outside their component.";
  var GRID = "Auto-fit grid pattern: the wrapper class owns the layout; children are plain HTML. Add or remove children freely — the grid re-flows itself, no breakpoints to maintain.";
  var TABLEPAT = "Scroll-region pattern: the wrapper supplies zebra striping, sticky header, and phone-safe scrolling around your ordinary <table>. tabindex=\"0\" + role=\"region\" + aria-label are part of the pattern — they make the scroll area keyboard-reachable and announceable; copy them every time.";
  var FAQPAT = "Native-element pattern: <details>/<summary> IS the accordion — keyboard, screen-reader, and find-in-page behavior come from the browser; the class only dresses it. Always prefer a native element over a rebuilt widget when one exists.";
  var STEPSPAT = "Self-numbering list pattern: you write a plain ol/ul; CSS counters and pseudo-elements draw the discs, dots, and connector lines. Reorder or delete items and the visuals fix themselves — never type numbers into the text.";
  var MEDIAPAT = "Figure pattern: img + figcaption travel together; alt text DESCRIBES the image for screen readers while the caption ADDS context for everyone. The reel variant needs tabindex=\"0\" — any scrollable strip must be focusable.";
  var TOKENPAT = "Design-token pattern: every color lives once as a CSS custom property (--wsu-eit-*) in build.css §TOKENS, and content never hand-types hex values. A brand change is a one-line edit that updates every form at once.";
  var AUTOMARK = "Automatic-marker pattern: the kit draws required stars from Slate's own data-required attribute via CSS ::after — you never type asterisks on questions. Only this key line is manual.";
  var MAPLAYER = "Mapping-layer pattern: kit rules target the classes Slate itself emits (.form_question, .form_label, #menu), so a form built entirely in the form builder themes itself with zero pasted HTML. That's why you never rename or wrap Slate's structures.";
  var SNIPPAT = "Self-contained snippet pattern: copied icons carry their whole contract inline (1em sizing, currentColor, aria-hidden) so they work pasted anywhere, with no stylesheet hook and no icon font.";
  var UTILPAT = "Utility-class pattern: wsu-eit-fine is a one-job class (small, quiet text). Utilities compose with anything; if you're stacking three of them, you probably want a component instead.";
  var PAT = { infonote: ONEWRAP, warning: ONEWRAP, prep: ONEWRAP, save: ONEWRAP, routing: ONEWRAP, help: ONEWRAP, intl: ONEWRAP, vets: ONEWRAP, access: ONEWRAP, waiver: ONEWRAP, testimonial: ONEWRAP, deadline: ONEWRAP, success: ONEWRAP, closed: ONEWRAP,
    name: FIELDTEXT, dob: FIELDTEXT, ssn: FIELDTEXT, email: FIELDTEXT, phone: FIELDTEXT, address: FIELDTEXT, school: FIELDTEXT, gpa: FIELDTEXT, test: FIELDTEXT, residency: FIELDTEXT, pronouns: FIELDTEXT,
    cta: BTN, portal: BTN, prefill: BTN, deposit: BTN, scholarship: BTN,
    status: BADGE, welcome: BANNERPAT, invite: BANNERPAT,
    programs: GRID, stats: GRID, tableintro: TABLEPAT, faq: FAQPAT,
    whatnext: STEPSPAT, agenda: STEPSPAT, wrap: ONEWRAP, captions: MEDIAPAT,
    brand: TOKENPAT, required: AUTOMARK, fixtures: MAPLAYER, iconusage: SNIPPAT,
    legal: UTILPAT, time: UTILPAT, progress: UTILPAT, logistics: ONEWRAP, recommendation: ONEWRAP, glossary: ONEWRAP, social: UTILPAT, capacity: ONEWRAP, deposit2: null };

  function esc(s) { var d = document.createElement('span'); d.textContent = s; return d.innerHTML; }
  document.querySelectorAll('.pat').forEach(function (p) {
    var numEl = p.querySelector('.pat-num');
    if (!numEl) return;
    var key = MAP[parseInt(numEl.textContent, 10)];
    if (!key) {
      var t = (p.getAttribute('data-title') || '').toLowerCase();
      key = /^a11y /.test(t) ? 'a11ydemo'
          : /fixtures/.test(t) ? 'fixtures'
          : /icon usage/.test(t) ? 'iconusage'
          : /photo|tone words/.test(t) ? 'captions'
          : /never list/.test(t) ? 'warning'
          : /pre-filled/.test(t) ? 'prefill'
          : /lockup|variants|gradient|ratio|color/.test(t) ? 'brand'
          : null;
    }
    var d = D[key];
    if (!d) return;
    var anchor = p.querySelector('.pat-classes') || p.querySelector('h3');
    if (!anchor) return;
    var brief = document.createElement('p');
    brief.className = 'pat-brief';
    brief.textContent = d[0];
    anchor.insertAdjacentElement('afterend', brief);
    var wiki = 'https://en.wikipedia.org/wiki/' + d[6];
    var goog = 'https://www.google.com/search?q=' + encodeURIComponent(d[7]);
    var docs = document.createElement('details');
    docs.className = 'pat-docs';
    docs.innerHTML = '<summary>Learn more</summary><div>'
      + '<p><b>Why.</b> ' + esc(d[1]) + '</p>'
      + '<p><b>How.</b> ' + esc(d[2]) + '</p>'
      + (PAT[key] ? '<p><b>Framework pattern.</b> ' + esc(PAT[key]) + '</p>' : '')
      + '<p><b>When / where.</b> ' + esc(d[3]) + '</p>'
      + '<p><b>In Slate.</b> ' + esc(d[4]) + '</p>'
      + '<p><b>Learn more.</b> Concept: <a href="' + wiki + '" target="_blank" rel="noopener">Wikipedia — ' + esc(d[5]) + '</a> · Go deeper: <a href="' + goog + '" target="_blank" rel="noopener">search “' + esc(d[7]) + '”</a></p>'
      + '</div>';
    brief.insertAdjacentElement('afterend', docs);
  });
})();

/* ── block 8 of 9 (original inline position preserved) ── */
/* A11Y LAYER (showcase-only).
   (a) Vision simulator: one filter class on the content column.
   (b) ♿ chips: any example whose markup carries accessibility attributes
       gets a chip warning "these attrs are load-bearing — keep them," and
       its Learn-more panel gains an A11y line linking the EXACT WCAG rule.
   (c) "Screen reader view" per card: walks the demo like AT would —
       skipping aria-hidden, honoring labels/roles — and prints the
       announcement sequence. */
(function () {
  /* (a) simulator */
  var content = document.querySelector('.show-content');
  document.querySelectorAll('[data-sim]').forEach(function (b) {
    b.addEventListener('click', function () {
      content.className = 'show-content' + (b.getAttribute('data-sim') ? ' ' + b.getAttribute('data-sim') : '');
      document.querySelectorAll('[data-sim]').forEach(function (x) {
        x.setAttribute('aria-pressed', String(x === b));
      });
    });
  });

  /* (b) detect load-bearing a11y markup; link the exact rule */
  var U = 'https://www.w3.org/WAI/WCAG21/Understanding/';
  var RULES = [
    [/tabindex="0"/, 'tabindex="0" makes the scroll region keyboard-reachable', '2.1.1 Keyboard', U + 'keyboard.html'],
    [/aria-label=/, 'aria-label gives the element its spoken name', '4.1.2 Name, Role, Value', U + 'name-role-value.html'],
    [/role="region"|role="group"/, 'the role + name announce this as a landmark/group', '1.3.1 Info and Relationships', U + 'info-and-relationships.html'],
    [/aria-hidden="true"/, 'aria-hidden hides decoration from screen readers', '1.1.1 Non-text Content', U + 'non-text-content.html'],
    [/<label[^>]+for=/, 'label[for] binds the text to its field — never separate them', '3.3.2 Labels or Instructions', U + 'labels-or-instructions.html'],
    [/<legend/, 'fieldset + legend group related choices under one spoken question', '1.3.1 Info and Relationships', U + 'info-and-relationships.html'],
    [/\balt="/, 'alt text is what screen readers say instead of the image', '1.1.1 Non-text Content', U + 'non-text-content.html'],
    [/target="_blank"/, 'new-tab links should warn users in advance (the kit adds a hidden notice)', 'G201 advance warning', 'https://www.w3.org/WAI/WCAG21/Techniques/general/G201'],
    [/aria-describedby=/, 'aria-describedby attaches help text to the field it explains', '3.3.2 Labels or Instructions', U + 'labels-or-instructions.html'],
    [/aria-live=/, 'aria-live announces updates without stealing focus', '4.1.3 Status Messages', U + 'status-messages.html'],
    [/class="wsu-eit-sr"/, '.wsu-eit-sr text is invisible but spoken — context for non-visual users', '1.3.1 Info and Relationships', U + 'info-and-relationships.html']
  ];
  document.querySelectorAll('.pat').forEach(function (p) {
    var demo = p.querySelector('.pat-demo');
    var chips = p.querySelector('.pat-classes');
    if (!demo || !chips) return;
    var html = demo.innerHTML;
    var hits = RULES.filter(function (r) { return r[0].test(html); });
    if (!hits.length) return;
    var chip = document.createElement('span');
    chip.className = 'a11y-chip';
    chip.textContent = '\u267F a11y attributes \u2014 keep them';
    chip.title = 'This markup does non-obvious accessibility work. Details in Learn more.';
    chips.appendChild(chip);
    var docs = p.querySelector('.pat-docs > div');
    if (docs) {
      var para = document.createElement('p');
      var parts = hits.slice(0, 4).map(function (r) {
        return r[1] + ' (<a href="' + r[3] + '" target="_blank" rel="noopener">WCAG ' + r[2] + '</a>)';
      });
      para.innerHTML = '<b>A11y \u2014 why this markup looks "extra."</b> ' + parts.join('; ') + '. Strip these and the example stops working for assistive tech.';
      docs.appendChild(para);
    }
  });

  /* (c) screen-reader view */
  var SKIP = { SCRIPT: 1, STYLE: 1, TEMPLATE: 1 };
  function announce(el, out, depth) {
    if (depth > 14 || SKIP[el.tagName]) return;
    if (el.getAttribute && el.getAttribute('aria-hidden') === 'true') return;
    if (el.hidden) return;
    var tag = el.tagName, name = el.getAttribute ? (el.getAttribute('aria-label') || '') : '';
    function txt() { return (name || el.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 90); }
    var role = null;
    if (/^H[1-4]$/.test(tag)) role = 'heading level ' + tag[1];
    else if (tag === 'A') role = 'link';
    else if (tag === 'BUTTON' || (tag === 'INPUT' && /submit|button/.test(el.type))) role = 'button';
    else if (tag === 'IMG') { out.push('<b>image</b>, ' + (el.getAttribute('alt') ? '\u201c' + el.getAttribute('alt') + '\u201d' : el.hasAttribute('alt') ? '(decorative \u2014 skipped silently)' : '(NO ALT \u2014 reader may say the filename)')); return; }
    else if (tag === 'INPUT') role = (el.type === 'checkbox' ? 'checkbox' : el.type === 'radio' ? 'radio button' : 'edit text') + (el.required || el.getAttribute('aria-required') === 'true' ? ', required' : '');
    else if (tag === 'SELECT') role = 'combo box';
    else if (tag === 'TEXTAREA') role = 'edit text, multi-line';
    else if (tag === 'LEGEND') role = 'group label';
    else if (tag === 'LABEL') role = 'label';
    else if (tag === 'SUMMARY') role = 'button, collapsed';
    else if (tag === 'TABLE') { out.push('<b>table</b>' + (el.closest('[aria-label]') ? ', \u201c' + el.closest('[aria-label]').getAttribute('aria-label') + '\u201d' : '')); }
    else if (tag === 'UL' || tag === 'OL') out.push('<b>list</b>, ' + el.children.length + ' items');
    if (role) {
      var label = txt();
      if (tag === 'INPUT' || tag === 'SELECT' || tag === 'TEXTAREA') {
        var lab = el.getAttribute('aria-label') || (el.id && el.closest('.pat-demo') && el.closest('.pat-demo').querySelector('label[for="' + el.id + '"]') ? el.closest('.pat-demo').querySelector('label[for="' + el.id + '"]').textContent.trim() : '');
        label = (lab || '(NO NAME \u2014 announced as just \u201c' + role + '\u201d)');
      }
      out.push('<b>' + role + '</b>' + (label ? ', \u201c' + label + '\u201d' : ''));
      if (tag === 'A' || tag === 'BUTTON' || /^H/.test(tag) || tag === 'SUMMARY' || tag === 'LEGEND' || tag === 'LABEL') return;
    }
    for (var i = 0; i < el.children.length; i++) announce(el.children[i], out, depth + 1);
  }
  document.querySelectorAll('.pat').forEach(function (p) {
    var demo = p.querySelector('.pat-demo');
    var chips = p.querySelector('.pat-classes');
    if (!demo || !chips) return;
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'sr-toggle';
    btn.textContent = '\u{1F5E3} Screen reader view';
    btn.setAttribute('aria-pressed', 'false');
    chips.appendChild(btn);
    var panel = null;
    btn.addEventListener('click', function () {
      if (panel) { panel.remove(); panel = null; btn.setAttribute('aria-pressed', 'false'); return; }
      var out = [];
      announce(demo, out, 0);
      panel = document.createElement('div');
      panel.className = 'sr-view';
      panel.setAttribute('role', 'note');
      panel.innerHTML = '<b>\u2193 announcement order (simulated)</b><br>' + (out.length ? out.join('<br>') : '(plain text \u2014 read straight through)');
      demo.insertAdjacentElement('afterend', panel);
      btn.setAttribute('aria-pressed', 'true');
    });
  });
})();

/* ── block 9 of 9 (original inline position preserved) ── */
/* Copy inspiration: 10 alternate messages per pattern, browsable with
   ‹ › inside every Markup-to-paste section. Banks are grouped by what
   the pattern is FOR (deadline urgency, field help, CTAs…), so related
   patterns share a well of interchangeable phrasings. */
(function () {
  var BANKS = {"welcome":["Become a Coug. Start your journey to a brighter future.","Explore, participate, innovate — at WSU, the newly blazed trail burns brightest.","Welcome to WSU: a community united by school spirit and more than 200 programs.","Choose your academic path — we'll guide you through every step.","Take your first step to become a Coug.","Future Cougs start here — tell us you're interested.","When you choose WSU, the whole family becomes part of our community.","We're here to make your path to Washington State University easy.","Tell us about you and we'll connect you with your admission counselor.","Go Cougs — your WSU story starts with this form."],"required":["Fields marked * are required.","Starred fields are required — everything else is up to you.","Only the * fields are required. Skip anything that doesn't apply.","Required fields carry a crimson *.","* means we need it; everything else helps but is optional.","An asterisk marks the must-answer questions.","Most questions are optional — the * ones aren't.","If it has a *, we can't process the form without it.","Required questions are starred. The rest just help us help you.","Look for the * — those are the only required answers."],"time":["About 10 minutes, start to finish.","Most students finish in under 10 minutes.","10 minutes now saves a phone call later.","Grab your transcript — this takes about 10 minutes.","Short form: about 10 minutes, no essay.","Plan on 10 minutes; you can stop and resume anytime.","Ten minutes, tops — we timed it.","Quick one: about 10 minutes with your info handy.","About 10 minutes. Your answers save as you go.","Set aside 10 quiet minutes — that's all this needs."],"deadline":["Priority deadline is November 1 — later applications are space-available.","November 1 is the date that matters. Mark it.","Apply by November 1 for priority review and full scholarship consideration.","After November 1 we review space-available — earlier is always better.","The priority window closes November 1 at 11:59 p.m. Pacific.","Don't sit on it: priority review ends November 1.","November 1 = priority review + automatic scholarship consideration.","Late is better than never, but November 1 is better than late.","Submit by November 1; documents can follow after.","Priority closes Nov 1. Regular closes Jan 31. Sooner beats both."],"save":["Your answers save as you go — leave and come back anytime.","Stop anytime; sign back in with the same email to resume.","Life happens. Your progress is saved automatically.","No need to finish in one sitting — we hold your place.","Everything autosaves. Close the tab guilt-free.","Come back later — your work will be exactly where you left it.","Saved as you type. Resume from any device.","You can pause now and pick up tonight — nothing is lost.","Half-finished is fine; we keep it safe until you're back.","Autosave is on. Take your time."],"prep":["Have ready: a transcript, your activity list, and 15 quiet minutes.","You'll need: school name, grad year, and a parent or guardian's contact.","Grab your unofficial transcript before you start — it answers half of this.","Helpful nearby: transcript, test dates (if any), and your school's city.","Nothing official needed — estimates and unofficial copies are fine.","Round up: contact info, school details, intended start term.","Two minutes of prep saves ten: transcript + parent contact info.","Keep your counselor's email handy — some answers come faster from them.","If you know your CEEB code, great; if not, we'll look it up together.","Optional but useful: GPA, test scores, and a list of activities."],"help":["Stuck? Call or text 509-553-5450 — a real person answers.","Questions mid-form? future.coug@wsu.edu, weekdays 8–5.","We answer fast: text us at 509-553-5450.","Your counselor is one email away: future.coug@wsu.edu.","Don't guess — ask. 509-553-5450, Monday–Friday.","Help in plain English: call, text, or email in business hours.","Real humans, Pullman time: 8 a.m.–5 p.m., Monday–Friday.","If a question doesn't make sense, that's on us — ask and we'll fix it.","Live help while you fill this out: 509-553-5450.","Email future.coug@wsu.edu and we'll reply within one business day."],"routing":["This form is for first-year applicants — transfers have their own.","Already have college credits? You want the transfer form instead.","Graduate programs route through the Graduate School — link below.","Not sure which form fits? Start here; we'll redirect you if needed.","High school students and GEDs: you're in the right place.","Returning to finish a degree? Use the re-enrollment form.","International students: same form, plus a visa checklist after.","Running Start students count as first-years — continue here.","Parents filling this out? Better from the student's account — here's why.","If you applied before, don't start over — sign in to your portal."],"progress":["Page 2 of 4 · About you","Step 2 of 4 — almost halfway.","You're 2 pages in; 2 to go.","Next: Academics (page 3 of 4).","Halfway there — keep going.","Page 2 of 4. Your progress is saved.","Two down, two to do.","Section 2 of 4: tell us about you.","Short page ahead — 2 of 4.","Almost done: review comes after this page."],"name":["Exactly as it appears on official documents — nicknames come next.","Legal name here; the name you actually go by is the next question.","Use your ID/transcript spelling so records match.","Hyphens, apostrophes, and spaces are all welcome here.","This must match your transcript; preferred name is separate.","One letter off can split your records — copy from a document.","We print the preferred name; this one is for matching files.","If your name recently changed, use what your documents show today.","Suffixes (Jr., III) go in this field too.","Accented characters are fine — enter your name as it's written."],"dob":["Used only to match records — never in admission review.","Your birthdate pairs this form with your file. That's all it does.","We ask so two students with the same name never get mixed up.","Record matching only; age plays no role in decisions.","This keeps your documents attached to you, not a same-named stranger.","Matching key only — it never affects your application.","Needed to verify you when you call: it's our security question.","Birthdate = file matcher, not a factor.","We use month/day/year to de-duplicate records across systems.","Only admissions staff see it, and only for matching."],"ssn":["Optional — it links your FAFSA; it's never part of review.","Skip it if you prefer; provide later for financial aid matching.","Encrypted, masked, and used only to match aid records.","No SSN? Leave blank — nothing else changes.","Helps your FAFSA find you faster. Optional either way.","Only aid processing sees it; admission readers don't.","You can submit without it and add it during aid season.","Used once, for federal aid matching. Never displayed.","If you'll file FAFSA, including it now saves a verification step.","Totally optional. The form submits fine without it."],"email":["Use the inbox you actually check — decisions land there.","Avoid school addresses that expire at graduation.","One email, one record: use the same address every time.","Your portal login will be this address — pick a keeper.","Check spam once a week during application season.","Personal email beats school email — yours doesn't expire.","We send confirmations within minutes; no email means check the address.","This becomes your username. Choose the one you'll keep.","Typos here are the #1 reason students 'never hear back.'","A parent's email works, but your own is better — it's your record."],"phone":["Mobile preferred — we text status updates, never spam.","Reply STOP anytime to end texts; we keep it rare and useful.","A text from us beats a missed deadline. Mobile if you have one.","Include area code; international numbers need a country code.","We call only when something needs you — texts handle the rest.","Texting consent is optional; deadlines still arrive by email.","Use the number you answer, not the house line nobody checks.","Status nudges by text save the average applicant a week.","You can change this number anytime in your portal.","No mobile? Any number works — we'll default to email."],"address":["PO boxes are fine; we mail very little.","Moving soon? Use the address good through this summer.","This is where admitted-student mail lands — keep it current.","Apartment numbers matter — the big envelope needs them.","Use USPS format; abbreviations are okay.","If home and mailing differ, give the mailing one here.","International addresses: format them as your post office expects.","You can update this later in your portal in one click.","We verify against USPS — a suggestion may pop up; take it.","Where should the good news go? That address."],"school":["Start typing and pick from the list — codes fill automatically.","Not listed? Choose 'not listed' and type the full name.","Homeschooled? Search 'home school' and pick your state's entry.","Pick the campus you attend, not the district office.","The list searches by official names — try the formal one.","GED? Search for your testing center or choose GED.","Outside the U.S.? Search by city; most schools are in there.","If two entries look identical, pick either — we reconcile codes.","Your counselor knows your CEEB code by heart — one text away.","Choosing from the list speeds transcript matching by days."],"gpa":["Unweighted on a 4.0 scale if you have it; otherwise what your transcript shows.","Don't convert — we recalculate every GPA the same way.","Estimates are fine; transcripts confirm later.","Weighted is okay if that's all your school reports.","Out of 100? Enter it as-is and note the scale.","No GPA (homeschool, pass/fail)? Leave blank — context comes later.","Round to two decimals; close enough is good enough.","Mid-year dips? Submit anyway — trend matters more than one term.","We read GPA in the context of your school's scale and rigor.","If unsure, ask your counselor — or enter your best guess."],"test":["Test-optional means optional — blank never hurts you.","Share scores only if they strengthen your story.","No SAT/ACT? Your grades carry the application.","You can add scores later, right up to review.","Scores submitted are considered; scores withheld are ignored, not penalized.","Most admitted Cougs last year applied without scores.","Self-report now; official scores only needed if you enroll.","Took it twice? We use your best — superscored.","Still deciding? Apply now, decide on scores later.","Optional for admission AND for merit scholarships."],"residency":["Best guess is fine — the residency office confirms later, kindly.","Generally: 12 months in Washington for non-school reasons = resident.","Military families often qualify regardless — say so in the next question.","Guessing wrong costs nothing; it's easy to correct.","DACA and undocumented students may qualify via HB 1079 — ask us.","Your answer routes paperwork; it doesn't lock anything in.","Out-of-state now, moving here? Answer with today's status.","Residency affects tuition, not admission.","When in doubt, pick 'not sure' — a specialist follows up.","Washington residents: this is how you get resident tuition. Don't skip."],"pronouns":["Optional, and only shared with staff who work with you.","Tell us how to address you — or skip; both are fine.","Used in conversation, never on official documents.","You can update this anytime in your portal.","Helps counselors greet you right on calls and visits.","This is for you, not for review. Answer or don't.","Shared with your counselor, not with faculty or systems.","Prefer to self-describe? There's a box for exactly that.","Leaving this blank changes nothing about your application.","We ask because getting it right matters to us."],"infonote":["Free to submit, and never a commitment to apply.","This adds you to our list — no application is started.","No fee, no obligation, just better information.","You can unsubscribe or update preferences anytime.","Submitting won't trigger calls unless you ask for one.","We share your info with no one outside WSU.","One submission is enough — duplicates slow things down.","This is interest, not application — relax and explore.","Everything here can be changed later in your portal.","Takes effect immediately; the first email arrives within a day."],"warning":["Submit now — documents can arrive after the deadline.","Don't mail originals; copies only, nothing is returned.","One application per student — duplicates delay review.","The browser back-button can drop unsaved edits; use the form's buttons.","Uploads cap at 10 MB; compress scans if needed.","Official transcripts must come from the school, not from you.","Name mismatches stall files — match your documents exactly.","Deadlines are Pacific time, 11:59 p.m. sharp.","Check spam filters — one missed email can cost a week.","Fee waivers must be claimed before payment, not after."],"success":["You're all set — confirmation is on its way to your inbox.","Done! Watch your email for next steps within one business day.","Submission received. Your counselor takes it from here.","That's it — nothing else is needed from you today.","Received loud and clear. Check spam if no email in 15 minutes.","You're on the list. Campus info starts arriving this week.","All set! Your confirmation number is in your email.","Success — and your portal account is being created now.","We have it. You'll hear from a real person, not a robot.","Form received. Go celebrate the small wins."],"intl":["International applicants add two steps: English proficiency and credential review.","Visa documents come AFTER admission — nothing needed today.","TOEFL, IELTS, Duolingo — we accept all three.","Credentials in another language? Plan for a certified translation.","Your checklist updates automatically once you select your country.","International deadlines run earlier — check the dates page.","Sponsored students: add your sponsor's contact in the next section.","We issue I-20s within two weeks of deposit.","Questions about your country's documents? international@wsu.edu.","Conditional admission is available while you finish English requirements."],"vets":["Veterans and dependents: our certifying officials handle GI Bill® end to end.","Military training often counts as credit — send your JST.","Active duty? Ask about tuition assistance before paying anything.","The application fee is waived for service members and veterans.","Your benefits questions have a direct line: va.certification@wsu.edu.","Spouses and dependents may qualify too — worth one email.","Deployment mid-application? We pause and resume with you.","We participate in Yellow Ribbon — ask what that covers.","Veteran resource center staff are veterans themselves.","Residency rules favor military families — claim it."],"access":["Need this form in another format? We'll provide it — just ask.","Accommodations for events: five business days' notice does it.","Screen reader trouble on any page? Email us; we fix fast.","Extended time, alternate formats, ASL — all arrangeable.","Access is a right here, not a favor — tell us what helps.","The Access Center answers within one business day.","Every form has a phone-call alternative — 509-553-5450.","Tell us what works for you; we build around it.","Captioning is standard on our virtual sessions.","If anything here is hard to use, that's a bug — report it kindly."],"waiver":["Fee waivers are automatic with demonstrated need — one checkbox.","NACAC, College Board, and counselor waivers all accepted.","Can't afford the fee? Apply anyway — check the waiver box.","The fee never decides anything; waivers exist for a reason.","Veterans, foster youth, and McKinney-Vento students: auto-waived.","Your counselor can request a waiver in 30 seconds.","Waiver first, then submit — it can't apply retroactively.","No documentation needed beyond the checkbox for most students.","If the fee is the obstacle, email us — we'll sort it.","Fee waived ≠ flagged; readers never see payment status."],"cta":["Start your application →","Reserve my spot →","Count me in →","Get started — it's free →","Apply to WSU →","Take the first step →","Begin (10 minutes) →","Claim your spot →","Let's go →","Start now, finish later →"],"portal":["Track everything in one place — your applicant portal.","Your status, your checklist, your decision: all in the portal.","One login shows exactly what we have and what's missing.","Decisions post to the portal first — bookmark it.","Upload documents straight to your portal; no email needed.","The portal updates in real time as documents arrive.","Forgot your password? Reset takes one minute.","Check the portal before you call — the answer's usually there.","Green checkmarks in the portal = nothing needed from you.","Your portal is the single source of truth for your application."],"logistics":["Free visitor parking in Lot 16 — show this email at the gate.","Check in at Lighty 150; doors open 8:30.","The campus map routes you building to building.","Accessible parking sits beside the main entrance.","Download the visit guide before you lose signal on the Palouse.","Lot 16 fills by 9 — earlier is easier.","GPS 'Lighty Student Services Building, Pullman' gets you there.","Print the pass or show it on your phone; both work.","Allow 10 minutes from parking to check-in.","Campus is walkable; the tour covers about two miles."],"status":["Transcript received — nothing needed from you.","One item outstanding: official transcript.","Your file is complete and in review.","Action needed: upload your residency form.","All documents in. Decision within 2–3 weeks.","We're waiting on your school, not on you.","Received and matched to your file today.","In review — no news is normal news.","Complete as of January 12. Sit tight.","Missing-items emails go out Mondays; the portal updates daily."],"deposit":["Confirm your spot by May 1 with the $200 deposit.","May 1 holds your seat, your housing priority, and your orientation slot.","Deposit now, change your mind later — it's refundable through May 1.","The class fills; the deposit is what holds your place in it.","$200 today unlocks orientation registration tomorrow.","Deposit waivers exist — if cost is a barrier, ask.","Your offer expires without a deposit; don't let it.","Pay online in two minutes from your portal.","Housing assignments follow deposit order — earlier is better.","One deposit, one decision: you're a Coug."],"whatnext":["We confirm receipt within one business day.","A counselor reads every file — yours included.","Most decisions post within 2–3 weeks of completion.","You'll get an email the moment your status changes.","First: file check. Then: review. Then: decision in your portal.","No action needed from you while we review.","If something's missing, we email before anything stalls.","Decisions post to portals before letters mail.","Mid-review questions go straight to your counselor.","Three steps, no mysteries: confirm, review, decide."],"invite":["You're invited — and your family is too.","One Saturday, the whole campus, zero cost.","See the campus they can't put in brochures.","Tours, classes, dining halls — the real thing.","Meet your counselor face to face.","Future Coug Day: the day this gets real.","Bring your questions; we'll bring everyone who can answer them.","Free for you and your guests, lunch included.","The best campus visit is the one you actually book.","Spend a day as a Coug before you decide to be one."],"capacity":["Fewer than 50 spots remain — registration closes when full.","This session is filling fast; the waitlist moves often.","Full session? Most weeks have open alternatives.","Waitlisted guests usually get in — keep the date held.","We cap sessions so tours stay small. That's why spots run out.","Registration closes at capacity, not at a date.","A spot opens the moment someone cancels — the waitlist works.","Try a weekday tour: same campus, smaller crowds.","If this date is gone, the next one isn't — yet.","Capacity is real, but so are cancellations. Join the list."],"agenda":["Doors at 8:30, welcome at 9, tours from 10.","Wear walking shoes — two beautiful miles of campus.","Lunch is on us, in a real dining hall.","Sessions run morning to 4; leave when you need to.","Water bottle, comfortable shoes, your questions: the whole packing list.","Check-in takes five minutes; coffee is waiting.","Parents get their own session — students get theirs.","A rain plan exists; the day runs regardless.","Photos welcome everywhere on the route.","The agenda emails three days before your visit."],"wrap":["Thanks for visiting — your interest is on your record now.","Hope you felt it: that was the campus saying yes.","Next step when you're ready: the application takes under an hour.","Missed a session? Recordings land in your email this week.","Your counselor will follow up within the week.","Tell us what we missed — the survey takes two minutes.","Come back anytime; daily tours run all year.","The swag fades; the aid estimate doesn't. Book the follow-up.","It rained and you still came — that's very Coug of you.","See you in the fall, future Coug."],"tableintro":["Deadlines at a glance — Pacific time, all of them.","Costs, side by side, no fine-print games.","Every date that matters this cycle, one table.","Scroll the table on phones; the header stays put.","Estimated figures — your aid offer personalizes them.","Compare terms before you pick a start date.","Who to contact, for what, without phone-tree spelunking.","Scholarship deadlines differ from admission ones — check both.","Sessions, dates, and seats, updated weekly.","Transfer equivalencies for the most common courses."],"faq":["Q: When will I hear back? A: 2–3 weeks after your file completes.","Q: Is there an essay? A: Optional — a short one if you choose.","Q: Can I change majors later? A: Yes, most anytime before registration.","Q: Do you superscore? A: Yes, when you submit scores.","Q: What GPA do I need? A: There's no cutoff; context matters.","Q: Is the fee waivable? A: Yes — automatically with need.","Q: Can parents call about my file? A: With your FERPA release, yes.","Q: Do I need a recommendation? A: No — it's optional.","Q: When does aid info arrive? A: With or shortly after admission.","Q: Can I defer? A: One year, by request; the deposit holds."],"glossary":["FAFSA — the federal aid form; WSU's code is 003800.","CEEB — the 6-digit code that identifies your school.","Deposit — the $200 that converts 'admitted' to 'enrolled.'","Portal — your application's home page; decisions post there first.","Rolling admission — files reviewed as they complete, not after a date.","Superscore — your best section scores across test dates.","FERPA — the privacy law; releases let us talk with parents.","Waitlist — not ranked; movement follows deposits elsewhere.","Holistic review — grades in context, not formulas.","I-20 — the document international students need for a visa."],"testimonial":["“My counselor texted me back in ten minutes on a Saturday.”","“The form took less time than my homework that night.”","“I came for the tour, stayed for the dining hall.”","“Nobody made me feel like a number — not once.”","“The aid estimate was real. The offer matched it.”","“I applied test-optional and got the scholarship anyway.”","“Pullman felt like the campus version of a deep breath.”","“They answered my mom's questions like she was the applicant.”","“Waitlisted, then admitted, then home.”","“The follow-up email actually came from a human.”"],"stats":["200+ programs · one application.","17:1 — professors who know your name.","$430M in aid awarded every year.","5 campuses, one degree, one WSU.","97% of classes under 50 students.","1 in 2 students receives gift aid.","A top-tier public research university.","125,000 alumni in Washington alone.","4-year graduation guarantee programs available.","More than 300 student clubs — start your own if not."],"programs":["Engineering: ABET-accredited, hands-on from year one.","Nursing: direct-admit pathway for qualified first-years.","Business: Carson College, AACSB top 5%.","Veterinary medicine: the Northwest's flagship program.","Communication: Murrow's name, Murrow's standards.","Agriculture: the original land-grant mission, modernized.","Computer science: projects with real industry partners.","Music: audition-based scholarships for non-majors too.","Honors College: small seminars inside a big university.","Undecided: exploratory advising until you're sure."],"captions":["Thompson Flats, looking toward the Bryan Hall clocktower.","First snow on the Palouse — campus runs anyway.","Move-in day: 4,000 new Cougs, one weekend.","The view from the top of the stadium stairs, earned.","Lab time in Abelson — first-years included.","Spring on Terrell Mall, between classes.","Game-day crimson, as far as you can see.","Late light on the columns of Holland Library.","Tour groups cross paths at the cougar statue.","Sunset over the wheat — five minutes from class."],"closed":["This form has closed — but daily tours run all year.","Registration ended Oct 15; the next session is already open.","We're at capacity. The spring date posts in January.","Closed for this cycle; applications reopen August 1.","This event has passed — recordings are in your email.","Maintenance window Saturday 6–8 a.m.; back before breakfast.","The deadline passed, but options remain — call us.","Closed early due to capacity. The waitlist is live.","Spring term is closed; summer and fall are open now.","This page retired; your bookmarks should point to the new form."],"legal":["WSU is an equal-opportunity institution.","Events may be photographed for university communications.","Message and data rates may apply to texts; reply STOP anytime.","Accommodation requests: five business days' notice appreciated.","Your information is never sold, full stop.","FERPA governs everything we hold about you.","Nondiscrimination policy: policies.wsu.edu.","Recording notices are posted at event check-in.","Privacy questions: privacy@wsu.edu.","This form is the official record of your consent selections."],"social":["Follow the journey: Instagram, TikTok, YouTube.","Campus, unfiltered: @wsupullman everywhere.","Decision-day reactions live on our TikTok.","Dorm tours on YouTube — the real rooms.","Tag #FutureCoug and we'll find you.","Game-day stories, every Saturday in season.","The cougar statue cam never disappoints.","Snow-day announcements hit X first.","Behind the scenes of admissions, on Instagram.","Your future roommates are already in the comments."],"recommendation":["Ten minutes, three questions, no letter required.","Your perspective fills gaps a transcript can't.","Answers go only to the admissions review team.","Speak plainly — rubric language helps no one.","Late recommendation? It joins the file whenever it lands.","One honest paragraph beats three pages of polish.","You can save and return; the link doesn't expire.","Decline gracefully if you can't speak to this student — that helps too.","We read every word; nothing is keyword-scanned.","Thank you — this is the part of the file students never see."],"scholarship":["$430M awarded yearly — half of students receive gift aid.","One application covers most merit awards automatically.","The Jan 31 deadline unlocks the competitive awards.","Estimate your aid in five minutes — before you apply.","Scholarships stack: merit + need + departmental.","No separate essay for automatic awards.","Departmental awards open after admission — watch the portal.","Outside scholarships don't reduce ours.","FAFSA early = aid offer early. File in October.","Renewable awards renew themselves if you keep the GPA."]};
  var MAP = {"1":"welcome","2":"required","3":"time","4":"deadline","5":"save","6":"prep","7":"help","8":"routing","9":"progress","10":"welcome","11":"name","12":"dob","13":"ssn","14":"email","15":"phone","16":"address","17":"school","18":"gpa","19":"test","20":"residency","21":"pronouns","22":"routing","23":"infonote","24":"warning","25":"success","26":"intl","27":"vets","28":"access","29":"waiver","30":"warning","31":"cta","32":"cta","33":"portal","34":"help","35":"help","36":"logistics","37":"logistics","38":"cta","39":"status","40":"status","41":"portal","42":"deposit","43":"whatnext","44":"whatnext","45":"status","46":"status","47":"invite","48":"invite","49":"capacity","50":"agenda","51":"prep","52":"logistics","53":"agenda","54":"wrap","55":"wrap","56":"deadline","57":"tableintro","58":"tableintro","59":"tableintro","60":"tableintro","61":"tableintro","62":"tableintro","63":"faq","64":"faq","65":"glossary","66":"testimonial","67":"stats","68":"programs","69":"programs","70":"faq","71":"captions","72":"captions","73":"captions","74":"programs","75":"programs","76":"captions","77":"success","78":"closed","79":"capacity","80":"capacity","81":"success","82":"closed","83":"closed","84":"routing","85":"help","86":"help","87":"legal","88":"legal","89":"legal","90":"access","91":"legal","92":"social","93":"welcome","94":"invite","95":"portal","96":"infonote","97":"logistics","98":"recommendation","99":"scholarship","100":"help","101":"stats","102":"deadline","103":"infonote","104":"infonote","105":"status","106":"programs","107":"programs","108":"waiver"};
  /* brand-guidance cards cycle brand-rule phrasings */
  BANKS.brand = ["Crimson and gray must be rendered exactly — copy the hex, never eyeball it.","One gradient is sanctioned: crimson into deep crimson. Nothing else.","Accents season the page; they never become the meal.","70% core, 20% secondary, 10% accent — every branded piece.","The cougar head is never stretched, recolored, outlined, or shadowed.","White space is a brand color too — let the page breathe.","If you're typing a hex code into a form, stop and ask why.","Pick the logo file built for your background; don't fake one.","Brand questions get fast answers: brand@lists.wsu.edu.","When in doubt: more crimson, more white, fewer colors."];
  document.querySelectorAll('.pat').forEach(function (p) {
    var numEl = p.querySelector('.pat-num');
    var details = p.querySelector('details.wsu-eit-faq');
    if (!numEl || !details) return;
    var n = parseInt(numEl.textContent, 10);
    var key = MAP[n];
    if (!key) {
      /* un-numbered (◆) cards: route by what the card is about. Fixtures
         and the icon-usage card opt out — swapping Slate's emitted text
         or the copy-button contract would mislead. */
      var t = (p.getAttribute('data-title') || '').toLowerCase();
      if (/fixtures|icon usage/.test(t)) return;
      key = /^a11y /.test(t) ? 'a11ydemo'
          : /photo|tone words/.test(t) ? 'captions'
          : /never list/.test(t) ? 'warning'
          : /pre-filled/.test(t) ? 'cta'
          : /lockup|variants|gradient|ratio|color/.test(t) ? 'brand'
          : null;
    }
    var bank = BANKS[key];
    if (!bank) return;
    var pre = details.querySelector('pre.snip');
    /* choose the message to swap: the LONGEST text run that reads as a
       standalone sentence (starts like one, ends with terminal punctuation).
       Fragments — bold lead-ins, table cells, runs split by links — must
       never be swapped: a full-sentence variant spliced into a fragment
       renders broken English ("Fields marked * Starred fields are…").
       When no run qualifies, the browser is suggestion-only: ideas cycle,
       nothing is rewritten. */
    var original = '';
    if (pre && pre._base) {
      var m, re = />([^<>]{8,}?)</g;
      while ((m = re.exec(pre._base))) {
        var cand = m[1], ct = cand.trim();
        if (ct.length >= 20
            && /^["“(]?[A-Z0-9]/.test(ct)
            && /[.!?…”")→]$/.test(ct)
            && cand.length > original.length) original = cand;
      }
      /* fallback: a WHOLE <p> of 25+ chars qualifies even without terminal
         punctuation — event copy ("You're invited — and your family is
         too") and date blocks often end bare, and a full paragraph is a
         complete thought by construction, so splicing stays grammatical.
         [^<>] still rejects paragraphs broken by <br>/<strong> — those are
         fragments and must never be swapped. */
      if (!original) {
        var re2 = /<p(?:\s[^>]*)?>([^<>]{25,}?)<\/p>/g;
        while ((m = re2.exec(pre._base))) {
          var c2 = m[1], ct2 = c2.trim();
          if (/^["“(]?[A-Z0-9]/.test(ct2) && c2.length > original.length) original = c2;
        }
      }
    }
    var items = original ? [original].concat(bank) : bank.slice();
    var demo = p.querySelector('.pat-demo');
    var demoNode = null, demoOriginal = null;
    var decodedOriginal = original.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/\s+/g, ' ').trim();
    var i = 0;
    var box = document.createElement('div');
    box.className = 'alt-ins';
    box.innerHTML = '<div class="alt-ins__bar"><span class="alt-ins__label"><svg viewBox="0 0 16 16" width="0.9em" height="0.9em" fill="currentColor" aria-hidden="true" focusable="false"><path d="M7.9999,1.9998c1.9299,0,3.4999,1.5701,3.4999,3.4999c0,0.824-0.2769,1.5944-0.8009,2.228&#xA;&#9;&#9;&#9;&#9;c-0.1663,0.2011-0.2916,0.4327-0.3689,0.6819l-0.8037,2.5901H6.4727L5.6671,8.4064C5.5899,8.1579,5.4649,7.9268,5.2992,7.7262&#xA;&#9;&#9;&#9;&#9;c-0.6791-0.8223-0.938-1.8687-0.7291-2.9466c0.2552-1.3163,1.3467-2.426,2.6544-2.6984&#xA;&#9;&#9;&#9;&#9;C7.4837,2.0271,7.7446,1.9998,7.9999,1.9998 M7.9999-0.0002c-0.3864,0-0.7821,0.0399-1.1833,0.1234&#xA;&#9;&#9;&#9;&#9;C4.7086,0.5624,3.0165,2.2851,2.6067,4.399C2.2673,6.1497,2.7592,7.7914,3.7571,8.9997H3.757l1.0243,3.2968&#xA;&#9;&#9;&#9;&#9;c0.13,0.4182,0.517,0.7032,0.955,0.7032h4.5268c0.4381,0,0.8252-0.2852,0.9551-0.7036l1.022-3.2938&#xA;&#9;&#9;&#9;&#9;c0.7867-0.9514,1.2596-2.1716,1.2596-3.5026C13.4998,2.4622,11.0375-0.0002,7.9999-0.0002L7.9999-0.0002z"/><path d="M9.4998,16.0001h-3c-0.5522,0-1-0.4473-1-1s0.4478-1,1-1h3c0.5522,0,1,0.4473,1,1&#xA;&#9;&#9;&#9;&#9;S10.0521,16.0001,9.4998,16.0001z"/></svg> Copy inspiration</span>'
      + (original ? '' : '<span class="alt-ins__only">ideas only — sample text stays</span>')
      + '<button type="button" class="alt-prev" aria-label="Previous alternate message"><svg viewBox="0 0 16 16" width="0.75em" height="0.75em" fill="currentColor" aria-hidden="true" focusable="false"><path d="M6.4144,8l5.293-5.293c0.3906-0.3906,0.3906-1.0234,0-1.4141s-1.0234-0.3906-1.4141,0l-6,6&#xA;&#9;&#9;&#9;&#9;c-0.3906,0.3906-0.3906,1.0234,0,1.4141l6,6C10.4886,14.9023,10.7445,15,11.0003,15s0.5117-0.0977,0.707-0.293&#xA;&#9;&#9;&#9;&#9;c0.3906-0.3906,0.3906-1.0234,0-1.4141L6.4144,8z"/></svg></button>'
      + '<span class="alt-ins__ix">1 / ' + items.length + '</span>'
      + '<button type="button" class="alt-next" aria-label="Next alternate message"><svg viewBox="0 0 16 16" width="0.75em" height="0.75em" fill="currentColor" aria-hidden="true" focusable="false"><path d="M11.7074,7.293l-6-6c-0.3906-0.3906-1.0234-0.3906-1.4141,0s-0.3906,1.0234,0,1.4141L9.5863,8l-5.293,5.293&#xA;&#9;&#9;&#9;&#9;c-0.3906,0.3906-0.3906,1.0234,0,1.4141C4.4886,14.9023,4.7445,15,5.0003,15s0.5117-0.0977,0.707-0.293l6-6&#xA;&#9;&#9;&#9;&#9;C12.098,8.3164,12.098,7.6836,11.7074,7.293z"/></svg></button></div>'
      + '<p class="alt-ins__msg"></p>';
    details.appendChild(box);
    var ix = box.querySelector('.alt-ins__ix'), msg = box.querySelector('.alt-ins__msg');
    function show() {
      ix.textContent = (i + 1) + ' / ' + items.length;
      msg.textContent = items[i] + (original && i === 0 ? '  (original)' : '');
      /* reflect the chosen message in the markup example itself: swap the
         original text run for the alternate, re-render pretty/minified */
      if (pre && pre._base && original && pre._render) {
        /* preserve the original's surrounding whitespace: text following a
           </strong> lead-in usually starts with a meaningful space — dropping
           it glued the swapped message to the bold text */
        var lead = original.match(/^\s*/)[0], tail = original.match(/\s*$/)[0];
        pre._alt = (i === 0) ? null
          : pre._base.split('>' + original + '<').join('>' + lead + items[i] + tail + '<');
        pre._render();
        /* mirror the choice into the RENDERED PREVIEW: locate (once) the
           demo text node carrying the original message, then swap its text.
           Entities in markup ("&amp;") decode in the DOM, so compare on the
           decoded, whitespace-collapsed form. */
        if (!demoNode && demo) {
          var walker = document.createTreeWalker(demo, NodeFilter.SHOW_TEXT, null);
          var tn;
          while ((tn = walker.nextNode())) {
            if (tn.nodeValue.replace(/\s+/g, ' ').trim() === decodedOriginal) {
              demoNode = tn;
              demoOriginal = tn.nodeValue;
              break;
            }
          }
        }
        if (demoNode) {
          demoNode.nodeValue = (i === 0) ? demoOriginal
            : demoOriginal.match(/^\s*/)[0] + items[i] + demoOriginal.match(/\s*$/)[0];
        }
      }
    }
    box.querySelector('.alt-prev').addEventListener('click', function () { i = (i - 1 + items.length) % items.length; show(); });
    box.querySelector('.alt-next').addEventListener('click', function () { i = (i + 1) % items.length; show(); });
    show();
  });
})();

/* ── block 10 (added in 4.0): "TUNE THE KIT" — live design-token configurator
   WHY THIS EXISTS: stakeholders kept asking "what if links were bigger /
   corners squarer / fields denser?" — questions that used to mean edit CSS,
   re-upload, reload, squint. Every control below drives a CSS custom
   property that build.css §TOKENS actually consumes, bounded to brand-safe
   ranges (the character-creator model: sliders move, the brand doesn't
   break). The export block turns a meeting decision into a paste-ready
   §TOKENS override. Settings persist per-browser in localStorage; they
   touch this page only — no form anywhere changes until build.css does. */
(function () {
  var browse = document.getElementById('rail-browse');
  var tune = document.getElementById('rail-tune');
  var host = document.getElementById('tune-controls');
  if (!browse || !tune || !host) return;
  var root = document.documentElement;

  /* rail mode switch */
  var tabB = document.getElementById('railtab-browse');
  var tabT = document.getElementById('railtab-tune');
  function pick(which) {
    browse.hidden = which === 1;
    tune.hidden = which === 0;
    tabB.setAttribute('aria-pressed', String(which === 0));
    tabT.setAttribute('aria-pressed', String(which === 1));
    /* tune mode is a full-width takeover: the rail spans both columns and the
       pattern library steps aside so the per-control examples have room */
    var layout = document.querySelector('.show-layout');
    if (layout) layout.classList.toggle('tune-active', which === 1);
  }
  tabB.addEventListener('click', function () { pick(0); });
  tabT.addEventListener('click', function () { pick(1); });

  /* field density is one knob that moves three tokens together — exposing
     raw padding x/y would invite un-brand-safe combinations */
  var DENSITY = {
    compact:  { '--wsu-eit-field-pad-y': '.45rem', '--wsu-eit-field-pad-x': '.6rem',  '--wsu-eit-q-gap': '1rem' },
    standard: { '--wsu-eit-field-pad-y': '.7rem',  '--wsu-eit-field-pad-x': '.85rem', '--wsu-eit-q-gap': '1.5rem' },
    roomy:    { '--wsu-eit-field-pad-y': '.95rem', '--wsu-eit-field-pad-x': '1.05rem','--wsu-eit-q-gap': '2.25rem' }
  };

  /* button size is the same pattern: one knob moving two padding tokens so
     compact/standard/large can't drift into off-brand proportions */
  var BTNSIZE = {
    compact:  { '--wsu-eit-btn-pad-y': '.5rem',  '--wsu-eit-btn-pad-x': '1.3rem' },
    standard: { '--wsu-eit-btn-pad-y': '.75rem', '--wsu-eit-btn-pad-x': '2rem' },
    large:    { '--wsu-eit-btn-pad-y': '.95rem', '--wsu-eit-btn-pad-x': '2.6rem' }
  };

  /* reusable live-example snippets — each is a REAL kit element, so it reads
     the very token the control beside it drives and updates the instant the
     control moves (no per-control wiring needed for CSS-reachable tokens) */
  var EX_LINK = '<p class="tpv tpv-link">Email <a href="#" onclick="return false">future.coug@wsu.edu</a> with questions.</p>';
  var EX_H1   = '<div class="tpv tpv-h1">Apply to WSU</div>';
  var EX_H2   = '<div class="tpv tpv-h2">Application checklist</div>';
  var EX_H3   = '<div class="tpv tpv-h3">Before you start</div>';
  var EX_HEAD = '<div class="tpv tpv-headblock">Visit WSU<br>this fall</div>';
  var EX_MEASURE = '<div class="tpv tpv-measure" id="tpv-measure"><span></span><span></span><span></span></div>';
  var EX_ROUND = '<div class="tpv tpv-round"><input type="text" value="Jordan" readonly aria-label="Sample field" style="width:6.5rem"><a class="wsu-eit-btn wsu-eit-btn--compact" href="#" onclick="return false">Submit</a></div>';
  var EX_FIELD = '<input class="tpv tpv-border" type="text" value="jordan@wsu.edu" readonly aria-label="Sample field">';
  var EX_BTN = '<a class="wsu-eit-btn tpv" href="#" onclick="return false">Start application</a>';
  var EX_TEXTAREA = '<textarea class="tpv tpv-textarea" readonly aria-label="Sample message">Tell us about yourself…</textarea>';
  var EX_DENSITY = '<div class="tpv tpv-density"><div><label>First name</label><input type="text" value="Jordan" readonly></div><div><label>Last name</label><input type="text" value="Cougar" readonly></div></div>';
  var EX_CHOICE = '<div class="tpv tpv-choice"><label><input type="radio" name="tpvc" checked readonly> Pullman</label><label><input type="radio" name="tpvc" readonly> Spokane</label></div>';
  var EX_RING = '<span class="tpv tpv-ring">Focused field</span>';
  var EX_EDGE = '<div class="tpv tpv-edge">Email address</div>';
  var EX_STAR = '<span class="tpv tpv-star">First name <b>*</b></span>';
  var EX_SELECT = '<p class="tpv tpv-select">Drag to <span class="tpv-selmark">select this text</span></p>';
  var EX_TOPBAR = '<div class="tpv tpv-topbar"></div>';
  var EX_COL = '<div class="tpv tpv-col"><div class="tpv-col__page"><div class="tpv-col__col" id="tpv-col-bar"></div></div></div>';
  var EX_PAGEPAD = '<div class="tpv tpv-pagepad"><div class="tpv-pagepad__paper">Form content</div></div>';
  var EX_WASH = '<div class="tpv tpv-wash"><div class="tpv-wash__paper">Form content</div></div>';
  var EX_BODY = '<p class="tpv tpv-bodytext">Your work saves as you go.</p>';
  var EX_LH = '<p class="tpv tpv-lh">Most students finish in under an hour. Your progress saves on every page.</p>';
  var EX_BODYINK = '<p class="tpv tpv-bodyink">Most students finish in under an hour.</p>';

  function PX(v) { return Math.round(v * 16) + 'px'; }   /* rem → px label */

  /* THE SETTINGS TABLE — every entry: bounded range or closed choice list,
     a live example (pv), the token(s) it moves (vars), and an `off` map for
     the per-feature On/Off switch (the kit treatment removed / native look). */
  var SPEC = [
    /* ── TYPE ── */
    { id: 'bodysize', group: 'Type', name: 'Body text size', kind: 'range', min: 15, max: 18, def: 16, unit: 'px',
      hint: 'Base reading size for all paragraph text.', pv: EX_BODY,
      vars: function (v) { return { '--wsu-eit-body-size': (v / 16) + 'rem' }; }, off: { '--wsu-eit-body-size': '1rem' } },
    { id: 'line', group: 'Type', name: 'Reading line-height', kind: 'range', min: 1.2, max: 1.75, def: 1.55, step: 0.05,
      fmt: function (v) { return (+v).toFixed(2); },
      hint: 'Vertical space between lines. Off shows the browser-default tight spacing.', pv: EX_LH,
      vars: function (v) { return { '--wsu-eit-line': String(v) }; }, off: { '--wsu-eit-line': 'normal' } },
    { id: 'bodyink', group: 'Type', name: 'Body text color', kind: 'choice', def: '#262626',
      opts: [['#262626', 'Near-black'], ['#1a1a1a', 'True black'], ['#3a3a3a', 'Soft gray']],
      hint: 'The ink for body copy. All three pass AA on white.', pv: EX_BODYINK,
      vars: function (v) { return { '--wsu-eit-body': v }; }, off: { '--wsu-eit-body': '#262626' } },
    { id: 'linksize', group: 'Type', name: 'Link text size', kind: 'range', min: 14, max: 22, def: 16, unit: 'px',
      hint: 'Links never render smaller than this. 16px is the shipped floor.', pv: EX_LINK,
      vars: function (v) { return { '--wsu-eit-link-size': (v / 16) + 'rem' }; }, off: { '--wsu-eit-link-size': '16px' } },
    { id: 'linkweight', group: 'Type', name: 'Link weight', kind: 'choice', def: '600',
      opts: [['400', 'Regular'], ['600', 'Semibold'], ['700', 'Bold']],
      hint: 'Semibold is the shipped look; Regular reads quieter in dense copy.', pv: EX_LINK,
      vars: function (v) { return { '--wsu-eit-link-weight': v }; }, off: { '--wsu-eit-link-weight': '400' } },
    { id: 'underline', group: 'Type', name: 'Link underline', kind: 'range', min: 1, max: 3, def: 1, unit: 'px',
      hint: 'Thickness of the underline under every link. Off removes it entirely.', pv: EX_LINK,
      vars: function (v) { return { '--wsu-eit-underline': v + 'px' }; }, off: { '--wsu-eit-underline': '0' } },
    { id: 'underlineoffset', group: 'Type', name: 'Underline offset', kind: 'range', min: 0.04, max: 0.32, def: 0.18, step: 0.02,
      fmt: function (v) { return (+v).toFixed(2) + 'em'; },
      hint: 'Gap between link text and its underline.', pv: EX_LINK,
      vars: function (v) { return { '--wsu-eit-underline-offset': (+v).toFixed(2) + 'em' }; }, off: { '--wsu-eit-underline-offset': 'auto' } },
    { id: 'measure', group: 'Type', name: 'Paragraph width', kind: 'range', min: 55, max: 90, def: 75, unit: 'ch',
      hint: 'Max line length for body copy. Off lets text run the full column.', pv: EX_MEASURE,
      vars: function (v) { return { '--wsu-eit-measure': v + 'ch' }; }, off: { '--wsu-eit-measure': 'none' } },
    { id: 'h1bar', group: 'Type', name: 'H1 crimson bar', kind: 'range', min: 0, max: 12, def: 4, unit: 'px',
      hint: 'The signature rule under page titles. 0 / Off removes it.', pv: EX_H1,
      vars: function (v) { return { '--wsu-eit-h1-bar': v + 'px' }; }, off: { '--wsu-eit-h1-bar': '0' } },
    { id: 'h1barstyle', group: 'Type', name: 'Bar length', kind: 'choice', def: '100%',
      opts: [['100%', 'Full underline'], ['3.5rem', 'Short tick']],
      hint: 'A full-width underline, or the short crimson callout tick WSU uses on centered headings.', pv: EX_H1,
      vars: function (v) { return { '--wsu-eit-h1-bar-width': v }; }, off: { '--wsu-eit-h1-bar-width': '100%' } },
    { id: 'headalign', group: 'Type', name: 'Heading alignment', kind: 'choice', def: 'left',
      opts: [['left', 'Left'], ['center', 'Centered']],
      hint: 'Centered titles center the heading and its crimson bar \u2014 the brand \u201ccallout heading\u201d look.', pv: EX_H1,
      vars: function (v) { return v === 'center' ? { '--wsu-eit-head-align': 'center', '--wsu-eit-h1-bar-mx': 'auto' } : { '--wsu-eit-head-align': 'left', '--wsu-eit-h1-bar-mx': '0' }; },
      off: { '--wsu-eit-head-align': 'left', '--wsu-eit-h1-bar-mx': '0' } },
    { id: 'h1weight', group: 'Type', name: 'H1 weight', kind: 'choice', def: '800',
      opts: [['700', 'Bold'], ['800', 'Extrabold'], ['900', 'Black']],
      hint: 'Weight of page titles. Off drops to a plain regular heading.', pv: EX_H1,
      vars: function (v) { return { '--wsu-eit-h1-weight': v }; }, off: { '--wsu-eit-h1-weight': '400' } },
    { id: 'headcolor', group: 'Type', name: 'Heading color', kind: 'choice', def: 'var(--wsu-eit-body)',
      opts: [['var(--wsu-eit-body)', 'Black'], ['var(--wsu-eit-brand-text)', 'Crimson']],
      hint: 'Color of H2 / H3 section headings.', pv: EX_H2,
      vars: function (v) { return { '--wsu-eit-head-color': v }; }, off: { '--wsu-eit-head-color': 'var(--wsu-eit-body)' } },
    { id: 'h2size', group: 'Type', name: 'H2 size', kind: 'range', min: 1.2, max: 1.85, def: 1.45, step: 0.05,
      fmt: PX, hint: 'Size of major section headings.', pv: EX_H2,
      vars: function (v) { return { '--wsu-eit-h2-size': v + 'rem' }; }, off: { '--wsu-eit-h2-size': '1.5rem' } },
    { id: 'h3size', group: 'Type', name: 'H3 size', kind: 'range', min: 1.0, max: 1.45, def: 1.15, step: 0.05,
      fmt: PX, hint: 'Size of sub-headings. Auto-capped just below H2 — a subheading never outsizes its parent.', pv: EX_H3,
      dynMax: function () { var h2 = specById('h2size'); return +(val(h2) - 0.05).toFixed(2); },
      vars: function (v) { return { '--wsu-eit-h3-size': v + 'rem' }; }, off: { '--wsu-eit-h3-size': '1.17rem' } },
    { id: 'headline', group: 'Type', name: 'Heading line-height', kind: 'range', min: 1.05, max: 1.4, def: 1.18, step: 0.05,
      fmt: function (v) { return (+v).toFixed(2); },
      hint: 'Line spacing inside multi-line headings.', pv: EX_HEAD,
      vars: function (v) { return { '--wsu-eit-head-line': String(v) }; }, off: { '--wsu-eit-head-line': 'normal' } },
    { id: 'headtrack', group: 'Type', name: 'Heading letter-spacing', kind: 'range', min: -0.02, max: 0.06, def: 0, step: 0.01,
      fmt: function (v) { return (+v).toFixed(2) + 'em'; },
      hint: 'Tracking on headings. Tighter reads modern, wider reads formal.', pv: EX_HEAD,
      vars: function (v) { return { '--wsu-eit-head-track': (+v).toFixed(2) + 'em' }; }, off: { '--wsu-eit-head-track': '0em' } },

    /* ── SHAPE & DENSITY ── */
    { id: 'round', group: 'Shape & density', name: 'Corner radius', kind: 'range', min: 0, max: 24, def: 6, unit: 'px',
      hint: '0 = sharp institutional corners, 24 = soft. Inputs, buttons, callouts all follow.', pv: EX_ROUND,
      vars: function (v) { return { '--wsu-eit-round': v + 'px' }; }, off: { '--wsu-eit-round': '0' } },
    { id: 'inputborder', group: 'Shape & density', name: 'Input border width', kind: 'range', min: 1, max: 3, def: 1, unit: 'px',
      hint: 'How heavy field outlines look. Off removes the border.', pv: EX_FIELD,
      vars: function (v) { return { '--wsu-eit-input-border': v + 'px' }; }, off: { '--wsu-eit-input-border': '0' } },
    { id: 'inputbg', group: 'Shape & density', name: 'Field fill', kind: 'choice', def: 'var(--wsu-eit-paper)',
      opts: [['var(--wsu-eit-paper)', 'White'], ['var(--wsu-eit-mist)', 'Mist gray']],
      hint: 'Inside color of text fields.', pv: EX_FIELD,
      vars: function (v) { return { '--wsu-eit-input-bg': v }; }, off: { '--wsu-eit-input-bg': 'var(--wsu-eit-paper)' } },
    { id: 'btnsize', group: 'Shape & density', name: 'Button size', kind: 'choice', def: 'standard',
      opts: [['compact', 'Compact'], ['standard', 'Standard'], ['large', 'Large']],
      hint: 'Padding inside submit / CTA buttons. Large suits a single hero action.', pv: EX_BTN,
      vars: function (v) { return BTNSIZE[v]; }, off: { '--wsu-eit-btn-pad-y': '.2rem', '--wsu-eit-btn-pad-x': '.55rem' } },
    { id: 'btnborder', group: 'Shape & density', name: 'Button border', kind: 'range', min: 0, max: 4, def: 2, unit: 'px',
      hint: 'The border ringing buttons (same crimson as the fill).', pv: EX_BTN,
      vars: function (v) { return { '--wsu-eit-btn-border': v + 'px' }; }, off: { '--wsu-eit-btn-border': '0' } },
    { id: 'btnweight', group: 'Shape & density', name: 'Button weight', kind: 'choice', def: '600',
      opts: [['500', 'Medium'], ['600', 'Semibold'], ['700', 'Bold']],
      hint: 'Weight of button label text.', pv: EX_BTN,
      vars: function (v) { return { '--wsu-eit-btn-weight': v }; }, off: { '--wsu-eit-btn-weight': '400' } },
    { id: 'btncase', group: 'Shape & density', name: 'Button text case', kind: 'choice', def: 'none',
      opts: [['none', 'Normal'], ['uppercase', 'UPPERCASE']],
      hint: 'UPPERCASE adds tracking automatically for legibility.', pv: EX_BTN,
      vars: function (v) { return v === 'uppercase' ? { '--wsu-eit-btn-transform': 'uppercase', '--wsu-eit-btn-track': '.06em' } : { '--wsu-eit-btn-transform': 'none', '--wsu-eit-btn-track': '0em' }; },
      off: { '--wsu-eit-btn-transform': 'none', '--wsu-eit-btn-track': '0em' } },
    { id: 'density', group: 'Shape & density', name: 'Field density', kind: 'choice', def: 'standard',
      opts: [['compact', 'Compact'], ['standard', 'Standard'], ['roomy', 'Roomy']],
      hint: 'Input padding + question spacing together. Compact suits long applications.', pv: EX_DENSITY,
      vars: function (v) { return DENSITY[v]; }, off: { '--wsu-eit-field-pad-y': '.25rem', '--wsu-eit-field-pad-x': '.4rem', '--wsu-eit-q-gap': '.5rem' } },
    { id: 'labelweight', group: 'Shape & density', name: 'Label weight', kind: 'choice', def: '600',
      opts: [['400', 'Regular'], ['600', 'Semibold'], ['700', 'Bold']],
      hint: 'Weight of question labels.', pv: EX_DENSITY,
      vars: function (v) { return { '--wsu-eit-label-weight': v }; }, off: { '--wsu-eit-label-weight': '400' } },
    { id: 'labelsize', group: 'Shape & density', name: 'Label size', kind: 'range', min: 0.85, max: 1.1, def: 0.95, step: 0.05,
      fmt: PX, hint: 'Size of question labels.', pv: EX_DENSITY,
      vars: function (v) { return { '--wsu-eit-label-size': v + 'rem' }; }, off: { '--wsu-eit-label-size': '16px' } },
    { id: 'textareah', group: 'Shape & density', name: 'Textarea height', kind: 'range', min: 2.5, max: 12, def: 7, step: 0.5, unit: 'rem',
      fmt: function (v) { return v + 'rem'; },
      hint: 'Minimum height of multi-line text boxes.', pv: EX_TEXTAREA,
      vars: function (v) { return { '--wsu-eit-textarea-h': v + 'rem' }; }, off: { '--wsu-eit-textarea-h': '2.5rem' } },
    { id: 'choicesize', group: 'Shape & density', name: 'Checkbox size', kind: 'range', min: 1.0, max: 1.5, def: 1.15, step: 0.05,
      fmt: PX, hint: 'Size of radio buttons and checkboxes.', pv: EX_CHOICE,
      vars: function (v) { return { '--wsu-eit-choice-size': v + 'rem' }; }, off: { '--wsu-eit-choice-size': '1rem' } },

    /* ── BRAND CUES ── */
    { id: 'focus', group: 'Brand cues', name: 'Focus ring width', kind: 'range', min: 2, max: 8, def: 3, unit: 'px',
      hint: 'The keyboard-focus outline. Thicker = easier to spot, busier.', pv: EX_RING,
      vars: function (v) { return { '--wsu-eit-focus': v + 'px' }; }, off: { '--wsu-eit-focus': '1px' } },
    { id: 'focuscolor', group: 'Brand cues', name: 'Focus ring color', kind: 'choice', def: 'var(--wsu-eit-brand)',
      opts: [['var(--wsu-eit-brand)', 'Crimson'], ['var(--wsu-eit-flag)', 'Secondary red'], ['var(--wsu-eit-body)', 'Black']],
      hint: 'Color of the focus outline.', pv: EX_RING,
      vars: function (v) { return { '--wsu-eit-focus-color': v }; }, off: { '--wsu-eit-focus-color': 'var(--wsu-eit-brand)' } },
    { id: 'focusoffset', group: 'Brand cues', name: 'Focus ring offset', kind: 'range', min: 0, max: 5, def: 2, unit: 'px',
      hint: 'Gap between the control and its focus ring.', pv: EX_RING,
      vars: function (v) { return { '--wsu-eit-focus-offset': v + 'px' }; }, off: { '--wsu-eit-focus-offset': '0' } },
    { id: 'edge', group: 'Brand cues', name: 'Required-field edge', kind: 'range', min: 0, max: 8, def: 3, unit: 'px',
      hint: 'The crimson left edge on empty required fields. 0 / Off turns it off.', pv: EX_EDGE,
      vars: function (v) { return { '--wsu-eit-edge-hint': v + 'px' }; }, off: { '--wsu-eit-edge-hint': '0' } },
    { id: 'star', group: 'Brand cues', name: 'Required star color', kind: 'choice', def: '#ca1237',
      opts: [['#ca1237', 'Secondary red'], ['#a60f2d', 'Crimson']],
      hint: 'Color of the required-field star. Off shows it in body ink.', pv: EX_STAR,
      vars: function (v) { return { '--wsu-eit-star': v }; }, off: { '--wsu-eit-star': '#262626' } },
    { id: 'starsize', group: 'Brand cues', name: 'Required star size', kind: 'range', min: 0.9, max: 1.4, def: 1, step: 0.05,
      fmt: function (v) { return (+v).toFixed(2) + 'em'; },
      hint: 'Size of the required-field star relative to its label.', pv: EX_STAR,
      vars: function (v) { return { '--wsu-eit-star-size': (+v).toFixed(2) + 'em' }; }, off: { '--wsu-eit-star-size': '1em' } },
    { id: 'selection', group: 'Brand cues', name: 'Text selection', kind: 'choice', def: 'gold',
      opts: [['gold', 'Goldfinch'], ['crimson', 'Crimson'], ['gray', 'Gray']],
      hint: 'Highlight color when a visitor selects text.', pv: EX_SELECT,
      vars: function (v) { return { gold: { '--wsu-eit-select-bg': '#f3e700', '--wsu-eit-select-fg': '#262626' }, crimson: { '--wsu-eit-select-bg': '#a60f2d', '--wsu-eit-select-fg': '#ffffff' }, gray: { '--wsu-eit-select-bg': '#d9d9d9', '--wsu-eit-select-fg': '#262626' } }[v]; },
      off: { '--wsu-eit-select-bg': 'Highlight', '--wsu-eit-select-fg': 'HighlightText' } },
    { id: 'topbarrule', group: 'Brand cues', name: 'Topbar hairline', kind: 'range', min: 0, max: 10, def: 4, unit: 'px',
      hint: 'The thin crimson rule across the very top of every page.', pv: EX_TOPBAR,
      vars: function (v) { return { '--wsu-eit-topbar-rule': v + 'px' }; }, off: { '--wsu-eit-topbar-rule': '0' } },

    /* ── PAGE ── */
    { id: 'col', group: 'Page', name: 'Content width', kind: 'range', min: 56, max: 96, def: 75, unit: 'rem',
      fmt: function (v) { return (v * 16) + 'px'; },
      hint: 'The centered white column. Shipped: 1200px. Off = full-bleed.', pv: EX_COL,
      vars: function (v) { return { '--wsu-eit-col': v + 'rem' }; }, off: { '--wsu-eit-col': 'none' } },
    { id: 'pagepad', group: 'Page', name: 'Content padding', kind: 'range', min: 0.5, max: 4, def: 2.5, step: 0.25,
      fmt: function (v) { return v + 'rem'; },
      hint: 'Breathing room above and below the content column.', pv: EX_PAGEPAD,
      vars: function (v) { return { '--wsu-eit-page-pad': v + 'rem' }; }, off: { '--wsu-eit-page-pad': '.5rem' } },
    { id: 'paper', group: 'Page', name: 'Content paper', kind: 'choice', def: '#ffffff',
      opts: [['#ffffff', 'White'], ['#fcfbf7', 'Warm white'], ['#f7f7f7', 'Mist']],
      hint: 'Background of the content column itself.', pv: EX_WASH,
      vars: function (v) { return { '--wsu-eit-paper': v }; }, off: { '--wsu-eit-paper': '#ffffff' } },
    { id: 'wash', group: 'Page', name: 'Page backdrop', kind: 'choice', def: '#f5f5f5',
      opts: [['#f5f5f5', 'Light gray'], ['#ffffff', 'White'], ['#eff0f1', 'Cool gray']],
      hint: 'The area outside the content column. Off = no backdrop (white).', pv: EX_WASH,
      vars: function (v) { return { '--wsu-eit-wash': v }; }, off: { '--wsu-eit-wash': '#ffffff' } }
  ];

  var KEY = 'wsu-eit-tune-v1';   /* our key only — never touch other storage */
  var state = {};
  try { state = JSON.parse(localStorage.getItem(KEY) || '{}') || {}; } catch (e) { state = {}; }
  state.off = state.off || {};   /* per-feature On/Off disable flags */

  function val(s) { return (s.id in state) ? state[s.id] : s.def; }
  function isOff(s) { return !!(state.off && state.off[s.id]); }
  /* the value a token falls back to when its feature is switched Off */
  function offPrimary(s) { var om = s.off || {}, k = Object.keys(om); return k.length ? om[k[0]] : null; }
  function offDisplay(s) { var v = offPrimary(s); if (v == null) return 'default'; if (s.kind === 'choice' && s.opts) { for (var i = 0; i < s.opts.length; i++) if (String(s.opts[i][0]) === String(v)) return s.opts[i][1]; } return String(v); }
  function specById(id) { for (var i = 0; i < SPEC.length; i++) if (SPEC[i].id === id) return SPEC[i]; return null; }
  function updateBars() {
    var cS = specById('col'), mS = specById('measure');
    var cBar = document.getElementById('tpv-col-bar');
    if (cBar && cS) cBar.style.width = isOff(cS) ? '100%' : Math.round(val(cS) / cS.max * 100) + '%';
    var mBar = document.getElementById('tpv-measure');
    if (mBar && mS) mBar.style.width = isOff(mS) ? '100%' : Math.round(val(mS) / mS.max * 100) + '%';
  }

  /* dependent-range clamps: keep H3 strictly below H2 so a subheading can
     never outsize its parent heading. WSU's own web type scale always has
     h3 < h2 (h2 2.1rem / h3 1.8rem per the WDS scale in 001_wsu_brand_reference.md),
     so this enforces real brand hierarchy, not just a nicety. Generalised via
     each spec's optional dynMax(). */
  function reconcile() {
    SPEC.forEach(function (s) {
      if (s.kind !== 'range' || typeof s.dynMax !== 'function') return;
      var cap = s.dynMax();
      var input = document.getElementById('ti-' + s.id);
      var maxLbl = document.getElementById('tmax-' + s.id);
      if (cap == null || isNaN(cap)) {
        if (input) input.max = s.max;
        if (maxLbl) { maxLbl.textContent = fmt(s, s.max); maxLbl.classList.remove('tune-scale--capped'); }
        return;
      }
      cap = Math.min(cap, s.max);
      if (input) input.max = cap;
      if (maxLbl) {
        var capped = cap < s.max;
        maxLbl.textContent = fmt(s, cap) + (capped ? ' · ≤H2' : '');
        maxLbl.classList.toggle('tune-scale--capped', capped);
      }
      if (val(s) > cap) {
        state[s.id] = +cap.toFixed(4);
        if (String(state[s.id]) === String(s.def)) delete state[s.id];
      }
    });
  }
  function fmt(s, v) { return s.fmt ? s.fmt(v) : (s.kind === 'range' ? v + s.unit : labelOf(s, v)); }
  function labelOf(s, v) {
    if (!s.opts) return String(v);
    for (var i = 0; i < s.opts.length; i++) if (String(s.opts[i][0]) === String(v)) return s.opts[i][1];
    return String(v);
  }

  function applyAll() {
    SPEC.forEach(function (s) {
      var k;
      if (isOff(s)) {                       /* feature disabled → push its OFF map */
        var om = s.off || {};
        for (k in om) root.style.setProperty(k, om[k]);
        return;
      }
      var map = s.vars(val(s)), atDef = String(val(s)) === String(s.def);
      for (k in map) {
        if (atDef) root.style.removeProperty(k);
        else root.style.setProperty(k, map[k]);
      }
    });
    renderExport();
  }

  function save() { try { localStorage.setItem(KEY, JSON.stringify(state)); } catch (e) {} }

  /* export: ONLY the deviations from shipped defaults, each annotated —
     this block is the meeting's deliverable */
  function renderExport() {
    var out = [], code = document.getElementById('tune-export-code');
    SPEC.forEach(function (s) {
      var k, first = true;
      if (isOff(s)) {                       /* disabled features export their OFF map */
        var om = s.off || {};
        for (k in om) { out.push('  ' + k + ': ' + om[k] + ';' + (first ? '   /* ' + s.name + ': OFF (shipped: ' + fmt(s, s.def) + ') */' : '')); first = false; }
        return;
      }
      var v = val(s);
      if (String(v) === String(s.def)) return;
      var map = s.vars(v);
      for (k in map) {
        out.push('  ' + k + ': ' + map[k] + ';' + (first ? '   /* ' + s.name + ': ' + fmt(s, v) + ' (shipped: ' + fmt(s, s.def) + ') */' : ''));
        first = false;
      }
    });
    code.textContent = out.length
      ? '/* WSU EIT kit — tuned via the showcase Tune tab */\n:root {\n' + out.join('\n') + '\n}'
      : '/* All values are shipped defaults — nothing to export. */';
  }

  /* group order for the card layout */
  var GROUPS = ['Type', 'Shape & density', 'Brand cues', 'Page'];

  /* build the controls as grouped cards. Each card pairs a control with a
     LIVE EXAMPLE that consumes the very token it drives — so you see exactly
     what moves before committing it to the export, instead of hunting for the
     effect somewhere down the page. */
  function buildCard(s) {
    var card = document.createElement('div');
    card.className = 'tune-card';
    var nameId = 'tn-' + s.id, valId = 'tv-' + s.id, swId = 'sw-' + s.id;

    /* header: name · live value · On/Off switch */
    var head = document.createElement('div');
    head.className = 'tune-card__head';
    head.innerHTML = '<span class="tune-name" id="' + nameId + '">' + s.name
      + ' <span class="tune-val" id="' + valId + '"></span></span>'
      + '<button type="button" class="tune-toggle" id="' + swId + '" role="switch" aria-checked="true" aria-label="Enable ' + s.name + '"><span class="tune-toggle__dot"></span><span class="tune-toggle__txt">On</span></button>';

    var body = document.createElement('div');
    body.className = 'tune-card__body';
    var ctl = document.createElement('div');
    ctl.className = 'tune-card__ctl';

    if (s.kind === 'range') {
      var step = s.step || 1;
      ctl.innerHTML = '<input type="range" id="ti-' + s.id + '" min="' + s.min + '" max="' + s.max + '" step="' + step + '" aria-labelledby="' + nameId + '">'
        + '<div class="tune-scale"><span>' + fmt(s, s.min) + '</span><span id="tmax-' + s.id + '">' + fmt(s, s.max) + '</span></div>'
        + '<p class="tune-hint">' + s.hint + '</p>';
      var input = ctl.querySelector('input');
      input.value = val(s);
      input.addEventListener('input', function () {
        var num = step < 1 ? +(Math.round(parseFloat(input.value) / step) * step).toFixed(4) : parseInt(input.value, 10);
        state[s.id] = num;
        if (String(num) === String(s.def)) delete state[s.id];
        reconcile();
        syncUI();
        applyAll(); save();
      });
    } else {
      ctl.innerHTML = '<div class="tune-opts" role="group" aria-labelledby="' + nameId + '"></div>'
        + '<p class="tune-hint">' + s.hint + '</p>';
      var row = ctl.querySelector('.tune-opts');
      s.opts.forEach(function (o) {
        var b = document.createElement('button');
        b.type = 'button'; b.className = 'tunechip'; b.textContent = o[1];
        b.setAttribute('data-v', o[0]);
        b.addEventListener('click', function () {
          state[s.id] = o[0];
          if (String(o[0]) === String(s.def)) delete state[s.id];
          syncUI(); applyAll(); save();
        });
        row.appendChild(b);
      });
    }

    var pv = document.createElement('div');
    pv.className = 'tune-card__pv';
    pv.innerHTML = '<span class="tune-pv-tag">Live example</span>' + s.pv;

    body.appendChild(ctl);
    body.appendChild(pv);
    card.appendChild(head);
    card.appendChild(body);

    head.querySelector('.tune-toggle').addEventListener('click', function () {
      if (state.off[s.id]) delete state.off[s.id]; else state.off[s.id] = true;
      syncUI(); applyAll(); save();
    });
    return card;
  }

  GROUPS.forEach(function (g) {
    var inGroup = SPEC.filter(function (s) { return s.group === g; });
    if (!inGroup.length) return;
    var sec = document.createElement('section');
    sec.className = 'tune-group';
    var h = document.createElement('h3');
    h.className = 'tune-group__h';
    h.textContent = g;
    sec.appendChild(h);
    var grid = document.createElement('div');
    grid.className = 'tune-grid';
    inGroup.forEach(function (s) { grid.appendChild(buildCard(s)); });
    sec.appendChild(grid);
    host.appendChild(sec);
  });

  function syncUI() {
    SPEC.forEach(function (s) {
      var v = val(s), off = isOff(s);
      var readout = document.getElementById('tv-' + s.id);
      if (readout) readout.textContent = off ? offDisplay(s) : fmt(s, v);
      var nameEl = document.getElementById('tn-' + s.id);
      var card = nameEl ? nameEl.closest('.tune-card') : null;
      if (card) card.classList.toggle('tune-card--off', off);
      var sw = document.getElementById('sw-' + s.id);
      if (sw) { sw.setAttribute('aria-checked', String(!off)); sw.querySelector('.tune-toggle__txt').textContent = off ? 'Off' : 'On'; }
      if (s.kind === 'range') {
        var input = document.getElementById('ti-' + s.id);
        if (input) { var ov = off ? parseFloat(offPrimary(s)) : NaN; input.value = (off && !isNaN(ov)) ? ov : v; input.disabled = off; }
      } else if (card) {
        card.querySelectorAll('.tunechip').forEach(function (b) {
          b.setAttribute('aria-pressed', String(String(b.getAttribute('data-v')) === String(off ? offPrimary(s) : v)));
          b.disabled = off;
        });
      }
    });
    updateBars();
  }

  document.getElementById('tune-random').addEventListener('click', function () {
    state.off = {};   /* enable every feature, then roll values */
    SPEC.forEach(function (s) {
      if (s.kind === 'range') {
        var step = s.step || 1;
        var n = Math.round((s.max - s.min) / step);
        var v = s.min + Math.round(Math.random() * n) * step;
        state[s.id] = step < 1 ? +v.toFixed(4) : v;
      } else {
        state[s.id] = s.opts[Math.floor(Math.random() * s.opts.length)][0];
      }
      if (String(state[s.id]) === String(s.def)) delete state[s.id];
    });
    reconcile(); syncUI(); applyAll(); save();
  });
  document.getElementById('tune-reset').addEventListener('click', function () {
    state = {}; state.off = {};
    reconcile(); syncUI(); applyAll(); save();
  });
  document.getElementById('tune-export-copy').addEventListener('click', function () {
    var btn = this;
    navigator.clipboard.writeText(document.getElementById('tune-export-code').textContent).then(
      function () { btn.textContent = 'Copied!'; setTimeout(function () { btn.textContent = 'Copy override block'; }, 1400); },
      function () { btn.textContent = 'Copy blocked'; setTimeout(function () { btn.textContent = 'Copy override block'; }, 1400); });
  });

  reconcile(); syncUI(); applyAll();
})();
