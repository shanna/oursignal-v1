// Oursignal.
$.getJSON('/timestep.json', function(links) {
  $(function() {
    var $timestep = $('#timestep');
    $.each(links, function(index, link) {
      $timestep.append($('<li/>', {'data-score': link.score}).append($('<a/>', {href: link.url, text: link.title})));
    });
  });
});
