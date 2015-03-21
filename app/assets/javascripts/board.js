(function( Board, $ ) {
  // Private variables
  var board = '#board';
  var dispatcher = new WebSocketRails('localhost:3000/websocket');
  var channel = dispatcher.subscribe('players');
  
  // Private methods
  function _addUpdateBoardBinding(){
    channel.bind('update_board', function(data) {
      _updateBoard(data)
    });
  };

  function _addColumnBindings() {
    // Add triggers to HTML using jquery, so they can be clickable
    $(board).find('.col-1').on('click', function(e) {
      Board.doMove(1);
    });
    $(board).find('.col-2').on('click', function(e) {
      Board.doMove(2);
    });
    $(board).find('.col-3').on('click', function(e) {
      Board.doMove(3);
    });
    $(board).find('.col-4').on('click', function(e) {
      Board.doMove(4);
    });
    $(board).find('.col-5').on('click', function(e) {
      Board.doMove(5);
    });
    $(board).find('.col-6').on('click', function(e) {
      Board.doMove(6);
    });
    $(board).find('.col-7').on('click', function(e) {
      Board.doMove(7);
    });
  }

  // TODO: Test Board update
  function _updateBoard(boardData) {
    // boardData is expected to be a JSON object like:
    // {
    //   "1": {
    //     "1": 0,
    //     "2": 1,
    //     "3": 2,
    //     "4": 1,
    //     ...
    //     "RowNumber": PlayerNumber,
    //   },
    //   "2": {
    //     "1": 0,
    //     "2": 1,
    //     "3": 2,
    //     ...
    //     "RowNumber": PlayerNumber,
    //   },
    //   ...
    //   "ColumnNumber": {
    //      ...
    //   }
    // }
    $(boardData).each(function(columnIndex, rows) {
      $(rows).each(function(rowIndex, playerNumber) {
        $(".row-"+rowIndex+" .col-"+columnIndex).addClass("player-"+playerNumber)
      });
    });
  }

  // Public variables
  Board.variable = 1;
  
  // Public methods
  Board.init = function(){
    _addColumnBindings();
    _addUpdateBoardBinding();
  };

  Board.doMove = function (column_number) {
    console.log("Request for move in column: "+column_number)
    var move = "this is test"

    var success = function(move) { console.log("Created move "); }
    var failure = function(move) {
      console.log("Failed to create move")
    }

    dispatcher.trigger('game_syncs.move_game', move, success, failure);
  }
}( window.Board = window.Board || {}, jQuery ));