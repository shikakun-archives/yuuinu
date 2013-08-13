$(function() {
  video_size_setting();

  $(window).resize(function() {
    video_size_setting();
  });

  function video_size_setting() {
    $('#youtube').attr('height', $('#youtube').width()/16*9);
  }
});
