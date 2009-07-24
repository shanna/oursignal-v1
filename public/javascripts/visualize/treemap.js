(function ($) {
  $.extend($.fn, {
    visualize: function () {
      this.children().remove();
      this.treemap($(window).width(), $(window).height() - 100, {getData: data});
      this.find('div.treemapCell span').textfill({max: 50}).velocity();
      return this;
    },

    velocity: function () {
      return this.each(function () {
        var el  = $(this);
        var vel = parseFloat(el.find('.meta .velocity').text());

        // TODO: Velocity colours.
        // el.parent().css('background-color', colour);
      });
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
      var velocity = $('<div class="velocity">').append(link.velocity);
      var meta     = $('<div class="meta" style="display: none;" />').append(velocity);
      var anchor   = $('<a />').attr({href: link.url}).append(link.title);
      data.push([$('<span />').append(meta, anchor), parseFloat(link.score) * 100]);
    });
    return data;
  }
})(jQuery);
