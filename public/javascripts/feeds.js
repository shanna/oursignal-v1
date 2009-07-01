/*
  TODO: I really I have no idea what good jquery looks like or how people lay it out.
  TODO: Modularize as fn.site.controller?
*/
(function ($) {
  // TODO: fn.oursignal.users ?
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
      $.post('feeds', {url: json.url, _method: 'delete'}, null, 'json');
      $(this).closest('li').remove();
    });

    var score = $('<div class="score" />').slider({value: json.score, min: 0, max: 1, step: 0.01, stop: function (e, ui) {
      $.post('feeds', {url: json.url, score: ui.value, _method: 'put'}, null, 'json');
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

