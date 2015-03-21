(function( Board, $ ) {
  // Private variables
  var board = '#board';
  var dispatcher = new WebSocketRails('localhost:3000/websocket');
  var channel = dispatcher.subscribe('players');
  
  // Private methods
  function _updateBoard(){
    channel.bind('update_board', function(data) {
      console.log('updating board with data: ' + data);
    });
  };

  function _addColumnBindings(argument) {
    // Add triggers to HTML using jquery, so they can be clickable
    $(board).find('.col-1').on('click', function(e) {
      Board.do_move(1);
    });
    $(board).find('.col-2').on('click', function(e) {
      Board.do_move(2);
    });
    $(board).find('.col-3').on('click', function(e) {
      Board.do_move(3);
    });
    $(board).find('.col-4').on('click', function(e) {
      Board.do_move(4);
    });
    $(board).find('.col-5').on('click', function(e) {
      Board.do_move(5);
    });
    $(board).find('.col-6').on('click', function(e) {
      Board.do_move(6);
    });
    $(board).find('.col-7').on('click', function(e) {
      Board.do_move(7);
    });
  }

  // Public variables
  Board.variable = 1;
  
  // Public methods
  Board.init = function(){
    _addColumnBindings();
    _updateBoard();
  };

  Board.do_move = function (column_number) {
    console.log("Request for move in column: "+column_number)
    var move = "this is test"

    var success = function(move) { console.log("Created move "); }
    var failure = function(move) {
      console.log("Failed to create move")
    }

    dispatcher.trigger('game_syncs.move_game', move, success, failure);
  }
}( window.Board = window.Board || {}, jQuery ));