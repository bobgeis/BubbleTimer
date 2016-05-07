// Generated by CoffeeScript 1.10.0
(function() {
  "This contains some functions and values that are useful";
  var H, audioFile, helper;

  helper = H = {};

  _first.offer('helper', helper);

  H.TWOPI = Math.PI * 2;

  H.HALFPI = Math.PI / 2;

  audioFile = "assets/bubbles.mp3";

  H.distance = function(pos1, pos2) {
    var dx, dy;
    dx = pos1.x - pos2.x;
    dy = pos1.y - pos2.y;
    return Math.sqrt(dx * dx + dy * dy);
  };

  H.remove = function(list, item) {
    var i;
    i = list.indexOf(item);
    if (i !== -1) {
      return list.splice(i, 1);
    }
  };

  H.flipList = function(list) {
    var item, j, l, len;
    l = [];
    for (j = 0, len = list.length; j < len; j++) {
      item = list[j];
      l.push(item);
    }
    return l.reverse();
  };

  H.playSound = function() {
    return new Audio(audioFile).play();
  };

}).call(this);