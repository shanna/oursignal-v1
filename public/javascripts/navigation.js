(function ($) {
  // Redirect to users custom feed.
  if ($.url.attr('path') == '/' && $.cookie('username')) {
    var to = '/' + $.cookie('username');
    document.write('<body><div id="head" class="navBar"><div class="container_12"><div class="grid_12"><a class="logo" href="/" title="OurSignal | Home">Home</a><div class="navigation"><h3>Loading Oursignal...</h3></div></div></div></div></body>');
    document.location = to;
    return;
  }

  // Builds navigation to suit $.username() cache.
  $(document).ready(function () {
    var username = $.username();
    if (!username) return;

    // Feed links.
    var base = [
      $.url.attr('protocol'), '://', $.url.attr('host'),
      ($.url.attr('port') ? ':' + $.url.attr('port') : ''),
      '/', username
    ].join('');
    $('#developer_rss').attr('href', base + '.rss');
    $('#developer_xml').attr('href', base + '.xml');
    $('#developer_json').attr('href', base + '.json');
    $('#developer_html').attr('href', base + '/');

    // Logout, Customize
    var el_options = $('#head .navigation .options');
    var el_logout  = $('<a />').attr('href', '/users/' + username + '/logout').append('Log out ');
    el_options.find('.customize a').attr('href', '/users/' + username + '/edit');
    el_options.prepend($('<li />').attr('class', 'logout').append(el_logout));

    // Username
    var el_username = $('<a />').attr({href: '/' + username + '/', 'class': 'username'}).append('YourSignal');
    var el_user     = $('<li />').attr('class', 'user').append(el_username);
    el_options.prepend(el_user);

    // Heading
    $('#head #logo .logo').attr('href', base);
  });
})(jQuery);
