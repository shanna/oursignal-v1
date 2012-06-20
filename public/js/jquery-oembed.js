;(function ($) {
  var providers = {};

  function find (url) {
    var site = url.match(/^https?:\/\/([^/]+)/)[1];
    for (var domain in providers)
      if (site.indexOf(domain) > -1)
        return providers[domain];
  }

  function provider (name, domains, endpoint) {
    $.each(domains, function () {
      providers[this] = {name: name, endpoint: endpoint};
    });
  }

  function get (url, success) {
    var provider = find(url);
    if (!provider) return;
    // TODO: Chrome blocks http endpoints on https.
    // TODO: jsoncallback is for flickr.
    $.getJSON('http://' + provider.endpoint + '?callback=?&format=json', {url: url}, success);
  }

  // $.oembed.provider(...); to add your own.
  provider('instagram', ['instagr.am'], 'api.instagram.com/oembed');
  provider('vimeo',     ['vimeo.com'],  'api/oembed.json');

  // e.g. A local oembed json to jsonp gateway.
  // provider('youtube', ['youtube.com', 'youtu.be'], window.document.location.host + '/oembed')

  $.oembed = {get: get, provider: provider};
})(jQuery);
