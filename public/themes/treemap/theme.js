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
 * Embedly JQuery
 * ==============
 * This library allows you to easily embed objects on any page.
 * 
 * Requirements:
 * -------------
 * jquery-1.3 or higher
 *
 * Usage:
 * ------
 * There are two ways to interact with this lib. One exposes a simple method to call embedly directly
 *
 * >>> $.embedly('http://www.youtube.com/watch?v=LfamTmY5REw', {}, function(oembed){ alert(oembed.title);});
 * 
 * The oembed is either a json object or null
 * 
 * You can also reference it this way, which will try and replace every link on the page with an embed
 * 
 * $('a').embedly();
 * 
 * The Options Are as Follows
 * 
 * {maxWidth : null,
 *  maxHeight: null,
 *  urlRe : null,
 *  method : 'replace',
 *  wrapElement : 'div', 
 *  className : 'embed',
 *  addImageStyles : true} //after
 * 
 * http://api.embed.ly/tools/generator - generate your own regex for only sources you want
 * 
 */
(function($) {
  $.embedly = function(url, options, callback){

    options = extendOptions(options);

    if (url != null && urlValid(url, options))
      embed(url, options, callback);
      else
        callback(null);

  }
    $.fn.embedly = function(options, callback) {

      options = extendOptions(options);

      callback = (callback != null) ? callback : defaultCallback;

        return this.each(function() {
          if ($(this).attr('href')){
            //Get the URL
            var elem = $(this);
            var url  = elem.attr('href');
            //Make a Callback wrapper
            function wrap(oembed){
              callback(oembed, elem, options);
            }
            // Make sure the URL pass the regex.
            if (url != null && urlValid(url, options)){
              embed(url, options, wrap);
            //Nope so pass a null to the callback
            } else {
              wrap(null);
            }
          } else {
            // If it's not an a tag find all the urls in the elem
            $(this).find('A').each(function(index, elem){
              elem = $(elem);
              var url = elem.attr('href');
              //Make a Callback wrapper
              function wrap(oembed){
                callback(oembed, elem, options);
              }
              // Make sure the URL pass the regex.
              if (url != null && urlValid(url, options)){
                embed(url, options, wrap);
              //Nope so pass a null to the callback
              } else {
                wrap(null);
              }
            });
          }
        });
    };

    $.fn.embedly.defaults = {
        maxWidth: null,
        maxHeight: null,
    method: "replace", // 'after'
    addImageStyles : true,
    wrapElement : 'div',
    className : 'embed',
    urlRe : null
    };

    function extendOptions(options){
    // JQuery 1.3 will destroy the urlRe in the $extend. 
    // We have to do a little hack so it doesn't.
    var overrideUrlRe = (typeof options.urlRe == 'undefined')?$.fn.embedly.defaults.urlRe:options.urlRe;
    options = $.extend(true, $.fn.embedly.defaults, options);
    options.urlRe = overrideUrlRe;
    return options;
    }
    function defaultCallback(oembed, elem, options){
      if (oembed == null)
        return;
 
      switch(options.method)
      {
        case "replace": 
          elem.replaceWith(oembed.code);
          break;
        case "after":
          elem.after(oembed.code);      
          break;
        case "afterParent":
          elem.parent().after(oembed.code);     
          break;
      }
    };

    function isEmpty(obj) {
        for(var prop in obj) {
            if(obj.hasOwnProperty(prop))
                return false;
        }
        return true;
    };
    
    function urlValid(url, options) {
        var urlRe = /http:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*#.*|.*\.youtube\.com\/.*#.*\/.*|.*justin\.tv\/.*|.*justin\.tv\/.*\/b\/.*|www\.ustream\.tv\/recorded\/.*|www\.ustream\.tv\/channel\/.*|qik\.com\/video\/.*|qik\.com\/.*|.*revision3\.com\/.*|.*\.dailymotion\.com\/video\/.*|.*\.dailymotion\.com\/.*\/video\/.*|www\.collegehumor\.com\/video:.*|.*twitvid\.com\/.*|www\.break\.com\/.*\/.*|vids\.myspace\.com\/index\.cfm\?fuseaction=vids\.individual&videoid.*|www\.myspace\.com\/index\.cfm\?fuseaction=.*&videoid.*|www\.metacafe\.com\/watch\/.*|blip\.tv\/file\/.*|.*\.blip\.tv\/file\/.*|video\.google\.com\/videoplay\?.*|.*revver\.com\/video\/.*|video\.yahoo\.com\/watch\/.*\/.*|video\.yahoo\.com\/network\/.*|.*viddler\.com\/explore\/.*\/videos\/.*|liveleak\.com\/view\?.*|www\.liveleak\.com\/view\?.*|animoto\.com\/play\/.*|dotsub\.com\/view\/.*|www\.overstream\.net\/view\.php\?oid=.*|www\.livestream\.com\/.*|www\.worldstarhiphop\.com\/videos\/video.*\.php\?v=.*|worldstarhiphop\.com\/videos\/video.*\.php\?v=.*|teachertube\.com\/viewVideo\.php.*|teachertube\.com\/viewVideo\.php.*|bambuser\.com\/v\/.*|bambuser\.com\/channel\/.*|bambuser\.com\/channel\/.*\/broadcast\/.*|.*yfrog\..*\/.*|tweetphoto\.com\/.*|www\.flickr\.com\/photos\/.*|.*twitpic\.com\/.*|.*imgur\.com\/.*|.*\.posterous\.com\/.*|post\.ly\/.*|twitgoo\.com\/.*|i.*\.photobucket\.com\/albums\/.*|gi.*\.photobucket\.com\/groups\/.*|phodroid\.com\/.*\/.*\/.*|www\.mobypicture\.com\/user\/.*\/view\/.*|moby\.to\/.*|xkcd\.com\/.*|www\.xkcd\.com\/.*|www\.asofterworld\.com\/index\.php\?id=.*|www\.qwantz\.com\/index\.php\?comic=.*|23hq\.com\/.*\/photo\/.*|www\.23hq\.com\/.*\/photo\/.*|.*dribbble\.com\/shots\/.*|drbl\.in\/.*|.*\.smugmug\.com\/.*|.*\.smugmug\.com\/.*#.*|emberapp\.com\/.*\/images\/.*|emberapp\.com\/.*\/images\/.*\/sizes\/.*|emberapp\.com\/.*\/collections\/.*\/.*|emberapp\.com\/.*\/categories\/.*\/.*\/.*|embr\.it\/.*|picasaweb\.google\.com.*\/.*\/.*#.*|picasaweb\.google\.com.*\/lh\/photo\/.*|picasaweb\.google\.com.*\/.*\/.*|dailybooth\.com\/.*\/.*|brizzly\.com\/pic\/.*|pics\.brizzly\.com\/.*\.jpg|img\.ly\/.*|www\.facebook\.com\/photo\.php.*|www\.whitehouse\.gov\/photos-and-video\/video\/.*|www\.whitehouse\.gov\/video\/.*|wh\.gov\/photos-and-video\/video\/.*|wh\.gov\/video\/.*|www\.hulu\.com\/watch.*|www\.hulu\.com\/w\/.*|hulu\.com\/watch.*|hulu\.com\/w\/.*|movieclips\.com\/watch\/.*\/.*\/|movieclips\.com\/watch\/.*\/.*\/.*\/.*|.*crackle\.com\/c\/.*|www\.fancast\.com\/.*\/videos|www\.funnyordie\.com\/videos\/.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|www\.ted\.com\/talks\/.*\.html.*|www\.ted\.com\/talks\/lang\/.*\/.*\.html.*|www\.ted\.com\/index\.php\/talks\/.*\.html.*|www\.ted\.com\/index\.php\/talks\/lang\/.*\/.*\.html.*|.*omnisio\.com\/.*|.*nfb\.ca\/film\/.*|www\.thedailyshow\.com\/watch\/.*|www\.thedailyshow\.com\/full-episodes\/.*|www\.thedailyshow\.com\/collection\/.*\/.*\/.*|movies\.yahoo\.com\/movie\/.*\/video\/.*|movies\.yahoo\.com\/movie\/.*\/info|movies\.yahoo\.com\/movie\/.*\/trailer|www\.colbertnation\.com\/the-colbert-report-collections\/.*|www\.colbertnation\.com\/full-episodes\/.*|www\.colbertnation\.com\/the-colbert-report-videos\/.*|www\.comedycentral\.com\/videos\/index\.jhtml\?.*|www\.theonion\.com\/video\/.*|theonion\.com\/video\/.*|wordpress\.tv\/.*\/.*\/.*\/.*\/|www\.traileraddict\.com\/trailer\/.*|www\.traileraddict\.com\/clip\/.*|www\.traileraddict\.com\/poster\/.*|www\.escapistmagazine\.com\/videos\/.*|www\.trailerspy\.com\/trailer\/.*\/.*|www\.trailerspy\.com\/trailer\/.*|www\.trailerspy\.com\/view_video\.php.*|www\.atom\.com\/.*\/.*\/|fora\.tv\/.*\/.*\/.*\/.*|www\.spike\.com\/video\/.*|www\.gametrailers\.com\/video\/.*|gametrailers\.com\/video\/.*|www\.godtube\.com\/featured\/video\/.*|www\.tangle\.com\/view_video.*|soundcloud\.com\/.*|soundcloud\.com\/.*\/.*|soundcloud\.com\/.*\/sets\/.*|soundcloud\.com\/groups\/.*|www\\.last\\.fm\/music\/.*|www\\.last\\.fm\/music\/+videos\/.*|www\\.last\\.fm\/music\/+images\/.*|www\\.last\\.fm\/music\/.*\/_\/.*|www\\.last\\.fm\/music\/.*\/.*|www\.mixcloud\.com\/.*\/.*\/|espn\.go\.com\/video\/clip.*|espn\.go\.com\/.*\/story.*|cnbc\.com\/id\/.*|cbsnews\.com\/video\/watch\/.*|www\.cnn\.com\/video\/.*|edition\.cnn\.com\/video\/.*|money\.cnn\.com\/video\/.*|today\.msnbc\.msn\.com\/id\/.*\/vp\/.*|www\.msnbc\.msn\.com\/id\/.*\/vp\/.*|www\.msnbc\.msn\.com\/id\/.*\/ns\/.*|today\.msnbc\.msn\.com\/id\/.*\/ns\/.*|multimedia\.foxsports\.com\/m\/video\/.*\/.*|msn\.foxsports\.com\/video.*|.*amazon\..*\/gp\/product\/.*|.*amazon\..*\/.*\/dp\/.*|.*amazon\..*\/dp\/.*|.*amazon\..*\/o\/ASIN\/.*|.*amazon\..*\/gp\/offer-listing\/.*|.*amazon\..*\/.*\/ASIN\/.*|.*amazon\..*\/gp\/product\/images\/.*|www\.amzn\.com\/.*|amzn\.com\/.*|www\.shopstyle\.com\/browse.*|www\.shopstyle\.com\/action\/apiVisitRetailer.*|www\.shopstyle\.com\/action\/viewLook.*|gist\.github\.com\/.*|twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|www\.slideshare\.net\/.*\/.*|.*\.scribd\.com\/doc\/.*|screenr\.com\/.*|polldaddy\.com\/community\/poll\/.*|polldaddy\.com\/poll\/.*|answers\.polldaddy\.com\/poll\/.*|www\.5min\.com\/Video\/.*|www\.howcast\.com\/videos\/.*|www\.screencast\.com\/.*\/media\/.*|screencast\.com\/.*\/media\/.*|www\.screencast\.com\/t\/.*|screencast\.com\/t\/.*|issuu\.com\/.*\/docs\/.*|www\.kickstarter\.com\/projects\/.*\/.*|www\.scrapblog\.com\/viewer\/viewer\.aspx.*|my\.opera\.com\/.*\/albums\/show\.dml\?id=.*|my\.opera\.com\/.*\/albums\/showpic\.dml\?album=.*&picture=.*|tumblr\.com\/.*|.*\.tumblr\.com\/post\/.*|www\.polleverywhere\.com\/polls\/.*|www\.polleverywhere\.com\/multiple_choice_polls\/.*|www\.polleverywhere\.com\/free_text_polls\/.*|.*\.status\.net\/notice\/.*|identi\.ca\/notice\/.*|shitmydadsays\.com\/notice\/.*)/i
    return (url.match(urlRe) != null && (options.urlRe == null || url.match(options.urlRe) != null));
    }
    
    function embed(url, options, callback){

      //Build The URL
      var fetchUrl = 'http://api.embed.ly/v1/api/oembed?';

      fetchUrl += "format=json&url=" + escape(url);

      //Deal with maxwidth and max height
    if (options.maxWidth != null)
      fetchUrl += "&maxwidth=" + options.maxWidth;  

    if (options.maxHeight != null)
      fetchUrl += "&maxheight=" + options.maxHeight;
 
    fetchUrl += "&callback=?";

    //Make the call to Embedly
      $.ajax( {url: fetchUrl,
          dataType: 'json',
          success: function(data) {
            //Make sure the response isn't empty
            if (isEmpty(data) || data.hasOwnProperty('error')){
              callback(null);
              return;
            }

            //Wrap The Element
            var code = '';
            if (options.wrapElement !=null)
              code += '<'+options.wrapElement+' class="'+options.className+'">';

                  switch (data.type) {
                      case "photo":
                        var title = data.title ? data.title : '';
                      
                  //Because of photos like twitpic and tweetphoto we need to let the browser do some of the work
                        var style = '';
                  if (options.addImageStyles) {
                            if (options.maxWidth != null)
                              style += 'max-width:'+options.maxWidth+'px; ';
                            if (options.maxHeight != null)
                              style += 'max-height:'+options.maxHeight+'px; ';
                  }
                        code += '<a href="' + url + '" target="_blank"><img style="'+style+'" src="' + data.url + '" alt="' + title + '"/></a>';
                          break;
                      case "video":
                        code += data.html;
                          break;
                      case "rich":
                        code += data.html;
                          break;
                      default :
                        code += '<a href="' + url + '">' + (data.title != null) ? data.title : url + '</a>';
                        break;
                  }
            
            if (options.wrapElement !=null)
              code += '</'+options.wrapElement+'>';
 
            data.code = code;
 
            callback(data);
          },
          error : function(){
            callback(null);
          }
      });
    };
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

(function ($) {
  $.extend($.fn, {
    outer: function () {
      return $('<div />').append(this.eq(0).clone()).html();
    },

    visualize: function (options) {
      var defaults = {
        cache:  true,
        width:  Math.min($(window).width(), $(document).width()),
        height: Math.min($(window).height(), $(document).width()) - 141 // TODO: Ick. Hard coded head height.
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
        if (el.context && el.context.link) {
          el.parent().wrap($('<a />').attr({href: el.context.link.url, title: '', target: $.target()}));
        }
      });
    },

    velocity: function () {
      return this.each(function () {
        var el  = $(this);
        var vel = parseFloat(el.context.link.velocity);

        var colour = '222222';
        if (vel < 1)   colour = "cc3732";
        if (vel < 0.9)  colour = "cc4a46";
        if (vel < 0.8)  colour = "cc5e5b";
        if (vel < 0.7)  colour = "cc7674";
        if (vel < 0.6)  colour = "222222";

        if (vel < -0.6)  colour = "8fabcc";
        if (vel < -0.7)  colour = "709acc";
        if (vel < -0.8)  colour = "5089cc";
        if (vel < -0.9)  colour = "3278cc";

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
        el.parent().hoverIntent({
          interval: 500,
          over: function () {
            var link       = el.context.link;
            var title      = $('<div class="title" />').append('' + link.title);

            var image = $('<img />').hide();
            $.embedly(link.url, {maxWidth: 190, maxHeight: 190}, function (oe) {
              if (oe && oe.thumbnail_url) image.attr({src: oe.thumbnail_url});
              else image.attr({src: 'http://open.thumbshots.org/image.aspx?url=' + escape(link.url)});
              image.show();
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
            var meta     = $('#meta');
            meta.children().remove();
            meta.append(screenshot, title, url, score, velocity, source);
          },
          out: function () {} // Must be defined.
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
          var link = links[i];
          var el   = $('<span />').append(link.title).data('link', link);
          $.fn.visualize.links.push([el, parseFloat(link.score) * 100]);
        };
      }
      return $.fn.visualize.links;
    };
  }
})(jQuery);

