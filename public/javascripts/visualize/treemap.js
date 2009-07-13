(function ($) {
  $.extend($.fn, {
    visualize: function () {
      this.children().remove();
      this.treemap($(window).width(), $(window).height() - 100, {getData: data});
      this.find('div.treemapCell span').textfill({max: 50});
      return this;
    }
  });

  $(document).ready(function () {
    $('#links').visualize();
  });

  $(window).resize(function () {
    $('#links').visualize();
  });

  function data() {
    var data = [];
    $(links).each(function (index, link) {
      var anchor = $('<a />').attr({href: link.url}).append(link.title);
      data.push([$('<span />').append(anchor), 70.0]); // parseFloat(link.score)]);
    });
    return data;
  }
})(jQuery);
