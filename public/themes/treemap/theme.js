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

        var colour = '222222';
        if (vel < 1)   colour = "D67404";
        if (vel < 0.95) colour = "C95D05";
        if (vel < 0.9)  colour = "BB4707";
        if (vel < 0.85) colour = "AE3708";
        if (vel < 0.8)  colour = "A1290A";
        if (vel < 0.75) colour = "94200C";
        if (vel < 0.7)  colour = "86190F";
        if (vel < 0.65) colour = "771411";
        if (vel < 0.6)  colour = "691514";
        if (vel < 0.55) colour = "5F1616";
        if (vel < 0.5)  colour = "581717";
        if (vel < 0.45) colour = "521818";
        if (vel < 0.4)  colour = "4B1A1A";
        if (vel < 0.35) colour = "451B1B";
        if (vel < 0.3)  colour = "3F1C1C";
        if (vel < 0.25) colour = "381E1E";
        if (vel < 0.2)  colour = "311F1F";
        if (vel < 0.15) colour = "2B2020";
        if (vel < 0.1)  colour = "252121";

        if (vel < 0)  colour = "222222";

        if (vel < -0.1)  colour = "222529";
        if (vel < -0.15) colour = "22272D";
        if (vel < -0.2)  colour = "222931";
        if (vel < -0.25) colour = "222A35";
        if (vel < -0.3)  colour = "222C39";
        if (vel < -0.35) colour = "222E3D";
        if (vel < -0.4)  colour = "223042";
        if (vel < -0.45) colour = "223246";
        if (vel < -0.5)  colour = "22334A";
        if (vel < -0.55) colour = "213551";
        if (vel < -0.6)  colour = "20385D";
        if (vel < -0.65) colour = "213E68";
        if (vel < -0.7)  colour = "254673";
        if (vel < -0.75) colour = "284F7E";
        if (vel < -0.8)  colour = "2E5B8A";
        if (vel < -0.85) colour = "356996";
        if (vel < -0.9)  colour = "3E7AA3";
        if (vel < -0.95) colour = "488DB0";
        if (vel < -1)    colour = "53A0BC";

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
        $.fn.visualize.links = $.map(links, function (link) {
          var velocity = $('<div class="velocity" />').append(link.velocity);
          var meta     = $('<div class="meta" style="display: none;" />').append(velocity);
          var anchor   = $('<a />').attr({href: link.url}).append(link.title);
          return [$('<span />').append(meta, anchor), parseFloat(link.score) * 100];
        });
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

