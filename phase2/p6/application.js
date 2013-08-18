// Die Prototype
var Die = function() {
  this.sideUp = 0;
};

Die.prototype.roll = function() {
  var newValue = Math.floor(1 + Math.random() * 6);
  this.sideUp = newValue;
};

// Die 'view'
Die.prototype.toDOM = function() {
  var die = $(document.createElement('div'));
  die.addClass('die');
  die.text(this.sideUp);
  return die
};
// END Die Prototype

// Board Prototype
var Board = function() {
  this.dice = [];
};

Board.prototype.addDie = function(die) {
  this.dice.push(die);
};

Board.prototype.rollDice = function() {
  $.each(this.dice, function(i, die) {
    die.roll();
  });
};

// Board 'view'
Board.prototype.toDOM = function() {
  var board = $(document.createElement('div'));
  board.addClass('board');
  $.each(this.dice, function(i, die) {
    board.append(die.toDOM());
  });
  return board;
};
// END Board Prototype

// Controller Code
$(document).ready(function() {

  var board = new Board();

  $('#roller button.add').on('click', function() {
    var die = new Die();
    board.addDie(die);
    refreshBoard();
  });

  $('#roller button.roll').on('click', function() {
    board.rollDice();
    refreshBoard();
  });

  var refreshBoard = function() {
    $('.dice').html(board.toDOM());
  }

});
