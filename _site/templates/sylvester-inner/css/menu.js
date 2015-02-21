/* 
   HTML structure to use:

   <ul id="menu">
     <li><a href="#">Sub menu heading</a>
     <ul>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       ...
       ...
     </ul>
     <li><a href="#">Sub menu heading</a>
     <ul>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       ...
       ...
     </ul>
     ...
     ...
   </ul>

Copyright 2007 by Marco van Hylckama Vlieg

web: http://www.i-marco.nl/weblog/
email: marco@i-marco.nl

Free for non-commercial use
*/

function initMenu() {
  jQuery('#menu ul').hide();
  jQuery('#menu li a').click(
    function() {
      var checkElement = jQuery(this).next();
      if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
		 jQuery('#menu ul:visible').slideUp('normal');
        return false;
        }
      if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
        jQuery('#menu ul:visible').slideUp('normal');
        checkElement.slideDown('normal');
        return false;
        }
      }
    );
  }
jQuery(document).ready(function() {initMenu();});



/*function initMenus() {
	$('ul.menu ul').hide();
	$.each($('ul.menu'), function(){
		var cookie = $.cookie(this.id);
		if(cookie === null || String(cookie).length < 1) {
			$('#' + this.id + '.expandfirst ul:first').show();
		}
		else {			
			$('#' + this.id + ' .' + cookie).next().show();
		}
	});
	$('ul.menu li a').click(
		function() {

			var checkElement = $(this).next();
			var parent = this.parentNode.parentNode.id;

			if($('#' + parent).hasClass('noaccordion')) {
				if((String(parent).length > 0) && (String(this.className).length > 0)) {
					if($(this).next().is(':visible')) {
						$.cookie(parent, null);
					}
					else {
						$.cookie(parent, this.className);
					}
					$(this).next().slideToggle('normal');
				}				
			}
			if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
				if($('#' + parent).hasClass('collapsible')) {
					$('#' + parent + ' ul:visible').slideUp('normal');
				}
				return false;
			}
			if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
				$('#' + parent + ' ul:visible').slideUp('normal');
				if((String(parent).length > 0) && (String(this.className).length > 0)) {
					$.cookie(parent, this.className);
				}
				checkElement.slideDown('normal');
				return false;
			}
		}
	);
}
$(document).ready(function() {initMenus();});
*/