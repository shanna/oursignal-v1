(function ($) {
  // Redirect to users custom feed.
  if ($.url.attr('path') == '/' && $.cookie('username')) {
    var to = '/' + $.cookie('username');
    document.write('<body><div id="shell"><div id="head"><div id="logo"><h1><img src="/i/favicon.gif" alt="oursignal.com - news aggregation at it\'s finest" /><a href="' + to + '" title="Home">Loading your signal...</a></h1></div></div></div></body>');
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

    // Logout, Customize
    var el_options = $('#head .navigation .options');
    var el_logout  = $('<a />').attr('href', '/users/' + username + '/logout').append(username, ': ', 'Logout ');
    el_options.find('.customize a').attr('href', '/users/' + username + '/edit');
    el_options.prepend($('<li />').attr('class', 'logout').append(el_logout));

    // Username
    var el_username   = $('<a />').attr({href: '/' + username + '/', 'class': 'username'}).append(username);
    var el_user       = $('<li />').attr('class', 'user').append(el_username, ' &raquo; ');
    el_options.prepend(el_user);
  });
})(jQuery);
