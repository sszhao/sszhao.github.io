(function () {
  'use strict';

  var toggle = document.querySelector('.site-nav__toggle');
  var menu = document.querySelector('.site-nav__links');

  if (!toggle || !menu) return;

  toggle.addEventListener('click', function () {
    var open = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!open));
    menu.classList.toggle('is-open');
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && menu.classList.contains('is-open')) {
      toggle.setAttribute('aria-expanded', 'false');
      menu.classList.remove('is-open');
      toggle.focus();
    }
  });

  menu.querySelectorAll('.site-nav__link').forEach(function (link) {
    link.addEventListener('click', function () {
      if (window.innerWidth <= 768) {
        toggle.setAttribute('aria-expanded', 'false');
        menu.classList.remove('is-open');
      }
    });
  });
})();
