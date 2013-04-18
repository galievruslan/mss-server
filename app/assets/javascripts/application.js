//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery_nested_form
//= require twitter/bootstrap
//= require bootstrap-datetimepicker
//= require locales/bootstrap-datetimepicker.ru.js

/* ===================================================
 Reset button for filter form
* ===================================================*/
!function($) {
 $(window).on('load', function(){
   $('#q_reset').click(function(){
   $('.search-field').val('');
 });
  });
}(window.jQuery);
/* ===================================================
 Select all checkboxes on page
* ===================================================*/
function selectAll(status) {
	$(".checkbox").each( function() {
		$(this).attr("checked",status);
	})
}