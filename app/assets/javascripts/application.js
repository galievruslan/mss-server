//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datetimepicker
//= require locales/bootstrap-datetimepicker.ru.js
//= require select2
//= require select2_locale_ru
//= require bootstrap-fileupload
//= require bootstrap-inputmask.min
//= require tree
//= require highcharts
//= require bootstrap-spinedit
/* ===================================================
 Reset button for filter form
* ===================================================*/
!function($) {
	$(window).on('load', function(){
		$('#q_reset').click(function(){
			$('.search-field').val('');
			$("select.search-field").each(function() {
				$(this).select2("val", "");
			});
		});
	});
}(window.jQuery);
/* ===================================================
 Select all checkboxes on tbody
* ===================================================*/
function toggleChecked(status) {
	$("tbody input").each( function() {
		$(this).attr("checked",status);
	})
};
/* ===================================================
 Date and datetime pickers 
* ===================================================*/
$(function() {
  $('.datepicker').datetimepicker({    	
	format: 'dd-MM-yyyy',
	pickTime: false,
	language: 'ru'
  });
});
$(function() {
	$('.datetimepicker').datetimepicker({    	
	format: 'dd-MM-yyyy hh:mm',
	language: 'ru'
	});
});