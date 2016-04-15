/*!
 * Start Bootstrap - Creative Bootstrap Theme (http://startbootstrap.com)
 * Code licensed under the Apache License v2.0.
 * For details, see http://www.apache.org/licenses/LICENSE-2.0.
 */

(function($) {
    "use strict"; // Start of use strict

    // jQuery for page scrolling feature - requires jQuery Easing plugin
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: ($($anchor.attr('href')).offset().top - 50)
        }, 1250, 'easeInOutExpo');
        event.preventDefault();
    });

    // Highlight the top nav as scrolling occurs
    $('body').scrollspy({
        target: '.navbar-fixed-top',
        offset: 51
    })

    // Closes the Responsive Menu on Menu Item Click
    $('.navbar-collapse ul li a').click(function() {
        $('.navbar-toggle:visible').click();
    });

    // Fit Text Plugin for Main Header
    $("h1").fitText(
        1.2, {
            minFontSize: '35px',
            maxFontSize: '65px'
        }
    );

    // Offset for Main Navigation
    $('#mainNav').affix({
        offset: {
            top: 100
        }
    })

    // Initialize WOW.js Scrolling Animations
    new WOW().init();


    $(function () {
      var rotateInterval;
      $(".hoverimage").hover(
        function () {
          var img = $(this);
          var parts = img.attr("src").split(".");
          var imgIndex = 1;

          rotateInterval = window.setInterval(function () {
            img.attr("src", parts[0] + "-" + imgIndex + ".jpg");
            imgIndex++;
            if (imgIndex > 3) {
              imgIndex = 1;
            }
          }, 2000);
        },
        function () {
          window.clearInterval(rotateInterval);
          var base = $(this).attr("src").split("-")[0].split(".")[0];
          $(this).attr("src", base + ".png");
        });
    });

})(jQuery); // End of use strict
