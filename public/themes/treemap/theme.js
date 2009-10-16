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

/**
* hoverIntent is similar to jQuery's built-in "hover" function except that
* instead of firing the onMouseOver event immediately, hoverIntent checks
* to see if the user's mouse has slowed down (beneath the sensitivity
* threshold) before firing the onMouseOver event.
* 
* hoverIntent r5 // 2007.03.27 // jQuery 1.1.2+
* <http://cherne.net/brian/resources/jquery.hoverIntent.html>
* 
* hoverIntent is currently available for use in all personal or commercial 
* projects under both MIT and GPL licenses. This means that you can choose 
* the license that best suits your project, and use it accordingly.
* 
* // basic usage (just like .hover) receives onMouseOver and onMouseOut functions
* $("ul li").hoverIntent( showNav , hideNav );
* 
* // advanced usage receives configuration object only
* $("ul li").hoverIntent({
* sensitivity: 7, // number = sensitivity threshold (must be 1 or higher)
* interval: 100,   // number = milliseconds of polling interval
* over: showNav,  // function = onMouseOver callback (required)
* timeout: 0,   // number = milliseconds delay before onMouseOut function call
* out: hideNav    // function = onMouseOut callback (required)
* });
* 
* @param  f  onMouseOver function || An object with configuration options
* @param  g  onMouseOut function  || Nothing (use configuration options object)
* @author    Brian Cherne <brian@cherne.net>
*/
(function($) {
  $.fn.hoverIntent = function(f,g) {
    // default configuration options
    var cfg = {
      sensitivity: 7,
      interval: 100,
      timeout: 0
    };
    // override configuration options with user supplied object
    cfg = $.extend(cfg, g ? { over: f, out: g } : f );

    // instantiate variables
    // cX, cY = current X and Y position of mouse, updated by mousemove event
    // pX, pY = previous X and Y position of mouse, set by mouseover and polling interval
    var cX, cY, pX, pY;

    // A private function for getting mouse position
    var track = function(ev) {
      cX = ev.pageX;
      cY = ev.pageY;
    };

    // A private function for comparing current and previous mouse position
    var compare = function(ev,ob) {
      ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t);
      // compare mouse positions to see if they've crossed the threshold
      if ( ( Math.abs(pX-cX) + Math.abs(pY-cY) ) < cfg.sensitivity ) {
        $(ob).unbind("mousemove",track);
        // set hoverIntent state to true (so mouseOut can be called)
        ob.hoverIntent_s = 1;
        return cfg.over.apply(ob,[ev]);
      } else {
        // set previous coordinates for next time
        pX = cX; pY = cY;
        // use self-calling timeout, guarantees intervals are spaced out properly (avoids JavaScript timer bugs)
        ob.hoverIntent_t = setTimeout( function(){compare(ev, ob);} , cfg.interval );
      }
    };

    // A private function for delaying the mouseOut function
    var delay = function(ev,ob) {
      ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t);
      ob.hoverIntent_s = 0;
      return cfg.out.apply(ob,[ev]);
    };

    // A private function for handling mouse 'hovering'
    var handleHover = function(e) {
      // next three lines copied from jQuery.hover, ignore children onMouseOver/onMouseOut
      var p = (e.type == "mouseover" ? e.fromElement : e.toElement) || e.relatedTarget;
      while ( p && p != this ) { try { p = p.parentNode; } catch(e) { p = this; } }
      if ( p == this ) { return false; }

      // copy objects to be passed into t (required for event object to be passed in IE)
      var ev = jQuery.extend({},e);
      var ob = this;

      // cancel hoverIntent timer if it exists
      if (ob.hoverIntent_t) { ob.hoverIntent_t = clearTimeout(ob.hoverIntent_t); }

      // else e.type == "onmouseover"
      if (e.type == "mouseover") {
        // set "previous" X and Y position based on initial entry point
        pX = ev.pageX; pY = ev.pageY;
        // update "current" X and Y position based on mousemove
        $(ob).bind("mousemove",track);
        // start polling interval (self-calling timeout) to compare mouse coordinates over time
        if (ob.hoverIntent_s != 1) { ob.hoverIntent_t = setTimeout( function(){compare(ev,ob);} , cfg.interval );}

      // else e.type == "onmouseout"
      } else {
        // unbind expensive mousemove event
        $(ob).unbind("mousemove",track);
        // if hoverIntent state is true, then call the mouseOut function after the specified delay
        if (ob.hoverIntent_s == 1) { ob.hoverIntent_t = setTimeout( function(){delay(ev,ob);} , cfg.timeout );}
      }
    };

    // bind the function to the two event listeners
    return this.mouseover(handleHover).mouseout(handleHover);
  };
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

    this.hoverIntent({
      interval: 400,
      over: function() {
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
          tip.css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: 0}, 1000).animate({opacity: 1});
        } else {
          tip.css({visibility: 'visible'});
        }
      },
      out: function() {
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
      }
    });
  };
})(jQuery);

(function ($) {
  $.extend($.fn, {
    visualize: function (options) {
      var defaults = {
        cache:  true,
        width:  Math.min($(window).width(), $(document).width()),
        height: Math.min($(window).height(), $(document).width()) - 45 // TODO: Ick. Hard coded head height.
      };
      options = $.extend(defaults, options);

      return this.each(function () {
        var links    = $(this);
        links.children().remove();
        links.treemap(options.width, options.height, {getData: data(options)});
        links.find('div.treemapCell span').link_context().textfill({max: 100}).velocity().tooltip();
      });
    },

    mouse_position: function () {
      return $.fn.visualize.mouse_position;
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

        var colour = '1b1b1b';
        if (vel < 1)   colour = "cc3732";
        if (vel < 0.9)  colour = "cc4a46";
        if (vel < 0.8)  colour = "cc5e5b";
        if (vel < 0.7)  colour = "cc7674";
        if (vel < 0.6)  colour = "1b1b1b";

        if (vel < -0.6)  colour = "8fabcc";
        if (vel < -0.7)  colour = "709acc";
        if (vel < -0.8)  colour = "5089cc";
        if (vel < -0.9)  colour = "3278cc";

        el.parent().css('background-color', '#' + colour);
      });
    },

    tooltip: function () {
      return this.each(function () {
        var el = $(this);
        el.parent().tipsy({
          fade: true,
          tip:  function () {
            var link       = el.context.link;
            var title      = $('<div class="title" />').append(link.title);
            var screenshot = $('<div class="screenshot" />').append($('<img />').attr({
              width:  '120',
              height: '90',
              src:    'http://open.thumbshots.org/image.aspx?url=' + escape(link.url)
            }));
            var url        = $('<div class="url" />').append('url: ' + link.url);
            var score      = $('<div class="score" />').append('score: ' + link.score);
            var velocity   = $('<div class="velocity" />').append('velocity: ' + link.velocity);
            var domains    = $('<div class="domains" />').append('via: ' + (link.domains || []).join(', '));
            var meta       = $('<div class="meta" />').append(title, screenshot, url, score, velocity, domains);
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
          var anchor   = $('<a />').attr({href: link.url, title: ''}).append(link.title);
          var el       = $('<span />').append(anchor).data('link', link);
          $.fn.visualize.links.push([el, parseFloat(link.score) * 100]);
        };
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

