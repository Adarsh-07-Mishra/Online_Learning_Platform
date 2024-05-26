// app/assets/javascripts/likes.js

$(document).on('ajax:success', '.like-button', function(event, data, status, xhr) {
  // Update the like count
  $(this).siblings('span').text(data.like_count + ' Likes');
  // Optionally, show a success message
  alert(data.message);
}).on('ajax:error', '.like-button', function(event, xhr, status, error) {
  var errors = xhr.responseJSON;
  alert(errors.error);
});
