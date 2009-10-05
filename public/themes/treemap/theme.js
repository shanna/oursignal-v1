(function ($) {
  $.require([
    '/themes/treemap/jquery-treemap.js',
    '/themes/treemap/jquery-textfill.js',
    '/themes/treemap/jquery-simpletip.js'
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
        links.find('div.treemapCell span').link_context().textfill({max: 50}).velocity().tooltip();
      });
    },

    link_context: function () {
      return this.each(function () {
        var el = $(this);
        if (el.data('link')) el.context.link = el.data('link');
      });
    },

    velocity: function () {
      return this.each(function () {
        var el  = $(this);
        var vel = parseFloat(el.context.link.velocity);

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
    },

    tooltip: function () {
      return this.each(function () {
        var el = $(this);
        el.parent().simpletip({
          offset:       [20, 20],
          content:      '',
          fixed:        false,
          onBeforeShow: function () {
            if (this.getTooltip().text() == '') {
              var link       = el.context.link;
              var title      = $('<div class="title" />').append(link.title);
              var screenshot = $('<div class="screenshot" />').append($('<img />').attr({
                width:  '120',
                height: '90',
                src:    'http://open.thumbshots.org/image.aspx?url=' + escape(link.url)
              }));
              var url        = $('<div class="url" />').append('url: ' + link.url);
              var score      = $('<div class="score" />').append('score: ' + link.score);
              var velocity   = $('<div class="velocity" />').append('velocity: ' + link.velocity);
              var domains    = $('<div class="domains" />').append('via: ' + (link.domains || []).join(', '));
              var meta       = $('<div class="meta" />').append(title, screenshot, url, score, velocity, domains);
              this.update(meta);
            }
          }
        });
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
          var anchor   = $('<a />').attr({href: link.url, title: ''}).append(link.title);
          var el       = $('<span />').append(anchor).data('link', link);
          // el.context.link = link;
          // console.warn(el.context);
          $.fn.visualize.links.push([el, parseFloat(link.score) * 100]);
        };
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

