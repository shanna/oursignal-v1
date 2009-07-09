// Global JS.

(function ($) {
  // TODO: Replace with growl type notifications plugin.
  $.extend($.fn, {
    notice: function (options) {
      var defaults = {delay: 5000};
      options = $.extend(defaults, options);

      return this.each(function () {
        $(this).animate({opacity: 100}, options.delay).slideUp('slow', this.remove);
      });
    }
  });

  $(document).ready(function () {
    $('#notice').notice();
  });
})(jQuery);
