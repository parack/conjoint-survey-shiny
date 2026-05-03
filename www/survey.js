// ── Block back-button navigation ─────────────────────────────────────────────
history.pushState(null, null, location.href);
window.addEventListener('popstate', function() {
  history.pushState(null, null, location.href);
});

// ── Warn on refresh / tab-close ───────────────────────────────────────────────
// Active only after the user clicks 'Inizia' (surveyStarted message).
// Disabled again when submission is complete (surveyComplete message).
var _warnOnLeave = false;
window.addEventListener('beforeunload', function(e) {
  if (!_warnOnLeave) return;
  e.preventDefault();
  e.returnValue = '';
  return '';
});
Shiny.addCustomMessageHandler('surveyStarted', function(msg) {
  _warnOnLeave = true;
});
Shiny.addCustomMessageHandler('surveyComplete', function(msg) {
  _warnOnLeave = false;
});

document.addEventListener('play', function(e) {
  document.querySelectorAll('audio').forEach(function(a) {
    if (a !== e.target) { a.pause(); a.currentTime = 0; }
  });
}, true);

$(document).on('click', '.cbc-card', function() {
  var choice = $(this).data('choice');
  var task   = $(this).data('task');
  $(this).closest('.cbc-cards').find('.cbc-card').removeClass('cbc-card-selected');
  $(this).addClass('cbc-card-selected');
  Shiny.setInputValue('cbc_choice_' + task, String(choice), {priority: 'event'});
});

// Consent state tracker — updated via click (not change) for iOS Safari
var _consentOK = false;
$(document).on('click', '#consent_check', function() {
  _consentOK = this.checked;
  Shiny.setInputValue('consent_check', this.checked, {priority: 'event'});
});

function flashInvalid(el) {
  if (!el) return;
  el.style.outline = '2px solid #dc3545';
  el.style.borderRadius = '4px';
  setTimeout(function() { el.style.outline = ''; el.style.borderRadius = ''; }, 1500);
}

function validatePage(btnId) {
  var ok = true;
  if (btnId === 'btn_audio_next') {
    [1,2,3,4].forEach(function(i) {
      if (!document.querySelector('input[name="audio_rating_' + i + '"]:checked')) {
        flashInvalid(document.querySelectorAll('.audio-clip-card')[i-1]);
        ok = false;
      }
    });
  } else if (btnId === 'btn_gaais_next') {
    document.querySelectorAll('#page_gaais .gaais-item').forEach(function(item) {
      if (!item.querySelector('input.btn-check:checked')) { flashInvalid(item); ok = false; }
    });
  } else if (btnId === 'btn_cbc_next') {
    if (!document.querySelector('.cbc-card-selected')) {
      flashInvalid(document.querySelector('.cbc-cards'));
      ok = false;
    }
  } else if (btnId === 'btn_proxy_next') {
    document.querySelectorAll('#page_proxy .gaais-item').forEach(function(item) {
      if (!item.querySelector('input.btn-check:checked')) { flashInvalid(item); ok = false; }
    });
    var churn = document.querySelector('#page_proxy .churn-section');
    if (churn && !churn.querySelector('input.btn-check:checked')) { flashInvalid(churn); ok = false; }
    // Validate dsp_user radio (Shiny radioButtons uses form-check-input, not btn-check)
    if (!document.querySelector('input[name="dsp_user"]:checked')) {
      flashInvalid(document.getElementById('dsp_user'));
      ok = false;
    }
  }
  return ok;
}

$(document).on('click', 'button[id^="btn_"]', function() {
  var btn = $(this);
  if (btn.prop('disabled')) return false;
  // Gate: intro button requires consent (checked via _consentOK, Safari-safe)
  if (this.id === 'btn_intro_next') {
    var cb = document.getElementById('consent_check');
    if (!_consentOK && !(cb && cb.checked)) {
      flashInvalid(document.querySelector('.consent-check-row'));
      return false;
    }
    Shiny.setInputValue('consent_check', true, {priority: 'event'});
  }
  // Gate: validate required page inputs before showing spinner
  if (!validatePage(this.id)) return false;
  // Stop all audio players when leaving the audio section
  if (this.id === 'btn_audio_next') {
    document.querySelectorAll('audio').forEach(function(a) {
      a.pause(); a.currentTime = 0;
    });
  }
  btn.prop('disabled', true);
  var orig = btn.html();
  btn.attr('data-orig-html', orig);
  btn.empty().append(
    $('<span>').addClass('spinner-border spinner-border-sm me-1').attr('role', 'status')
  );
  setTimeout(function() {
    btn.prop('disabled', false).html(btn.attr('data-orig-html') || orig);
  }, 10000);
});

$(document).on('change', 'input.btn-check', function() {
  Shiny.setInputValue($(this).attr('name'), $(this).val());
  var card = $(this).closest('.audio-clip-card');
  if (card.length) {
    card.addClass('clip-rated');
    card.find('.clip-rated-badge').show();
  }
  var item = $(this).closest('.gaais-item');
  if (item.length) item.addClass('item-answered');
});

// ── Image popup on click/tap (custom lightweight, no Bootstrap dep) ───────────
$(document).on('click', '.btn-popover-img', function(e) {
  e.stopPropagation();
  var $btn = $(this);
  var src  = $btn.attr('data-img');
  var wasOpen = $btn.hasClass('pop-open');
  // close any open popup
  $('.img-popup-box').remove();
  $('.btn-popover-img').removeClass('pop-open');
  if (wasOpen) return;  // toggle off
  $btn.addClass('pop-open');
  var $box = $('<div class="img-popup-box"><img src="' + src + '" alt=""></div>');
  $('body').append($box);
  var rect = this.getBoundingClientRect();
  var st   = window.scrollY  || document.documentElement.scrollTop;
  var sl   = window.scrollX  || document.documentElement.scrollLeft;
  var bw   = $box.outerWidth();
  var left = Math.max(8, Math.min(rect.left + sl, window.innerWidth + sl - bw - 12));
  $box.css({ top: (rect.bottom + st + 6) + 'px', left: left + 'px' });
});
$(document).on('click', function(e) {
  if (!$(e.target).closest('.btn-popover-img, .img-popup-box').length) {
    $('.img-popup-box').remove();
    $('.btn-popover-img').removeClass('pop-open');
  }
});
