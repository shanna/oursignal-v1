(function ($) {
  $(document).ready(function () {
    var strategies     = $('#strategies');
    var select         = $('<select />');

    strategies.find('form').each(function (i, strategy) {
      if (!(match = $(strategy).attr('id').match(/strategies-(\w+)/))) return;
      var option = $('<option />').attr('value', match[0]).append(match[1]);
      select.append(option);
    });

    $('#authentication').prepend(select);
    select.change(function () {
      strategies.children().hide();
      $('#' + select.val()).show();
    });
    select.change();
  });
})(jQuery);
