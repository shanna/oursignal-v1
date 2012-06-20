;(function ($) {
  var providers = {};

  function find (url) {
    var site = url.match(/^https?:\/\/([^/]+)/)[1];
    for (var domain in providers)
      if (site.indexOf(domain) > -1)
        return providers[domain];
  }

  function provider (name, domain, generate) {
    providers[domain] = {name: name, generate: generate};
  }

  function get (url, success) {
    var provider = find(url);
    if (provider) provider.generate(url, success);
    else if ($.oembed && $.oembed.get) $.oembed.get(url, success);
  }

  function param (url, name) {
    var results = new RegExp('[\\?&]' + name + '=([^&#]+)').exec(url);
    if (!results) { return 0; }
    return results[1] || 0;
  }

  provider('youtube', 'youtube.com', function (url, success) {
    var id = param(url, 'v');
    if (id) success({type: 'video', url: 'http://i3.ytimg.com/vi/' + id + '/hqdefault.jpg'});
  });
  provider('youtube', 'youtu.be', function (url, success) {
    var match = url.match(/youtu\.be\/([a-z0-9]{11})/i);
    if (match) success({type: 'video', url: 'http://i4.ytimg.com/vi/' + match[1] + '/hqdefault.jpg'});
  });
  provider('twitpic', 'twitpic.com', function (url, success) {
    var match = url.match(/twitpic\.com\/([^/?]+)\/?$/i);
    if (match) success({type: 'photo', url: 'http://twitpic.com/show/large/' + match[1]});
  });
  provider('twitter', 'twitter.com', function (url, success) {
    var match = url.match(/twitter\.com.*\/status\/([^/?]+)\/photo\/([^/?]+)\/?/);
    if (match)
      $.getJSON('https://api.twitter.com/1/statuses/show.json?callback=?&include_entities=true', {id: match[1]}, function (json) {
        var position = parseInt(match[2]) - 1 || 0;
        if (json.entities && json.entities.media && json.entities.media[position])
          success({type: 'photo', url: json.entities.media[position].media_url});
      });
  });

  $.embed = {get: get, provider: provider};
})(jQuery);
