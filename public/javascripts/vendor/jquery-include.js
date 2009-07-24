(function ($) {
  $.extend($, {
    include : function (url) {
      $.ajax({
        url:      url,
        dataType: 'script',
        async:    false,
        success:  function (js) { if (jQuery.browser.safari) eval(js);}
      });
    }
  });
})(jQuery);
