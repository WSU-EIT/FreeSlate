/* ============================================================================
   WSU CAROUSEL — wsu-carousel.js
   Accessible, dependency-free carousel. Auto-inits every .wsuf-carousel.
   In Slate: add this to the form's Edit Scripts, or a /path/default.js.

   Accessibility: labelled slides, real prev/next/dot buttons, arrow-key support,
   play/pause control, pauses on hover/focus, and never auto-plays under
   prefers-reduced-motion. The viewport is a polite live region so slide changes
   are announced.
   ============================================================================ */
(function () {
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function initCarousel(root) {
    var track = root.querySelector('.wsuf-carousel__track');
    var slides = Array.prototype.slice.call(root.querySelectorAll('.wsuf-carousel__slide'));
    if (!track || !slides.length) return;
    var prev = root.querySelector('.wsuf-carousel__btn--prev');
    var next = root.querySelector('.wsuf-carousel__btn--next');
    var dotsWrap = root.querySelector('.wsuf-carousel__dots');
    var playBtn = root.querySelector('.wsuf-carousel__play');
    var index = 0, timer = null, playing = false;
    var interval = parseInt(root.getAttribute('data-interval'), 10) || 5000;

    // Label slides
    slides.forEach(function (s, i) {
      s.setAttribute('role', 'group');
      s.setAttribute('aria-roledescription', 'slide');
      s.setAttribute('aria-label', (i + 1) + ' of ' + slides.length);
    });

    // Build dots
    var dots = [];
    if (dotsWrap) {
      slides.forEach(function (s, i) {
        var b = document.createElement('button');
        b.type = 'button';
        b.className = 'wsuf-carousel__dot';
        b.setAttribute('aria-label', 'Go to slide ' + (i + 1));
        b.addEventListener('click', function () { goTo(i, true); });
        dotsWrap.appendChild(b);
        dots.push(b);
      });
    }

    function goTo(i, focusTrack) {
      index = (i + slides.length) % slides.length;
      track.style.transform = 'translateX(-' + (index * 100) + '%)';
      slides.forEach(function (s, n) { s.setAttribute('aria-hidden', n === index ? 'false' : 'true'); });
      dots.forEach(function (d, n) { d.setAttribute('aria-current', n === index ? 'true' : 'false'); });
      if (focusTrack) track.setAttribute('tabindex', '-1');
    }

    function stop() {
      playing = false; if (timer) { clearInterval(timer); timer = null; }
      if (playBtn) { playBtn.setAttribute('aria-pressed', 'false'); playBtn.querySelector('.wsuf-carousel__play-label').textContent = 'Play'; }
    }
    function start() {
      if (reduce) return;
      playing = true; timer = setInterval(function () { goTo(index + 1); }, interval);
      if (playBtn) { playBtn.setAttribute('aria-pressed', 'true'); playBtn.querySelector('.wsuf-carousel__play-label').textContent = 'Pause'; }
    }

    if (prev) prev.addEventListener('click', function () { goTo(index - 1); });
    if (next) next.addEventListener('click', function () { goTo(index + 1); });
    if (playBtn) playBtn.addEventListener('click', function () { playing ? stop() : start(); });

    // Pause on hover / focus within
    root.addEventListener('mouseenter', function () { if (playing) { clearInterval(timer); timer = null; } });
    root.addEventListener('mouseleave', function () { if (playing && !timer) timer = setInterval(function () { goTo(index + 1); }, interval); });
    root.addEventListener('focusin', function () { if (playing) { clearInterval(timer); timer = null; } });
    root.addEventListener('focusout', function () { if (playing && !timer && !root.contains(document.activeElement)) timer = setInterval(function () { goTo(index + 1); }, interval); });

    // Arrow keys when focus is inside the carousel
    root.addEventListener('keydown', function (e) {
      if (e.key === 'ArrowLeft') { goTo(index - 1); e.preventDefault(); }
      else if (e.key === 'ArrowRight') { goTo(index + 1); e.preventDefault(); }
    });

    goTo(0);
    if (root.hasAttribute('data-autoplay') && !reduce) start();
  }

  document.querySelectorAll('.wsuf-carousel').forEach(initCarousel);
})();
