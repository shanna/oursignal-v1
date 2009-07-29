/*
 * textfill: Expand text to fill a container.
 *
 * Uses a binary search rather than the linear search found in:
 * * http://plugins.jquery.com/project/TextFill
 * * http://parkingstructure.displayawesome.com/resources/js/vertical.fill.js
 *
 * TODO: Take padding into account.
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2009 Stateless Systems (http://statelesssystems.com)
 *
 * @author   Shane Hanna (shane.hanna -at- gmail -dawt- com)
 * @requires jQuery v1.3 or later
 * @version  0.1
 */
(function ($) {
  $.extend($.fn, {
    textfill: function (options) {
      var defaults = {max: 50};
      options      = $.extend(defaults, options);

      return this.each(function () {
        var el     = $(this);
        var width  = el.parent().width();
        var height = el.parent().height();
        var low    = 0;
        var high   = options.max;

        while (low <= high) {
          var mid = Math.round(low + ((high - low) / 2));
          el.css('font-size', mid);

          if (el.height() > height || el.width() > width) { high = mid - 1; continue;}
          if (el.height() < height && el.width() <= width) { low  = mid + 1; continue;}
          break;
        }
        el.css('font-size', low - 1);
      });
    }
  });
})(jQuery);

