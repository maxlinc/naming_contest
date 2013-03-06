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

var update_value = function(element, value) {
  var old_value = element.text();
  var new_html = element.html().replace(old_value, value);
  // alert("Changing " + old_value + " to " + value + " for " + element.id);
  element.html(new_html);
}

var update_score = function(data) {  
  jQuery.each(data, function(key, value) {
                    // alert("key: " + key + ", value: " + value.up + ":" + value.down);
                    var up_element = $("#item_" + key + "_up");
                    update_value(up_element, value.up);
                    var down_element = $("#item_" + key + "_down");
                    update_value(down_element, value.down);
                  });
}

jQuery(function($) {

  // create a convenient toggleLoading function
  var toggleLoading = function() { $("#loading").toggle() };

  $("a.btn")
    .bind("ajax:loading",  toggleLoading)
    .bind("ajax:complete", toggleLoading)
    .bind("ajax:success", function(event, data, status, xhr) {
      update_score(data);
    });
});

(function poll() {
    setTimeout(function() {
        $.ajax({
            url: "/score.json",
            type: "GET",
            success: update_score,
            dataType: "json",
            complete: poll,
            timeout: 2000
        })
    }, 5000);
})();

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