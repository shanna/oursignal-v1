/*
 * textfill: Expand text to fill a container.
 *
 * Uses a binary search rather than the linear search found in:
 * * http://plugins.jquery.com/project/TextFill
 * * http://parkingstructure.displayawesome.com/resources/js/vertical.fill.js
 *
 * TODO: Take padding into account.
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2009 Stateless Systems (http://statelesssystems.com)
 *
 * @author   Shane Hanna (shane.hanna -at- gmail -dawt- com)
 * @requires jQuery v1.3 or later
 * @version  0.1
 */
(function ($) {
  $.extend($.fn, {
    textfill: function (options) {
      var defaults = {max: 100};
      options      = $.extend(defaults, options);

      return this.each(function () {
        var el     = $(this);
        var width  = el.parent().width();
        var height = el.parent().height();
        var low    = 0;
        var high   = options.max;

        while (low <= high) {
          var mid = Math.round(low + ((high - low) / 2));
          el.css('font-size', mid + 'px');

          if (el.height() > height || el.width() > width) { high = mid - 1; continue;}
          if (el.height() < height && el.width() <= width) { low  = mid + 1; continue;}
          break;
        }

        if ((low - 1) > 0) el.css('font-size', (low - 1) + 'px');
      });
    }
  });
})(jQuery);

