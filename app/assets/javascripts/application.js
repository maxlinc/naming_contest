// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

jQuery(function($) {
  // create a convenient toggleLoading function
  var toggleLoading = function() { $("#loading").toggle() };

  $("a.btn")
    .bind("ajax:loading",  toggleLoading)
    .bind("ajax:complete", toggleLoading)
    .bind("ajax:success", function(event, data, status, xhr) {
      value = get_value(event, data);
      old_value = event.target.text;
      new_html = event.target.innerHTML.replace(old_value, value);
      event.target.innerHTML = new_html;
    });
});

var get_value = function(event, data) {
  if (event.target.id.indexOf('_up') != -1) {
    return data.up;
  } else {
    return data.down;
  }
}

$(function() {
  if ($("#suggestions").length > 0) {
    setTimeout(updateSuggestions, 5000);
  }
});

function updateSuggestions () {
  if ($(".suggestion").length > 0) {
    var after = $(".suggestion:last-child").attr("data-time");
  } else {
    var after = "0";
  }
  $.getScript("/names.js?after=" + after)
  setTimeout(updateSuggestions, 5000);
}

$(function() {
  if ($("#votes").length > 0) {
    setTimeout(updateVotes, 5000);
  }
});

function updateVotes () {
  if ($(".vote").length > 0) {
    var after = $(".vote:last-child").attr("data-time");
  } else {
    var after = "0";
  }
  $.getScript("/votes.js?after=" + after)
  setTimeout(updateVotes, 5000);
}