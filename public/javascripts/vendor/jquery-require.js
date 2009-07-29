/*
 * require: Load javascript on demand.
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2009 Stateless Systems (http://statelesssystems.com)
 *
 * @author   Shane Hanna (shane.hanna -at- gmail -dawt- com)
 * @requires jQuery v1.3 or later
 * @version  0.2
 */
(function ($) {
  $.extend($, {
    require : function (urls, options) {
      var defaults = {cache: true};
      options      = $.extend(defaults, options);

      if (!$.require.loaded) $.require.loaded = [];
      if (!$.isArray(urls))  urls = [urls];

      $.each(urls, function (index, url) {
        var load = $.inArray(url, $.require.loaded) !== -1;
        if (!(options.cache && load)) {
          $.ajax({
            url:      url,
            dataType: 'script',
            async:    false,
            success:  function (js) { if (jQuery.browser.safari) eval(js);}
          });
          if (!load) $.require.loaded.push(url);
        }
      });
    }
  });
})(jQuery);
