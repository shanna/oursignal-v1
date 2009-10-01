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
      var score = $('<li>').append(on_load(), json[i].url);
      on_success(score, json[i]);
      scores.append(score);
    }
  }

  function create() {
    var scores = $('#scores');
    var feed   = $('#feed_url');
    var url    = feed.attr('value');
    var score  = $('<li />').append(on_load(), url).hide();
    scores.append(score);

    $.ajax({
      type:     'POST',
      url:      '/users/' + $.os.user.username + '/feeds',
      data:     {url: url},
      dataType: 'json',
      error:    function(request, status, error) { on_error(score, request)},
      success:  function(response) {
        on_success(score, response);
        $('#links').visualize({cache: false});
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
    var destroy = $('<input class="delete" value="delete" type="button" />').click(function () {
      $.post('/users/' + $.os.user.username + '/feeds/' + json.feed_id, {_method: 'delete'}, function () {
        $('#links').visualize({cache: false});
      }, 'json');
      $(this).closest('li').remove();
    });

    var update = $('<div class="score" />').slider({value: json.score, min: 0, max: 1, step: 0.01, stop: function (e, ui) {
      $.post('feeds/' + json.feed_id, {score: ui.value, _method: 'put'}, function () {
        $('#links').visualize({cache: false});
      }, 'json');
    }});

    score.find('.load').replaceWith($('<div class="control" />').append(update, destroy));
  }

  $(document).ready(function () {
    $('#feeds').feed();
  });
})(jQuery);

