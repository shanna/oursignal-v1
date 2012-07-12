/*
 * brokenImage: a jQuery plugin
 *
 * brokenImage is a jQuery plugin that is able to detect and replace images
 * that are either broken or are taking a long time to load.  The default
 * replacement is a transparent GIF (no extra image file required).  The
 * replacement image and the timeout for slow-loading images are configurable.
 *
 * For usage and examples, visit:
 * http://github.com/alexrabarts/jquery-brokenimage/tree/master
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2008 Stateless Systems (http://statelesssystems.com)
 *
 * @author   Alex Rabarts (alexrabarts -at- gmail -dawt- com)
 * @requires jQuery v1.2 or later
 * @version  0.2
 */

(function ($) {
  $.extend($.fn, {
    brokenImage: function (options) {
      var defaults = {
        timeout: 5000
      };

      options = $.extend(defaults, options);

      return this.each(function () {
        // Replace the image with a placeholder if:
        // a. loading fails with an error event or;
        // b. loading takes longer than timeout
        var image = this;

        $(image).bind('error', function () {
          insertPlaceholder();
        });

        setTimeout(function () {
          var test = new Image(); // Virgin image with no styles to affect dimensions
          test.src = image.src;

          if (test.height === 0) {
            insertPlaceholder();
          }
        }, options.timeout);

        function insertPlaceholder() {
          options.replacement ? image.src = options.replacement : $(image).css({visibility: 'hidden'});
        }
      });
    }
  });
})(jQuery);
