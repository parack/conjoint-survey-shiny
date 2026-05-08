// ── Block back-button navigation ─────────────────────────────────────────────
history.pushState(null, null, location.href);
window.addEventListener('popstate', function() {
  history.pushState(null, null, location.href);
});

// ══════════════════════════════════════════════════════════════════════════════
// Progressive state persistence via localStorage
// Survives browser tab suspension, screen lock, and Shiny reconnections.
//
// Flow:
//   First visit  → persistStateInit writes {resp_id, design, audio_order}
//   Each answer  → _persist() merges the change into localStorage
//   Reconnect    → shiny:connected reads state and sends to R (__restored_state__)
//   Completion   → clearSavedState wipes localStorage
// ══════════════════════════════════════════════════════════════════════════════
var _STATE_KEY = 'cbc_survey_v1';

function _persist(updates) {
  try {
    var s = JSON.parse(localStorage.getItem(_STATE_KEY) || '{}');
    for (var k in updates) { if (updates.hasOwnProperty(k)) s[k] = updates[k]; }
    localStorage.setItem(_STATE_KEY, JSON.stringify(s));
  } catch(e) {}
}
function _getState() {
  try { return JSON.parse(localStorage.getItem(_STATE_KEY) || '{}'); }
  catch(e) { return {}; }
}
function _clearState() {
  try { localStorage.removeItem(_STATE_KEY); } catch(e) {}
}

// ── Warn on refresh / tab-close ───────────────────────────────────────────────
// Active only after Inizia (surveyStarted). Disabled on completion.
var _warnOnLeave = false;
window.addEventListener('beforeunload', function(e) {
  if (!_warnOnLeave) return;
  e.preventDefault();
  e.returnValue = '';
  return '';
});

Shiny.addCustomMessageHandler('surveyStarted', function(msg) { _warnOnLeave = true;  });
Shiny.addCustomMessageHandler('surveyComplete', function(msg) { _warnOnLeave = false; });

// ── R → JS: incremental state update ─────────────────────────────────────────
Shiny.addCustomMessageHandler('persistState', function(data) {
  _persist(data);
});

// ── R → JS: session init — writes only if no prior session exists ──────────────
// Prevents a reconnecting user's saved resp_id/design/audio_order being
// overwritten by the new session's freshly generated values.
Shiny.addCustomMessageHandler('persistStateInit', function(data) {
  var s = _getState();
  if (!s.resp_id) {
    // First visit: save server-generated identifiers
    _persist(data);
  }
  // On reconnect: state already exists → ignore init; R will read it via __restored_state__
});

// ── R → JS: clear all saved state (called on survey completion) ───────────────
Shiny.addCustomMessageHandler('clearSavedState', function(msg) {
  _clearState();
});

// ── JS → R: on (re)connect, send saved state so R can restore the session ─────
$(document).on('shiny:connected', function() {
  var s = _getState();
  if (s.resp_id) {
    Shiny.setInputValue('__restored_state__', JSON.stringify(s), {priority: 'event'});
  }
});

// ── Audio: pause all clips except the one currently playing ──────────────────
document.addEventListener('play', function(e) {
  document.querySelectorAll('audio').forEach(function(a) {
    if (a !== e.target) { a.pause(); a.currentTime = 0; }
  });
}, true);

// ── CBC card selection ────────────────────────────────────────────────────────
$(document).on('click', '.cbc-card', function() {
  var choice = $(this).data('choice');
  var task   = $(this).data('task');
  $(this).closest('.cbc-cards').find('.cbc-card').removeClass('cbc-card-selected');
  $(this).addClass('cbc-card-selected');
  Shiny.setInputValue('cbc_choice_' + task, String(choice), {priority: 'event'});
  // Save CBC choice progressively
  var s = _getState();
  s.cbc_choices = s.cbc_choices || {};
  s.cbc_choices['t' + task] = parseInt(choice, 10);
  _persist({cbc_choices: s.cbc_choices});
});

// ── Consent state tracker (iOS Safari-safe) ───────────────────────────────────
var _consentOK = false;
$(document).on('click', '#consent_check', function() {
  _consentOK = this.checked;
  Shiny.setInputValue('consent_check', this.checked, {priority: 'event'});
});

// ── Validation flash ──────────────────────────────────────────────────────────
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
    // dsp_user is a Shiny radioButtons widget (form-check-input), not btn-check
    if (!document.querySelector('input[name="dsp_user"]:checked')) {
      flashInvalid(document.getElementById('dsp_user'));
      ok = false;
    }
  }
  return ok;
}

// ── Navigation button handler (spinner + validation gate) ─────────────────────
$(document).on('click', 'button[id^="btn_"]', function() {
  var btn = $(this);
  if (btn.prop('disabled')) return false;
  // Gate: intro requires consent
  if (this.id === 'btn_intro_next') {
    var cb = document.getElementById('consent_check');
    if (!_consentOK && !(cb && cb.checked)) {
      flashInvalid(document.querySelector('.consent-check-row'));
      return false;
    }
    Shiny.setInputValue('consent_check', true, {priority: 'event'});
  }
  if (!validatePage(this.id)) return false;
  // Stop all audio when leaving the audio page
  if (this.id === 'btn_audio_next') {
    document.querySelectorAll('audio').forEach(function(a) { a.pause(); a.currentTime = 0; });
  }
  btn.prop('disabled', true);
  var orig = btn.html();
  btn.attr('data-orig-html', orig);
  btn.empty().append($('<span>').addClass('spinner-border spinner-border-sm me-1').attr('role', 'status'));
  setTimeout(function() {
    btn.prop('disabled', false).html(btn.attr('data-orig-html') || orig);
  }, 10000);
});

// ── btn-check inputs: Shiny value + UI feedback + progressive save ─────────────
$(document).on('change', 'input.btn-check', function() {
  var nm  = $(this).attr('name');
  var val = $(this).val();
  Shiny.setInputValue(nm, val);
  // Audio card feedback
  var card = $(this).closest('.audio-clip-card');
  if (card.length) { card.addClass('clip-rated'); card.find('.clip-rated-badge').show(); }
  // GAAIS / proxy item feedback
  var item = $(this).closest('.gaais-item');
  if (item.length) item.addClass('item-answered');
  // Progressive save
  var s = _getState();
  s.answers = s.answers || {};
  s.answers[nm] = val;
  _persist({answers: s.answers});
});

// ── Native radio (dsp_user): save progressively ───────────────────────────────
$(document).on('change', 'input[name="dsp_user"]', function() {
  var s = _getState();
  s.answers = s.answers || {};
  s.answers['dsp_user'] = $(this).val();
  _persist({answers: s.answers});
});

// ── Select inputs: save progressively ────────────────────────────────────────
$(document).on('change', '.form-select', function() {
  var nm = $(this).attr('id');
  if (!nm) return;
  var s = _getState();
  s.answers = s.answers || {};
  s.answers[nm] = $(this).val();
  _persist({answers: s.answers});
});

// ── Image popup on click/tap (custom, no Bootstrap dep) ──────────────────────
$(document).on('click', '.btn-popover-img', function(e) {
  e.stopPropagation();
  var $btn    = $(this);
  var src     = $btn.attr('data-img');
  var wasOpen = $btn.hasClass('pop-open');
  $('.img-popup-box').remove();
  $('.btn-popover-img').removeClass('pop-open');
  if (wasOpen) return;
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