/*
 * treemap: Squarified treemap.
 *
 * - Removed titles.
 * - Guy removed colouring.
 *
 * TODO: Replace with liquid treemap that'll scale itself to the parent element.
 * TODO: Before, after and value hooks.
 * TODO: No style code, that's what CSS is for.
 *
 * Treemap plugin for jQuery (version 1.0.2 27/2/2007)
 * Copyright (c) 2007 Renato Formato <renatoformato@virgilio.it>
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 */
(function($) {
  $.fn.treemap = function(w,h,options) {
    options = $.extend({labelCell:0,dataCell:1,colorCell:2,headHeight:20,borderWidth:1,sort:true,nested:false,legend:false},options);
    var or_target = options.target;
    return this.pushStack($.map(this,function(el){
      var data;
      if(!options.getData) {
        if(!$.nodeName(el,"table")) return; 
        data = treemap.getDataFromTable(el,options);
      } else {
        data = options.getData(el);
      }

      //copy data because during the processing elements are deleted
      data = data.concat();

      if($.fn.treemap.caller!=treemap.layoutRow) {
        options.minColorValue = Number.POSITIVE_INFINITY;
        options.maxColorValue = Number.NEGATIVE_INFINITY;
        if(!options.colorDiscreteVal) options.colorDiscreteVal = {num:0};
        treemap.normalizeValues(data,options);
        options.colorDiscrete = options.minColorValue == Number.POSITIVE_INFINITY;
        options.rangeColorValue = options.maxColorValue-options.minColorValue;
      }

      if (options.sort)
        data.sort(function(a,b){
          var val1 = b[1], val2 = a[1];
          val1 = val1.constructor==Array?treemap.getValue(val1):val1;
          val2 = val2.constructor==Array?treemap.getValue(val2):val2;
          return val1-val2;
        });

      options.target = or_target || el;
      options.numSquare = 0;

      treemap.render(data,h,w,options);

      if($.fn.treemap.caller!=treemap.layoutRow && options.legend) {
        jQuery(options.target).append(treemap.legend(h,options));
      }

      if(options.target==el && $.nodeName(el,"table")) {
        var newObj = jQuery(el).find(">").insertBefore(el);
        $(el).remove();
        el = newObj.get();
      }
      return el; 
    }));
  }

  $.fn.treemapClone = function() {
    return this.pushStack( jQuery.map( this, function(a){
      return a.outerHTML ? jQuery(a.outerHTML)[0] : a.cloneNode(true);
    })); 
  }

  $.fn.treemapAppend = function(arguments) {
    var el = this[0];
    for(var i=0,l=arguments.length;i<l;i++)
      el.appendChild(arguments[i]);
    return this; 
  }

  var treemap = {
     normalizeValues : function(data,options) {
      for(var i=0,dl=data.length;i<dl;i++)
        if(data[i][1].constructor==Array) 
          treemap.normalizeValues(data[i][1],options);
        else {
          var val = data[i][1] = parseFloat(data[i][1]);
          var color = data[i][2];
          if(color<options.minColorValue) options.minColorValue=color;
          if(color>options.maxColorValue) options.maxColorValue=color;
          if(!options.colorDiscreteVal[color]) options.colorDiscreteVal[color] = options.colorDiscreteVal.num++;
        }
    },

    getDataFromTable : function(table,options) {
      var data = [];
      if(options.labelCell==undefined) options.labelCell = options.dataCell;
      $("tbody tr",table).each(function(){
        var cells = $(">",this);
        var row = [cells.eq(options.labelCell).html(),
                   cells.eq(options.dataCell).html(),
                   cells.eq(options.colorCell).html()];
        data.push(row);
      });
      return data;
    }, 

    emptyView: $("<div>").addClass("treemapView"),

    render : function(data,h,w,options) {
      options.height = h;
      options.width = w;
      var s = treemap.calculateArea(data);
      options.viewAreaCoeff = w*h/s;
      options.view = treemap.emptyView.clone().css({'width':w,'height':h});
      options.content = []; 
      treemap.squarify(data,[],h,true,options);
      options.view.treemapAppend(options.content);
      $(options.target).empty().treemapAppend(options.view);
    },

    squarify : function(data,row,w,orientation,options) {
      if(w<=0) return; //exit if there's no space left on the treemap
      var widerRow = row,s,s2,current;
      do {
        row = widerRow; 
        s = treemap.calculateArea(row);
        if(data.length==0) return treemap.layoutRow(row,w,orientation,s,options,true);
        current = data.shift();
        widerRow = row.concat();
        widerRow.push(current);
        s2 = s+(current[1].constructor==Array?treemap.getValue(current[1]):current[1]);
      } while (treemap.worst(row,w,s,options.viewAreaCoeff)>=treemap.worst(widerRow,w,s2,options.viewAreaCoeff))    

      var rowDim = treemap.layoutRow(row,w,orientation,s,options);
      data.unshift(current);

      if(!rowDim) rowDim = treemap.layoutRow([['',s]],w,orientation,s,options,true);
      var width;
      if(orientation) {
        options.width -= rowDim;
        width = options.width;
      } else {
        options.height -= rowDim;
        width = options.height;
      }
      treemap.squarify(data,[],width,!orientation,options);
    },

    worst : function(row,w,s,coeff) {
      var rl = row.length;
      if(!rl) return Number.POSITIVE_INFINITY;
      var w2 = w*w, s2 = s*s*coeff;
      var r1 = (w2*(row[0][1].constructor==Array?treemap.getValue(row[0][1]):row[0][1]))/s2;
      var r2 = s2/(w2*(row[rl-1][1].constructor==Array?treemap.getValue(row[rl-1][1]):row[rl-1][1]));
      return Math.max( r1, r2 );
    },

    emptyCell: $("<div>").addClass("treemapCell").css({'float':'left','overflow':'hidden'}),
    emptySquare: $("<div>").addClass("treemapSquare").css('float','left'),

    layoutRow : function(row,w,orientation,s,options,last) {
      var square = treemap.emptySquare.treemapClone();
      var rowDim, h = s/w;
      if(orientation) {
        rowDim = last?options.width:Math.min(Math.round(h*options.viewAreaCoeff),options.width);
        square.css({'width':rowDim,'height':w}).addClass("treemapV");
      } else {
        rowDim = last?options.height:Math.min(Math.round(h*options.viewAreaCoeff),options.height);
        square.css({'height':rowDim,'width':w}).addClass("treemapH");
      }
      var rl = row.length-1,sum = 0, bw = options.borderWidth, bw2 = bw*2, cells = []; 
      for(var i=0;i<=rl;i++) {
        var n = row[i],hier = n[1].constructor == Array, head = [], val = hier?treemap.getValue(n[1]):n[1];
        var cell = treemap.emptyCell.treemapClone();
        if(!hier) cell.append(n[0]);
        var lastCell = i==rl;
        var fixedDim = rowDim, varDim = lastCell ? w-sum : Math.round(val/h);
        if(varDim<=0) break;
        sum += varDim;
        var cellStyles = {};
        if(bw && rowDim>bw2 && varDim>bw2) {
          if(jQuery.boxModel) {
            fixedDim -= bw*(2-(options.numSquare>=2 || !options.numSquare && options.nested?1:0)-(last && options.nested?1:0));
            varDim -= bw*(2-(!lastCell||options.nested?1:0)-(options.numSquare>=1 && !i?1:0));
          }
          cellStyles.border = bw+'px solid';
          if(!lastCell || options.nested) 
            cellStyles['border'+(orientation?'Bottom':'Right')] = 'none';
          if(options.numSquare>=2 || !options.numSquare && options.nested) 
            cellStyles['border'+(orientation?'Left':'Top')] = 'none';
          if(options.numSquare>=1 && !i) 
            cellStyles['border'+(orientation?'Top':'Left')] = 'none';
          if(last && options.nested)
            cellStyles['border'+(orientation?'Right':'Bottom')] = 'none';
        } 
        var height = orientation?varDim:fixedDim, width = orientation?fixedDim:varDim;

        cellStyles.height = height+'px';
        cellStyles.width = width+'px';
        if(hier) {
          if(options.headHeight) {
            head = $("<div class='treemapHead'>").css({"width":width,"height":options.headHeight,"overflow":"hidden"}).html(n[0]).attr('title',n[0]+' ('+val+')');
            if(orientation) 
              height = varDim -= options.headHeight;
            else
              height = fixedDim -= options.headHeight;

          }
          if(height>0) {
            var new_opt = {};
            for(var prop in options) new_opt[prop] = options[prop]; 
            new_opt["target"] = null;
            new_opt = jQuery.extend(new_opt,{getData:function(){return n[1].concat()},nested:true});
            cell.treemap(width,height,new_opt);
          }
          cell.prepend(head);
        } else {
          if(n[2]) cellStyles.backgroundColor = treemap.getColor(n[2],options);
        }

        var cellstyle = cell[0].style;
        for(var prop in cellStyles)
          cellstyle[prop] = cellStyles[prop];

        cells.push(cell[0]);
      }
      options.content.push(square.treemapAppend(cells)[0]);
      options.numSquare++;
      return rowDim;
    },

    calculateArea : function(row) {
      if(row.total) return row.total;
      var s = 0,rl = row.length;
      for(var i=0;i<rl;i++) {  
        var val = row[i][1];
        s += val.constructor==Array?treemap.getValue(val):val;
      }

      return row.total = s;
    },

    getValue : function(val) {
        if(!val.total) val.total=treemap.calculateArea(val);
        return val.total;
    },

    getColor : function(val,options) {
      var colorCode;
      if(options.colorDiscrete) {
        colorCode = options.colorDiscreteVal[val]/options.colorDiscreteVal.num;
      } else {
        colorCode = (val-options.minColorValue)/options.rangeColorValue;
      }
      return treemap.getColorCode(colorCode);
    },

    getColorCode : function(colorCode) {
      colorCode = Math.round(colorCode*510);
      if(colorCode==0) return "#0000FF";
      if(colorCode<=255) {
        var code1 = colorCode.toString(16);
        if(code1.length<2) code1 = "0"+code1;
        var code2 = (255-colorCode).toString(16);
        if(code2.length<2) code2 = "0"+code2;
        return "#00"+code1+code2;
      }
      if(colorCode<=510) {
        colorCode -= 255
        var code1 = (colorCode).toString(16);
        if(code1.length<2) code1 = "0"+code1;
        var code2 = (255-colorCode).toString(16);
        if(code2.length<2) code2 = "0"+code2;
        return "#"+code1+code2+"00";
      } 
    },

    emptyLegendDescr : $("<div class='treemapLegendDescr'>").css({position:'absolute',left:25,width:200}),

    legend : function(h,options) {
      var l = $("<div class='treemapLegend'>").css({position:'relative','float':'left',height:h-2});
      var bar = $("<div>").css({width:20,height:h-2,border:"1px solid"});
      options.view.css({'float':'left','marginRight':20});
      if(options.colorDiscrete) {
        $.each(options.colorDiscreteVal,function(i,n){
          if(i!='num') {
            i = options.descriptionCallback ? options.descriptionCallback(i):i;
            var height = Math.round(n*h/options.colorDiscreteVal.num);
            var bar = $("<div>").css({height:20,width:20,backgroundColor:treemap.getColor(i,options),position:'absolute',bottom:height});
            var desc = treemap.emptyLegendDescr.clone().text(i).css('bottom',height);
            l.append(bar).append(desc);
          }
        });
      } else {
        for(var i=h-1;i>1;i--) {
          var color = $("<div>").height(1).css("backgroundColor",treemap.getColorCode(i/h));
          bar.append(color);
        };
        l.append(bar);
        for(var i=0;i<10;i++) {
          var val = i*options.rangeColorValue/10+options.minColorValue;
          val = options.descriptionCallback ? options.descriptionCallback(val):val; 
          var desc = treemap.emptyLegendDescr.clone().text(val.toString()).css('bottom',Math.round(i*h/10));
          l.append(desc);
        };
      }
      return l;
    }
  }
})(jQuery);

