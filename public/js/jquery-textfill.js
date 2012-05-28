(function ($) {
  $.extend($.fn, {
    textfill: function (options) {
      var defaults = {max: 100};
      options      = $.extend(defaults, options);

      return this.each(function () {
        var el     = $(this),
            width  = el.parent().innerWidth(),
            height = el.parent().innerHeight(),
            low    = 1,
            mid    = 0,
            high   = options.max;

        while (low <= high) {
          mid = Math.floor((low + high) / 2);
          el.css('font-size', mid);

          if (el.height() < height && el.width() < width) { low = mid + 1 }
          else { high = mid - 1 }
        }

        el.css('font-size', mid - 1);
      });
    }
  });
})(jQuery);
