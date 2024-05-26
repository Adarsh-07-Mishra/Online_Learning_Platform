//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

document.addEventListener('DOMContentLoaded', function() {
  var sidebarToggle = document.getElementById('sidebarToggle');
  var sidebar = document.querySelector('.sidebar');

  sidebarToggle.addEventListener('click', function() {
    sidebar.classList.toggle('active');
  });
});
