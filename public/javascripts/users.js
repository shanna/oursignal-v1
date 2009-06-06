/*
  TODO: I really I have no idea what good jquery looks like or how people lay it out.
  TODO: Modularize as fn.site.controller?
*/
(function ($) {
  // TODO: fn.oursignal.users ?
  $.extend($.fn, {
    feed: function () {
      $('#feed_url').focus();
      $('#feed_add').click(add);
      $('#feed').submit(add);
    }
  });

  function add() {
    // TODO: Post #feed_url return {:url => 'http://...', :score => '50'}
    var url = $('#feed_url');
    score({score: 50, url: url.attr('value')});
    url.attr('value', '').focus();
    return false;
  }

  function score(json) {
    var li = $('<li />').append(control(json.score), feed(json.url)).hide();
    $('#scores').prepend(li);
    li.slideDown('slow');
  }

  function feed(url) {
    return url;
  }

  function control(score) {
    return $('<div class="control" />').append(slider(score));
  }

  function slider(score) {
    return $('<div class="score" />').slider({value: score, stop: function (e, ui) {
      // TODO: Post user_id, feed_url and feed_score.
    }});
  }

  $(document).ready(function () {
    $('#feeds').feed();
  });
})(jQuery);