/*
 * Tipsy.
 *
 * - Removed gravity code. Always gravitate towards center of screen.
 * - Removed all the extra whitespace.
 * - Added tip callback.
 * - Added sane variable naming.
 *
 * Original:
 * http://plugins.jquery.com/project/tipsy
 * The MIT License
 * Copyright (c) 2008 Jason Frame (jason@onehackoranother.com)
 */
(function($) {
  $.fn.tipsy = function(opts) {
    opts = $.extend({fade: false}, opts || {});
    var tip = null, cancelHide = false;
 
    this.hover(function() {
      $.data(this, 'cancel.tipsy', true);
 
      var tip = $.data(this, 'active.tipsy');
      if (!tip) {
        var inner = $('<div class="tipsy-inner">').append(opts.tip ? opts.tip() : $(this).attr('title'));
        tip = $('<div class="tipsy">').append(inner);
        tip.css({position: 'absolute', zIndex: 100000});
        $(this).attr('title', '');
        $.data(this, 'active.tipsy', tip);
      }
 
      var pos = $.extend({}, $(this).offset(), {width: this.offsetWidth, height: this.offsetHeight});
      tip.remove().css({top: 0, left: 0, visibility: 'hidden', display: 'block'}).appendTo(document.body);
      var actualWidth = tip[0].offsetWidth, actualHeight = tip[0].offsetHeight;
 
      // TODO: Brutal. Clean this up later.
      var half_width  = $(window).width() / 2;
      var half_height = $(window).height() / 2;
      if (pos.top < half_height) {
        tip.css({top: pos.top})
        if (pos.left < half_width) tip.css({left: pos.left + pos.width}).addClass('tipsy-nw');
        else tip.css({left: pos.left - actualWidth}).addClass('tipsy-ne');
      }
      else {
        tip.css({top: pos.top - (actualHeight - pos.height)})
        if (pos.left < half_width) tip.css({left: pos.left + pos.width}).addClass('tipsy-sw');
        else tip.css({left: pos.left - actualWidth}).addClass('tipsy-se');
      }
 
      if (opts.fade) {
        tip.css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: 1});
      } else {
        tip.css({visibility: 'visible'});
      }
    }, function() {
      $.data(this, 'cancel.tipsy', false);
      var self = this;
      setTimeout(function() {
        if ($.data(this, 'cancel.tipsy')) return;
        var tip = $.data(self, 'active.tipsy');
        if (opts.fade) {
          tip.stop().fadeOut(function() { $(this).remove(); });
        } else {
          tip.remove();
        }
      }, 100);
    });
  };
})(jQuery);

