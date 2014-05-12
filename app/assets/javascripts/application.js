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
//= require ./jquery.bxslider
//= require ./jquery.glide
//= require best_in_place


$(function(){
    if(!(Oladium && (Oladium.user || Oladium.developer))){
//= require ./google_analytics
//= require ./yandex_metrika
    }
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
    jQuery(".best_in_place").best_in_place();
})