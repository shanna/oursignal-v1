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

        var colour = '303030';
        if (vel < 1)   colour = "eb433a";
        if (vel < 0.8)  colour = "f8674a";
        if (vel < 0.6)  colour = "f8764a";
        if (vel < 0.4)  colour = "f88c4a";
        if (vel < 0.2)  colour = "ffb78b";

        if (vel < 0)  colour = "96d5eb";

        if (vel < -0.2)  colour = "7cc0d9";
        if (vel < -0.4)  colour = "66abc4";
        if (vel < -0.6)  colour = "5395ad";
        if (vel < -0.8)  colour = "42788c";

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
        $.fn.visualize.links = links.map(function (link) {
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

