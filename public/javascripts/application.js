(function ($) {
  $.os = {};

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

  // TODO: Namespace everything?
  $.extend($, {
    // Last authorized username.
    // Used client side to build URL's so we can cache feed links without the need for ESI.
    username: function () {
      return $.cookie('username');
    },

    // Fetch links for feed.
    // TODO: Switch to $.username();
    links: function (options) {
      var defaults = {cache: true};
      options      = $.extend(defaults, options);

      if (!(options.cache && $.os.links)) {
        $.ajax({
          type:     'GET',
          url:      '/' + $.os.user.username,
          dataType: 'json',
          async:    false,
          cache:    options.cache,
          success:  function (json) { $.os.links = json;}
        });
      }
      return $.os.links;
    }
  });

  $(document).ready(function () {
    $('#notice').notice();
  });
})(jQuery);
