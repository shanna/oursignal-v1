// TODO: Cleanup this mess.
(function ($) {
  $.extend($.fn, {
    feed: function () {
      $('#feed_url').focus();
      $('#feed_add').click(create);
      $('#feed').submit(create);
      $.getJSON('feeds', index);
    }
  });

  function index(json) {
    if (!($.isArray(json) && json.length)) return;
    var scores = $('#scores');
    json.map(function (feed) {scores.prepend(control(feed))});
  }

  function create() {
    var data = {url: $('#feed_url').attr('value')};
    $.ajax({type: 'POST', url: 'feeds', data: data, dataType: 'json', error: exception, success: show});
    return false;
  }

  function show(json) {
    var li = control(json).hide();
    $('#scores').prepend(li);
    li.slideDown('slow');
    $('#feed_url').attr('value', '').focus();
    $('#links').visualize({cache: false});
  }

  // TODO: Unified exceptions, growl style?
  function exception(request, status, error) {
    var json = eval(request.responseText);
    if (json) {
      json.map(function (message) {
        var ex = $('<div class="exception" />').append(message);
        $('#feeds').prepend(ex);
        // TODO: ex.remove causes errors in jquery.
        ex.animate({opacity: 100}, 2500).slideUp('slow'); // , ex.remove);
      });
    }
    else {
      // TODO: Unknown exception.
    }
  }

  function control(json) {
    var destroy = $('<input class="delete" value="delete" type="button" />').click(function () {
      $.post('feeds/' + json.feed_id, {_method: 'delete'}, function () {
        $('#links').visualize({cache: false});
      }, 'json');
      $(this).closest('li').remove();
    });

    var score = $('<div class="score" />').slider({value: json.score, min: 0, max: 1, step: 0.01, stop: function (e, ui) {
      $.post('feeds/' + json.feed_id, {score: ui.value, _method: 'put'}, function () {
        $('#links').visualize({cache: false});
      }, 'json');
    }});

    return $('<li />').append(
      $('<div class="control" />').append(score, destroy),
      json.url
    );
  }

  $(document).ready(function () {
    $('#feeds').feed();
  });
})(jQuery);

