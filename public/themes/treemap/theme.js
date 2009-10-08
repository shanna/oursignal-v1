/*
 * Tipsy.
 *
 * - Removed gravity code. Always gravitate towards center of screen.
 * - Removed all the extra whitespace.
 * - Added tip callback.
 * - Added sane variable naming.
 *
 * Original:
 * http://plugins.jquery.com/project/tipsy
 * The MIT License
 * Copyright (c) 2008 Jason Frame (jason@onehackoranother.com)
 */
(function($) {
  $.fn.tipsy = function(opts) {
    opts = $.extend({fade: false}, opts || {});
    var tip = null, cancelHide = false;

    this.hover(function() {
      $.data(this, 'cancel.tipsy', true);

      var tip = $.data(this, 'active.tipsy');
      if (!tip) {
        //var title = opts.tip ? opts.tip().html() : $(this).attr('title');
        //tip = $('<div class="tipsy"><div class="tipsy-inner">' + title + '</div></div>');
        var inner = $('<div class="tipsy-inner">').append(opts.tip ? opts.tip() : $(this).attr('title'));
        tip = $('<div class="tipsy">').append(inner);
        tip.css({position: 'absolute', zIndex: 100000});
        $(this).attr('title', '');
        $.data(this, 'active.tipsy', tip);
      }

      var pos = $.extend({}, $(this).offset(), {width: this.offsetWidth, height: this.offsetHeight});
      tip.remove().css({top: 0, left: 0, visibility: 'hidden', display: 'block'}).appendTo(document.body);
      var actualWidth = tip[0].offsetWidth, actualHeight = tip[0].offsetHeight;

      // TODO: Brutal. Clean this up later.
      var half_width  = $(window).width() / 2;
      var half_height = $(window).height() / 2;
      if (pos.top < half_height) {
        tip.css({top: pos.top})
        if (pos.left < half_width) tip.css({left: pos.left + pos.width}).addClass('tipsy-nw');
        else tip.css({left: pos.left - actualWidth}).addClass('tipsy-ne');
      }
      else {
        tip.css({top: pos.top - (actualHeight - pos.height)})
        if (pos.left < half_width) tip.css({left: pos.left + pos.width}).addClass('tipsy-sw');
        else tip.css({left: pos.left - actualWidth}).addClass('tipsy-se');
      }

      if (opts.fade) {
        tip.css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: 1});
      } else {
        tip.css({visibility: 'visible'});
      }
    }, function() {
      $.data(this, 'cancel.tipsy', false);
      var self = this;
      setTimeout(function() {
        if ($.data(this, 'cancel.tipsy')) return;
        var tip = $.data(self, 'active.tipsy');
        if (opts.fade) {
          tip.stop().fadeOut(function() { $(this).remove(); });
        } else {
          tip.remove();
        }
      }, 100);
    });
  };
})(jQuery);

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
        links.find('div.treemapCell span').link_context().textfill({max: 50}).velocity().tooltip();
      });
    },

    mouse_position: function () {
      return $.fn.visualize.mouse_position;
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
        if (vel < 1)   colour = "ff453f";
        if (vel < 0.9)  colour = "ff5c58";
        if (vel < 0.8)  colour = "ff7672";
        if (vel < 0.7)  colour = "ff9491";
        if (vel < 0.6)  colour = "303030";

        if (vel < -0.6)  colour = "b3d6ff";
        if (vel < -0.7)  colour = "8cc1ff";
        if (vel < -0.8)  colour = "64abff";
        if (vel < -0.9)  colour = "3e96ff";

        el.parent().css('background-color', '#' + colour);
      });
    },

    tooltip: function () {
      return this.each(function () {
        var el = $(this);
        el.parent().tipsy({
          tip: function () {
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
            return meta;
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
          $.fn.visualize.links.push([el, parseFloat(link.score) * 100]);
        };
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

