(function ($) {
  $.require([
    '/themes/treemap/jquery-treemap.js',
    '/themes/treemap/jquery-textfill.js'
  ]);

  $.extend($.fn, {
    visualize: function (options) {
      var defaults = {
        cache:  true,
        width:  $(window).width(),
        height: $(window).height()
      };
      options = $.extend(defaults, options);

      return this.each(function () {
        var links    = $(this);
        links.children().remove();
        links.treemap(options.width, options.height, {getData: data(options)});
        links.find('div.treemapCell span').textfill({max: 50}).velocity();
      });
    },

    velocity: function () {
      return this.each(function () {
        var el  = $(this);
        var vel = parseFloat(el.find('.meta .velocity').text());

        // TODO: Velocity colours.
        // el.parent().css('background-color', colour);
      });
    }
  });

  $(document).ready(function () {
    $('#links').visualize();
    $(window).resize(function () {
      $('#links').visualize();
    });
  });

  function data (options) {
    return function () {
      if (!(options.cache && $.fn.visualize.links)) {
        // No need to cache $.links since we are caching the link html.
        $.fn.visualize.links = $.links({cache: false}).map(function (link) {
          var velocity = $('<div class="velocity">').append(link.velocity);
          var meta     = $('<div class="meta" style="display: none;" />').append(velocity);
          var anchor   = $('<a />').attr({href: link.url}).append(link.title);
          return [$('<span />').append(meta, anchor), parseFloat(link.score) * 100];
        });
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

