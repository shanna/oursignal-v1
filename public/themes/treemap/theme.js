(function ($) {
  $.require([
    '/themes/treemap/jquery-treemap.js',
    '/themes/treemap/jquery-textfill.js'
  ]);

  $.extend($.fn, {
    visualize: function (options) {
      var defaults = {
        cache:  true,
        width:  Math.min($(window).width(), $(document).width()),
        height: Math.min($(window).height(), $(document).width()) - 43 // TODO: Ick. Hard coded head height.
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

        var colour = '303030';
        if (vel < 1)   colour = "eb433a";
        if (vel < 0.9)  colour = "f8674a";
        if (vel < 0.8)  colour = "f8764a";
        if (vel < 0.7)  colour = "f88c4a";
        if (vel < 0.6)  colour = "303030";

        if (vel < -0.6)  colour = "7cc0d9";
        if (vel < -0.7)  colour = "66abc4";
        if (vel < -0.8)  colour = "5395ad";
        if (vel < -0.9)  colour = "42788c";

        el.parent().css('background-color', '#' + colour);
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
        var links = $.os.links || $.links({cache: false});
        delete $.os.links;

        // No need to cache $.links since we are caching the link html.
        $.fn.visualize.links = []
        for (var i = 0; i < links.length; i++) {
          var link     = links[i];
          var velocity = $('<div class="velocity" />').append(link.velocity);
          var meta     = $('<div class="meta" />').append(velocity);
          var anchor   = $('<a />').attr({href: link.url, title: link.url}).append(link.title);
          var el       = $('<span />').append(meta, anchor);
          $.fn.visualize.links.push([el, parseFloat(link.score) * 100]);
        };
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

