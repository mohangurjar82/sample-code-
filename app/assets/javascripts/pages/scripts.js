//= require jquery
//= require pages/bootstrap.min
//= require pages/jquery.easing.min.js
//= require pages/jquery.fittext.js
//= require pages/wow.min.js
//= require pages/creative.js
//= require pages/custom.js


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