$(function () {
    $('.tree li').hide();
    $('.tree li:first').show();
    $('.tree li').on('click', function (e) {
        var children = $(this).find('> ul > li');
        if (children.is(":visible")) {
        	children.hide('fast');        	
        }
        else { 
	        children.show('fast');
	        $('.tree').find('a').removeClass('tree-selected');
	        $(this).children('a').addClass('tree-selected');
	      }
	      e.stopPropagation();        
    });
});