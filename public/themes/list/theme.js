(function ($) {
  $.extend($.fn, {
    outer: function () {
      return $('<div>').append(this.eq(0).clone()).html();
    },

    visualize: function (options) {
      var defaults = {cache: true};
      options = $.extend(defaults, options);

      return this.each(function () {
        var ul    = $('<ul />');
        var links = $(this);
        links.children().remove();
        links.append(ul);

        var data = $.links(options);
        $.each(data, function (i, link) {
          var sources = [];
          $.each(link.referrers, function (k, v) {
            sources.push($('<a />').attr({href: v}).append(k).outer());
          });

          var score    = $('<div class="score" />').append(link.score);
          var velocity = $('<div class="velocity" />').append('velocity: ' + link.velocity);
          var domains  = $('<div class="source" />').append('source: ' + sources.join(', '));
          var meta     = $('<div class="meta" />').append(score, velocity, domains);
          var anchor   = $('<a />').attr({href: link.url, target: $.target()}).append(link.title);
          ul.append($('<li />').append(anchor, meta));
        });
      });
    }
  });

  $(document).ready(function () {
    $('#links').visualize();
  });
})(jQuery);
