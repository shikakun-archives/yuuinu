$(function() {
  video_size_setting();

  var default_video = 'v3';
  var youtube_id = {
    'v1': 'DomXocSJ-ZE',
    'v2pre': 'y0IgRZn9QT8',
    'v2': '0p7Tdqo6uyY',
    'v3pre': '4I6MeeGCKhI',
    'v3': 'bqbNAjp3S1E',
    'v4': '7dcgWvyQMDw'
  };
  $('#youtube').attr('src', '//www.youtube.com/embed/' + youtube_id[default_video] + '?autoplay=1&vq=hd1080');
  $('#' + default_video).addClass('active');

  $('.tab').click(function() {
    $('.tab').removeClass('active');
    $(this).addClass('active');
    var select_id = $(this).attr('id');
    $('#youtube').attr('src', '//www.youtube.com/embed/' + youtube_id[select_id] + '?autoplay=1&vq=hd1080');
  });

  $(window).resize(function() {
    video_size_setting();
  });

  function video_size_setting() {
    $('#youtube').attr('height', $('#youtube').width()/16*9);
  }
});
