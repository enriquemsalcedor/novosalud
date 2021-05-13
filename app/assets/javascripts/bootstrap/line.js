$(document).ready(function(){
(function(){
  "use strict";

  // Navbar left
  // -------------------------------------------------
		// Variables
		  var lnl                = $(".line-navbar-left"),
					lnoBtnToggle        = $(".lno-btn-toggle"),
					lnoBtnCollapse      = $(".lno-btn-collapse"),
					contentWrap         = $(".content-wrap"),
					contentWrapEffect   = contentWrap.data("effect"),
					windowHeight        = $(window).height() - 95;

		// Functions
			function lnlShow() {
				lnl.addClass("lnl-show").removeClass("lnl-hide");
				contentWrap.addClass(contentWrapEffect).css({
					height : windowHeight ,
					overflow : 'hidden'
				});
				$( 'html, body' ).css( 'overflow', 'hidden' );
				lnoBtnToggle.find("span").removeClass("fa-bars").addClass("fa-remove");
			}

			function lnlHide() {
				lnl.removeClass("lnl-show").addClass("lnl-hide");
				contentWrap.removeClass(contentWrapEffect).css({
					height : 'auto' ,
					overflow : 'auto'
				});
				$( 'html, body' ).css( 'overflow', 'auto' );
				lnoBtnToggle.find("span").removeClass("fa-remove").addClass("fa-bars");
			}

		// Code credit: https://tr.im/CZzf4
		function isMobile() {
		  try{ document.createEvent("TouchEvent"); return true; }
		  catch(e){ return false; }
		}

		// Toggle the navbar
			lnl.addClass("lnl-hide");
			lnoBtnToggle.click( function() {
				console.log("hola");
				if( lnl.hasClass("lnl-hide") ) {
					lnlShow();
				} else {
					lnlHide();
				}
			});


		// Collapse the navbar
			lnoBtnToggle.click( function(e) {
				e.preventDefault();

				if( lnl.hasClass("lnl-collapsed") ) {
					lnl.removeClass("lnl-collapsed");
					contentWrap.removeClass("lnl-collapsed");
					$(this).find(".lnl-link-icon").removeClass("fa-arrow-right").addClass("fa-arrow-left");
				} else {
					lnl.addClass("lnl-collapsed");
					contentWrap.addClass("lnl-collapsed");
					$(this).find(".lnl-link-icon").removeClass("fa-arrow-left").addClass("fa-arrow-right");
				}
			});

		// Swipe the navbar
			if ( isMobile() == true ) 
			{
				$(window).on('swipe', function()
				{
					function swipeRight()
					{
						lnlShow();
						$( '.navbar-collapse' ).removeClass( 'in' );
					}
					function swipeLeft()
					{
						lnlHide();
					}
					threshold: 75
				});
			}

		$('.dropdown-toggle').hover(function(){
				$('dropdown-menu').slideDown(function(){
					alert("hola");
				});
		});

		// Auto hide the opened left navbar on large devices
			$( window ).resize(function() {
			  if ( $( window ).width() >= 767 ) {
			  	lnlHide();
			  }
			});

  // Toggle search suggestion if search input focuses div que baja del input
  // -------------------------------------------------
  	$('.lnt-search-input').focusin( function() {
  		$('.lnt-search-suggestion').find('.dropdown-menu').slideDown();
  	});

  	$('.lnt-search-input').focusout( function() {
  		$('.lnt-search-suggestion').find('.dropdown-menu').slideUp()
  	});

  // Change search category selector value
  // -------------------------------------------------
  	var searchCategory = $(' .lnt-search-category ').find(' .dropdown-menu ').find(' li ');

  	searchCategory.click( function() {
  		var selectedCategory = $( this ).find(' a ').text(),
  				selectedCategoryText = $(' .selected-category-text ');
  		selectedCategoryText.text( selectedCategory );
  	});

  // Highlight search result text bold
  // -------------------------------------------------


	// Navbar two shopping cart
	// -------------------------------------------------
		$( '.add-to-cart' ).click( function() {
			var randColor = randomColor({ luminosity: 'light', format: 'rgb' }),
					counter = $( '.lnt-cart' ).find( '.cart-item-quantity' ).text();

			$( '.lnt-cart' ).css( "backgroundColor" , randColor );
			$( '.lnt-cart' ).find( 'span' ).eq(0).addClass( 'item-added' );
			$( '.lnt-cart' ).find( '.cart-item-quantity' ).text( ++counter );
		});

	// Navbar one shopping cart - small devices
	// -------------------------------------------------
		$( '.add-to-cart' ).click( function() {
			var randColor = randomColor({ luminosity: 'light', format: 'rgb' }),
					counter = $( '.lno-cart' ).find( '.cart-item-quantity' ).text();

			$( '.lno-cart' ).css( "backgroundColor" , randColor );
			$( '.lno-cart' ).find( 'span' ).eq(0).addClass( 'item-added' );
			$( '.lno-cart' ).find( '.cart-item-quantity' ).text( ++counter );
		});
  
  // Mega menu
  // -------------------------------------------------
		var categoryLink = $( '.lnt-category' ).find( 'li' ).find( 'a' ),
        categoryList = $( '.lnt-category' ).find( 'li' );

  	// Mouse enter
	  	categoryLink.mouseenter( function(){
	  		// Add active class
				categoryList.removeClass( 'active' );
				$( this ).parent().addClass( 'active' );

				// Slide subcategories based on active link
				var categoryContent = $( this ).attr( 'href' );
				$( '.lnt-subcategroy-carousel-wrap' ).find( '> div' ).removeClass( 'active' );
				$( categoryContent ).addClass( 'active' );
	  	});

	  // Touch
		  categoryLink.on( 'touchstart, touchend', function( e ) {
		  	e.preventDefault();
		  	// Add active class
				categoryList.removeClass( 'active' );
				$( this ).parent().addClass( 'active' );

				// Slide subcategories based on active link
				var categoryContent = $( this ).attr( 'href' );
				$( '.lnt-subcategroy-carousel-wrap' ).find( '> div' ).removeClass( 'active' );
				$( categoryContent ).addClass( 'active' );
		  });

  // Make the carousel swipe ready
  // -------------------------------------------------

		if ( isMobile() == true )
		{
			$(window).on('swipe', function()
			{

				function swipeLeft()
				{
					$( '.carousel' ).carousel('next');
				}
				function swipeRight()
				{
					$( '.carousel' ).carousel('prev');
				}
				threshold: 75
			});

			// Hide the carousel
				$( '.carousel-indicators' ).hide();
		}

	// Change carousel item on mouse enter
	// -------------------------------------------------
		$( '.carousel-indicators' ).find( 'li' ).mouseenter( function() {
			var number = $( this ).data( 'slide-to' );
			$( this ).parents( '.carousel' ).carousel(number);
		});

	// Clone categories and subcategories from navbar two 
	// -------------------------------------------------

		// Code credit: https://tr.im/akZ9s
			String.prototype.capitalize = function() {
		    return this.replace(/(?:^|\s)\S/g, function(a) { return a.toUpperCase(); });
			};

		// replace(/[, ]+/g, '') code credit: https://tr.im/1luzD

			// Clone category
				$( '.lnt-category > li' ).each( function() {
					var link = $( this ).find( 'a' );
					$( '.lnl-nav' ).append( "<li><a class='collapsed' data-toggle='collapse' href='#collapse" + link.text().capitalize().replace(/[, ]+/g, '') + "' aria-expanded='false' aria-controls='collapse" + link.text().capitalize().replace(/[, ]+/g, '') + "' data-subcategory=" + link.attr( 'href' ).replace( '#', '' ) + "><span class='lnl-link-text'>" + $( this ).text() + "</span><span class='fa fa-angle-up lnl-btn-sub-collapse'></span></a></li>" );
				});

			// Clone subcategories ul
				$( '.lnl-nav li' ).each( function() {
					var link = $( this ).find( 'a' );
					$( this ).append( "<ul class='lnl-sub-one collapse' id='" + link.attr( 'href' ).replace( '#', '' ) + "' data-subcategory='" + link.data( 'subcategory' ) + "'></ul>");
				});

			// Clone subcategories li
				// data selectror code credit: https://tr.im/AgbW6
				// map code credit: https://tr.im/G0du8
				$( '.lnt-subcategroy-carousel-wrap > div' ).each( function() {
					var subcategoryId = $( this ).attr( 'id' ),
							subcategoryDivUl = $( this ).find( 'ul' ).map( function() {
								return $( this ).html();
							}).get(),
							targetUl = $("ul[data-subcategory='" + subcategoryId + "']");
					
					targetUl.append( subcategoryDivUl );
				});

	// Close left navbar when top navbar opens
	// -------------------------------------------------
		$( '.navbar-toggle' ).click( function() {
			if ( $( this ).hasClass( 'collapsed' ) ) {
				lnlHide();
			}
		});

	// Close top navbar when left navbar opens
	// -------------------------------------------------
		lnoBtnToggle.click( function() {
			$( '.navbar-collapse' ).removeClass( 'in' );
		});


})();
})
