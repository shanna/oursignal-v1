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

  // Fetch links for a feed.
  $.extend($, {
    links: function (options) {
      var defaults = {cache: true};
      options      = $.extend(defaults, options);

      if (!(options.cache && $.links.data)) {
        // TODO: Basename the location.
        var url = document.location + '.json';
        $.ajax({type: 'GET', url: url, dataType: 'json', async: false, success: function (json) {
          $.links.data = json;
        }});
      }
      return $.links.data;
    }
  });

  $(document).ready(function () {
    $('#notice').notice();
  });
})(jQuery);
