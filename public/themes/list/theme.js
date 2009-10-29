(function ($) {
  $.extend($.fn, {
    visualize: function (options) {
      var defaults = {cache: true};
      options = $.extend(defaults, options);

      return this.each(function () {
        var ul     = $('<ul />');
        var links  = $(this);
        links.children().remove();
        links.append(ul);

        var data = $.links(options);
        for (var i = 0; i < data.length; i++) {
          var link     = data[i];
          var score    = $('<div class="score" />').append('score: ' + link.score);
          var velocity = $('<div class="velocity" />').append('velocity: ' + link.velocity);

          var sources    = [];
          $.each(link.referrers, function (k, v) {
            sources.push($('<div />').append($('<a />').attr({href: v}).append(k)).html());
          });
          var domains  = $('<div class="domains" />').append('source: ' + sources.join(', '));
          var meta     = $('<div class="meta" />').append(score, velocity, domains);
          var anchor   = $('<a />').attr({href: link.url, target: $.target()}).append(link.title);
          ul.append($('<li />').append(anchor, meta));
        }
      });
    }
  });

  $(document).ready(function () {
    $('#links').visualize();
  });
})(jQuery);
