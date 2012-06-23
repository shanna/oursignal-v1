(function() {
  var _base, _ref, _ref1;

  if ((_ref = this.oursignal) == null) {
    this.oursignal = {};
  }

  if ((_ref1 = (_base = this.oursignal).templates) == null) {
    _base.templates = {};
  }

  this.oursignal.templates['meta'] = function(context) {
    return (function() {
      var $c, $e, $o, domain, score, site, url, _ref2, _ref3;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&apos;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<h1>\n  <a href='" + ($e($c(this.url))) + "'>" + ($e($c(this.title))) + "</a>\n</h1>\n<h2>Site</h2>\n<a href='http://" + this.domain + "'>" + ($e($c(this.domain))) + "</a>\n<h2>Retrieved</h2>\n<time datetime='" + ($e($c(this.created_at))) + "'>" + ($e($c(this.created_at))) + "</time>\n<h2>Seen</h2>\n<time datetime='" + ($e($c(this.referred_at))) + "'>" + ($e($c(this.referred_at))) + "</time>\n<h2>Sources</h2>\n<ul>");
      _ref2 = this.sources;
      for (domain in _ref2) {
        url = _ref2[domain];
        $o.push("  <li>\n    <a href='" + ($e($c(url))) + "'>" + ($e($c(domain))) + "</a>\n  </li>");
      }
      $o.push("</ul>\n<h2>Scores</h2>\n<ul>");
      _ref3 = this.scores;
      for (site in _ref3) {
        score = _ref3[site];
        $o.push("  <li>");
        $o.push("    " + $e($c("" + site + ": " + (parseInt(score)))));
        $o.push("  </li>");
      }
      $o.push("</ul>");
      if (this.tags.length > 0) {
        $o.push("Tags\n<ul></ul>");
      }
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
