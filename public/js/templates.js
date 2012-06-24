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
      var $c, $e, $o, $p, domain, score, site, url, _ref2, _ref3;
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
      $p = function(text) {
        return text.replace(/\n/g, '&#x000A;');
      };
      $o = [];
      $o.push("<header>\n  <h1>\n    <a href='" + ($e($c(this.url))) + "' target='_blank'>" + ($e($c(this.title))) + "</a>\n  </h1>\n</header>\n<div class='screenshot'>\n  <img src='screenshots/" + this.id + ".png' title='" + ($e($c(this.title))) + "' width='336' height='216'>\n</div>\n<aside>\n  <h2>\n    <a href='http://" + this.domain + "' target='_blank'>" + ($e($c(this.domain))) + "</a>\n  </h2>\n  <abbr class='retrieved_at' title='" + ($e($c(this.retrieved_at))) + "'>\n  <time datetime='" + ($e($c(this.retrieved_at))) + "'>" + ($p($e($c(this.retrieved_at)))) + "</time>\n  </abbr>\n  <table class='sources'>\n    <caption>Sources</caption>\n    <tbody>");
      _ref2 = this.sources;
      for (domain in _ref2) {
        url = _ref2[domain];
        $o.push("      <tr>\n        <td>\n          <a href='" + ($e($c(url))) + "' target='_blank'>" + ($e($c(domain))) + "</a>\n        </td>\n      </tr>");
      }
      $o.push("    </tbody>\n  </table>\n  <table class='scores'>\n    <caption>Scores</caption>\n    <tbody>");
      _ref3 = this.scores;
      for (site in _ref3) {
        score = _ref3[site];
        $o.push("      <tr>\n        <td class='site'>" + ($p($e($c(site)))) + "</td>\n        <td class='score'>" + ($p($e($c(parseInt(score))))) + "</td>\n      </tr>");
      }
      $o.push("    </tbody>\n  </table>\n</aside>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '').replace(/[\s\n]*\u0091/mg, '').replace(/\u0092[\s\n]*/mg, '');
    }).call(context);
  };

}).call(this);
