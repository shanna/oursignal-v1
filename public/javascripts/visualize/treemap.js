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
      data.push([$('<span />').append(anchor), parseFloat(link.score) * 100]);
    });
    return data;
  }
})(jQuery);
