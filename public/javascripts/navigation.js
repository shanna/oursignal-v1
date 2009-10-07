(function ($) {
  // Builds navigation to suit $.username() cache.
  $(document).ready(function () {
    var username = $.username();
    if (!username) return;

    // Redirect to users custom feed.
    if ($.url.attr('path') == '/') {
      return document.location = '/' + username;
    }

    // Username
    var el_navigation = $('#head .navigation');
    var el_username   = $('<a />').attr({href: '/' + username + '/', 'class': 'username'}).append(username);
    var el_user       = $('<div />').attr({'class': 'user'}).append(el_username, ' &raquo; ');
    el_navigation.prepend(el_user);

    // Logout, Customize
    var el_options = el_navigation.children('.options');
    var el_logout  = $('<a />').attr({href: '/users/' + username + '/logout'}).append('logout');
    el_options.find('.customize a').attr({href: '/users/' + username + '/edit'});
    el_options.prepend($('<li />').attr({'class': 'logout'}).append(el_logout));
  });
})(jQuery);
