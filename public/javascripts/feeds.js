// TODO: Cleanup this mess.
(function ($) {
  $.extend($.fn, {
    feed: function () {
      $('#feed_url').focus();
      $('#feed_add').click(create);
      $('#feed').submit(create);
      $.getJSON('/users/' + $.os.user.username + '/feeds', index);
    }
  });

  function index(json) {
    if (!($.isArray(json) && json.length)) return;
    var scores = $('#scores');

    for (var i = 0; i < json.length; i++) {
      var url   = $('<input />').attr({readonly: 'readonly', type: 'text', value: json[i].url});
      var score = $('<li>').append(on_load(), url);
      on_success(score, json[i]);
      scores.append(score);
    }
  }

  function create() {
    var scores = $('#scores');
    var feed   = $('#feed_url');
    var url    = $('<input />').addClass("scores_url").attr({readonly: 'readonly', type: 'text', value: feed.val()});
    var score  = $('<li />').append(on_load(), url).hide();
    scores.append(score);

    $.ajax({
      type:     'POST',
      url:      '/users/' + $.os.user.username + '/feeds',
      data:     {url: feed.attr('value')},
      dataType: 'json',
      error:    function(request, status, error) { on_error(score, request)},
      success:  function(response) {
        on_success(score, response);
        $('#links').visualize({cache: false});
        redraw_ratios();
      }
    });

    feed.attr('value', '').focus();
    score.slideDown('slow');
    return false;
  }

  function on_load() {
    return $('<div class="load"><img src="/i/ajax-loader.gif" /></div>');
  }

  // TODO: Unified exceptions, growl style?
  function on_error(score, request) {
    var json = eval(request.responseText);
    if (json) {
      for (var i = 0; i < json.length; i++) {
        var ex = $('<div class="error" />').append(json[i]);
        score.find('.load').replaceWith(ex);
        score.animate({opacity: 100}, 5000).slideUp('slow', function() {score.remove()});
      }
    }
    else {
      // TODO: Unknown exception.
    }
  }

  function on_success(score, json) {
    var destroy_el = $('<input class="delete" value="delete" type="button" />').click(function () {
      $.post('/users/' + $.os.user.username + '/feeds/' + json.feed_id, {_method: 'delete'}, function () {
        $('#links').visualize({cache: false});
        redraw_ratios();
      }, 'json');
      $(this).closest('li').remove();
    });

    var score_el = $('<div class="score" />').slider({value: json.score, min: 0, max: 1, step: 0.01, stop: function (e, ui) {
      $.post('/users/' + $.os.user.username + '/feeds/' + json.feed_id, {score: ui.value, _method: 'put'}, function () {
        $('#links').visualize({cache: false});
        redraw_ratios();
      }, 'json');
    }});

    var ratio_el   = $('<div class="ratio" />').append((json.ratio || '0') + '%');
    var control_el = $('<div class="control" />').append(score_el, ratio_el, destroy_el);
    score.find('.load').replaceWith(control_el);
  }

  function redraw_ratios() {
    $.getJSON('/users/' + $.os.user.username + '/feeds', function (json) {
      if (!($.isArray(json) && json.length)) return;
      var scores = $('#scores li');
      $.each(json, function (i, s) {
        $(scores.get(i)).find('.ratio').text(s.ratio + '%');
      });
    });
  }

  $(document).ready(function () {
    $('#feeds').feed();
  });
})(jQuery);

