// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ./bootstrap/bootstrap
//= require ./raty
//= require ./bxslider
//  GOOGLE
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-34242765-1']);
_gaq.push(['_setDomainName', 'oladium.com']);
_gaq.push(['_setAllowLinker', true]);
_gaq.push(['_trackPageview']);
(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
(function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter17160772 = new Ya.Metrika({id:17160772, enableAll: true, trackHash:true, webvisor:true}); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f); } else { f(); } })(document, window, "yandex_metrika_callbacks");

$(function(){
    $('.stars').raty({
        score: function() {
            return $(this).attr('score');
        },
        hints: ['1', '2', '3', '4', '5'],
        readOnly: function() {
            return $(this).attr('edit') != '1';
        },
        click: function(score, evt) {
            if(!$(this).attr('voted')){
                $(this).attr('voted', true)
                var game = parseInt($(this).attr('id').match(/\d+$/)[0])
                $.post('/ajax/rate', {game: game, score: score});
            }
        }
    });
})
