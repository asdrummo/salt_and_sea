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
//= require_tree .


$(document).ready(function(){


$(".slide_header").click(function () {

    $slide_header = $(this);
    //getting the next element
    $slide_content = $slide_header.next();
    //open up the content needed - toggle the slide- if visible, slide up, if not slidedown.
    $slide_content.slideToggle(500, function () {
        //execute this after slideToggle is done
        //change text of header based on visibility of content div
        $slide_header.text(function () {
            //change text based on condition
            //return $slide_content.is(":visible") ? "Collapse" : "Expand";
        });
    });

});
});


