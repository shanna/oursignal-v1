(function ($) {
  $.extend($.fn, {
    visualize: function (options) {
      var defaults = {cache: true};
      options = $.extend(defaults, options);

      return this.each(function () {
        var ul    = $('<ul />');
        var links = $(this);
        links.children().remove();
        links.append(ul);

        $.links(options).map(function (link) {
          var score    = $('<div class="score" />').append('score: ', link.score);
          var velocity = $('<div class="velocity" />').append('velocity: ', link.velocity);
          var domains  = $('<div class="domains" />').append('domains: ', (link.domains || []).join(', '));
          var meta     = $('<div class="meta" />').append(score, velocity, domains);
          var anchor   = $('<a />').attr({href: link.url}).append(link.title);
          ul.append($('<li />').append(anchor, meta));
        });
      });
    }
  });

  $(document).ready(function () {
    $('#links').visualize();
  });
})(jQuery);
