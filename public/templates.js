(function() {
  var _ref;

  if ((_ref = this.Templates) == null) {
    this.Templates = {};
  }

  this.Templates['meta'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      if (this.sources) {
        console.warn(this.sources);
      }
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