(function ($) {
  $.extend($.fn, {
    outer: function () {
      return $('<div />').append(this.eq(0).clone()).html();
    },

    visualize: function (options) {
      var defaults = {
        cache:  true,
        width:  Math.min($(window).width(), $(document).width()),
        height: Math.min($(window).height(), $(document).width()) - 41 // TODO: Ick. Hard coded head height.
      };
      options = $.extend(defaults, options);

      return this.each(function () {
        var links = $(this);
        links.children().remove();
        links.treemap(options.width, options.height, {getData: data(options)}).meta_default();
        links.find('div.treemapCell span').link_context().textfill({max: 100}).velocity().meta();
      });
    },

    link_context: function () {
      return this.each(function () {
        var el = $(this);
        if (el.data('link')) el.context.link = el.data('link');
      });
    },

    velocity: function () {
      return this.each(function () {
        var el  = $(this);
        var vel = parseFloat(el.context.link.velocity);

        var colour = '222222';
        if (vel <= 1.00) colour = "D67404";
        if (vel <  0.97) colour = "C95D05";
        if (vel <  0.94) colour = "BB4707";
        if (vel <  0.91) colour = "AE3708";
        if (vel <  0.88) colour = "A1290A";
        if (vel <  0.85) colour = "94200C";
        if (vel <  0.82) colour = "86190F";
        if (vel <  0.79) colour = "771411";
        if (vel <  0.76) colour = "691514";
        if (vel <  0.73) colour = "5F1616";
        if (vel <  0.70) colour = "581717";
        if (vel <  0.67) colour = "521818";
        if (vel <  0.64) colour = "4B1A1A";
        if (vel <  0.61) colour = "451B1B";
        if (vel <  0.58) colour = "3F1C1C";
        if (vel <  0.55) colour = "381E1E";
        if (vel <  0.52) colour = "311F1F";
        if (vel <  0.49) colour = "2B2020";
        if (vel <  0.46) colour = "222222";

        if (vel < -0.46) colour = "22272D";
        if (vel < -0.49) colour = "222931";
        if (vel < -0.52) colour = "222A35";
        if (vel < -0.55) colour = "222C39";
        if (vel < -0.58) colour = "222E3D";
        if (vel < -0.61) colour = "223042";
        if (vel < -0.64) colour = "223246";
        if (vel < -0.67) colour = "22334A";
        if (vel < -0.70) colour = "213551";
        if (vel < -0.73) colour = "20385D";
        if (vel < -0.76) colour = "213E68";
        if (vel < -0.79) colour = "254673";
        if (vel < -0.72) colour = "284F7E";
        if (vel < -0.85) colour = "2E5B8A";
        if (vel < -0.88) colour = "356996";
        if (vel < -0.91) colour = "3E7AA3";
        if (vel < -0.94) colour = "488DB0";
        if (vel < -0.97) colour = "53A0BC";

        el.parent().css('background-color', '#' + colour);
      });
    },

    meta_default: function () {
      return this.each(function () {
        var links = $(this);
        var title      = $('<div class="title" />').append('');
        var screenshot = $('<div class="screenshot" />').append($('<img />').attr({
          width:  '120',
          height: '90',
          src:    '/i/screenshot_placeholder.gif'
        }));
        var url        = $('<div class="url" />').append('');
        var score      = $('<div class="metaScore" />').append('');
        var velocity   = $('<div class="velocity" />').append('');
        var domains    = $('<div class="domains" />').append('');
        links.append($('<div id="meta" />').append(screenshot, title, url, score, velocity, domains));
      });
    },

    meta: function () {
      return this.each(function () {
        var el = $(this);
        el.parent().tipsy({
          tip: function () {
            var link       = el.context.link;
            var title      = $('<div class="title" />').append('' + link.title);
            var image      = $('<img />').attr({
              width:  '120',
              height: '90',
              src:    'http://open.thumbshots.org/image.aspx?url=' + escape(link.url)
            });
            var screenshot = $('<div class="screenshot" />').append(image);
            var anchor     = $('<a />').attr({href: link.url, title: '', target: $.target()}).append(link.url);
            var url        = $('<div class="url" />').append('URL: ', anchor);
            var score      = $('<div class="score" />').append('Score: ' + link.score);
            var velocity   = $('<div class="velocity" />').append('Velocity: ' + link.velocity);
            var sources    = [];
            $.each(link.referrers, function (k, v) {
              sources.push($('<a />').attr({href: v}).append(k).outer());
            });
            var source   = $('<div class="source" />').append('Source: ' + sources.join(', '));
            var meta     = $('<div class="meta" />').append(screenshot, title, url, score, velocity, source);
            return meta;
          }
        });
      });
    }
  });

  $(document).ready(function () {
    $('#links').visualize();
    $(window).resize(function () {
      $('#links').visualize();
    });
  });

  function data (options) {
    return function () {
      if (!(options.cache && $.fn.visualize.links)) {
        var links = $.os.links || $.links({cache: false});
        delete $.os.links;

        // No need to cache $.links since we are caching the link html.
        $.fn.visualize.links = []
        for (var i = 0; i < links.length; i++) {
          var link     = links[i];
          var anchor   = $('<a />').attr({href: link.url, title: '', target: $.target()}).append(link.title);
          var el       = $('<span />').append(anchor).data('link', link);
          $.fn.visualize.links.push([el, parseFloat(link.score) * 100]);
        };
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

