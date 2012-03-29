/*
  Oursignal
*/
var oursignal = (function ($, oursignal) {
  var $timestep, $timeline, $meta;

  /*
    Timestep
      Most of squarify(), worst() and position() nicked from the d3 library.
      http://mbostock.github.com/d3/
  */
  oursignal.timestep = (function (timestep) {
    var timestep_offset,
        other_controls_height,
        links,
        links_length,
        round = Math.round,
        ratio = 0.5 * (1 + Math.sqrt(5)); // Golden ratio.

    function worst(row, u) {
      var s    = row.area,
          r,
          rmax = 0,
          rmin = Infinity,
          i    = -1,
          n    = row.length;

      while (++i < n) {
        if (!(r = row[i].area)) continue;
        if (r < rmin) rmin = r;
        if (r > rmax) rmax = r;
      }
      s *= s;
      u *= u;
      return s
          ? Math.max((u * rmax * ratio) / s, s / (u * rmin * ratio))
          : Infinity;
    }

    function position(row, u, rect, flush) {
      var i = -1,
          n = row.length,
          x = rect.x,
          y = rect.y,
          v = u ? round(row.area / u) : 0,
          o;

      if (u == rect.dx) { // horizontal subdivision
        if (flush || v > rect.dy) v = v ? rect.dy : 0; // over+underflow
        while (++i < n) {
          o = row[i];
          o.x = x;
          o.y = y;
          o.dy = v;
          x += o.dx = v ? round(o.area / v) : 0;
        }
        o.z = true;
        o.dx += rect.x + rect.dx - x; // rounding error
        rect.y += v;
        rect.dy -= v;
      } else { // vertical subdivision
        if (flush || v > rect.dx) v = v ? rect.dx : 0; // over+underflow
        while (++i < n) {
          o = row[i];
          o.x = x;
          o.y = y;
          o.dx = v;
          y += o.dy = v ? round(o.area / v) : 0;
        }
        o.z = false;
        o.dy += rect.y + rect.dy - y; // rounding error
        rect.x += v;
        rect.dx -= v;
      }
    }

    function squarify() {
      var rect     = {x: links.x, y: links.y, dx: links.dx, dy: links.dy},
          row      = [],
          children = links.slice(), // Copy.
          child,
          best     = Infinity,
          score,
          u        = Math.min(rect.dx, rect.dy),
          n;

      row.area = 0;
      while ((n = children.length) > 0) {
        row.push(child = children[n - 1]);
        row.area += child.area;
        if ((score = worst(row, u)) <= best) {
          children.pop();
          best = score;
        }
        else {
          row.area   -= row.pop().area;
          position(row, u, rect, false);
          u          = Math.min(rect.dx, rect.dy);
          row.length = row.area = 0;
          best       = Infinity;
        }
      }
      if (row.length) {
        position(row, u, rect, true);
        row.length = row.area = 0;
      }
    }

    function meta(event) {
      var $event = $(event.target.cible[0]).parent();
console.warn($event);
console.warn($event.data());
      // TODO: Replace with template.

    }

    // TODO: Animation. Do it intersection style so existing ID's remain and morph?
    function layout() {
      var link,
          $link,
          $entry;

      $timestep.children().remove();
      for (var i = links_length; i > 0; i--) {
        link   = links[i - 1];
        $entry = $('<div/>', {'class': 'entry'}).append($('<a/>', {href: link.url, text: link.title}));
        $link  = $('<li/>', {'data-link_id': link.id, 'data-link_score': link.score})
          .data(link)
          .css({left: link.x, top: link.y, width: link.dx, height: link.dy})
          .append($entry);
        $timestep.append($link);

        // TODO: Issues:
        // * You can't textfill till the element is added to the DOM.
        // * Experiment with document fragment to avoid flash of unstyled text.
        // * You need the 'entry' div container inside the li to get the current implementation of textfill to work.
        $entry.textfill({max: 50});

        $entry.hoverintent(meta, function () {}, {group: true});
      }
    }

    function scale() {
      var area;

      if (!timestep_offset)       timestep_offset = $timestep.offset();
      if (!other_controls_height) other_controls_height = $timeline.height() + $meta.height();

      // Root.
      links.x  = timestep_offset.left;
      links.y  = timestep_offset.top;
      links.dx = Math.min($(window).width(), $(document).width());
      links.dy = Math.min($(window).height(), $(document).height()) - timestep_offset.top - other_controls_height;
      $timestep.width(links.dx).height(links.dy);

      // Children.
      for (var i = 0; i < links_length; i++) {
        area = (links[i].score * (links.dx * links.dy / links.score));
        links[i].area = isNaN(area) || area <= 0 ? 0 : area;
      }
    }

    function treemap(data) {
      links        = data.reverse(); // Is already sorted.
      links_length = data.length;
      links.score  = 0;

      for (var i = 0; i < links_length; i++) links.score += links[i].score;

      $(window).resize(function () {
        scale();
        squarify();
        layout();
      }).resize();
    }

    timestep.update = function (time) {
      $.getJSON('/timestep.json', {time: time}, function (links) {
        $(function () { treemap(links); });
      });
    };

    return timestep;
  })(oursignal.timestep || {});

  /*
    Timeline
  */
  oursignal.timeline = (function (timeline) {
    // TODO: Golf, document fragment, minimise appends etc.
    function generate(time) {
      var now  = new Date(),
          date = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0, 0),
          $day = $('<li/>', {class: 'day'}); // TODO: 'data-time': at midnight.
      for (var hour = 0; hour < 24; hour++) {
        date.setHours(hour);
        var $hour = $('<ol/>', {class: 'hour', 'data-hour': hour}); // TODO: 'data-time' at the hour.
        for (var minute = 0; minute < 60; minute += 5) {
          var $minute = $('<li/>', {class: 'minute', 'data-minute': minute}); // TODO: 'data-time' at the minute.
          if (minute == 0) {
            var $time = $('<abbr/>', {
              class: 'datetime',
              title: date.toString(),
              text:  (hour > 11 ? (hour > 12 ? hour - 12 : hour) + 'pm' : (hour == 0 ? 12 : hour) + 'am')
            });
            $minute.append($time);
          }
          $hour.append($minute);
        }
        $day.append($hour);
      }
      $timeline.append($day);

      $timeline.mousedown(function (event) {
        $(this)
          .data('down', true)
          .data('x', event.clientX)
          .data('scrollLeft', this.scrollLeft);

        return false;
      }).mouseup(function (event) {
        $(this).data('down', false);
      }).mousemove(function (event) {
        if ($(this).data('down') == true) {
          this.scrollLeft = $(this).data('scrollLeft') + $(this).data('x') - event.clientX;
        }
      })
      // .mousewheel(function (event, delta) { this.scrollLeft -= (delta * 30); })
      .css({
        'overflow' : 'hidden',
        'cursor' : '-moz-grab'
      });
    }

    timeline.update = function (time) {
      $(function () { generate(time || new Date()); });
    };

    return timeline;
  })(oursignal.timeline || {});

  // Display current timestep and timeline.
  oursignal.now = function () {
    oursignal.timestep.update();
    oursignal.timeline.update();
  };

  $(function () {
    $timestep = $('#timestep');
    $timeline = $('#timeline');
    $meta     = $('#meta');
  });

  return oursignal;
})(jQuery, oursignal || {});

oursignal.now();
