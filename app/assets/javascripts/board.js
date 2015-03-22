(function( Board, $ ) {
  // Private variables
  var board      = '#board';
  var dispatcher = new WebSocketRails('localhost:3000/websocket');
  var channel    = dispatcher.subscribe('players');
  
  Board.current_player = null;


  // Public methods
  Board.init = function(){
    _loadPlayer();
    _addColumnBindings();
    _addUpdateBoardBinding();
  };

  Board.doMove = function (player, column_number) {
    console.log("move in column: "+column_number+" from player "+player)

    var move = {
                 player: player,
                 column:  column_number
               }

    var success = function(move) { console.log("Created move "); }

    var failure = function(move) {
      console.log("Failed to create move")
      console.log(move)
    }

    dispatcher.trigger('game_syncs.move_game', move, success, failure);
  }

  // Private methods
  function _addUpdateBoardBinding(){
    channel.bind('update_board', function(data) {
      _updateBoard(data)
    });
    _updateBoard($.parseJSON($("#last_board").val()));
  };

  function _addColumnBindings() {
    
    // Add triggers to HTML using jquery, so they can be clickable
    $(board).find('.col-1').on('click', function(e) {
      Board.doMove(Board.current_player, 1);
    });
    $(board).find('.col-2').on('click', function(e) {
      Board.doMove(Board.current_player, 2);
    });
    $(board).find('.col-3').on('click', function(e) {
      Board.doMove(Board.current_player, 3);
    });
    $(board).find('.col-4').on('click', function(e) {
      Board.doMove(Board.current_player, 4);
    });
    $(board).find('.col-5').on('click', function(e) {
      Board.doMove(Board.current_player, 5);
    });
    $(board).find('.col-6').on('click', function(e) {
      Board.doMove(Board.current_player, 6);
    });
    $(board).find('.col-7').on('click', function(e) {
      Board.doMove(Board.current_player, 7);
    });
  }

  function _updateBoard(boardData) {
    console.log("updating board")
    console.log(boardData)
    $.each(boardData, function(row, columns) {
      $.each(columns, function(column, playerNumber) {

        $( "#row-"+(row)+" .col-"+(column)).removeClass("player-0");
        $( "#row-"+(row)+" .col-"+(column)).removeClass("player-1");
        $( "#row-"+(row)+" .col-"+(column)).removeClass("player-2");

        $( "#row-"+(row)+" .col-"+(column)).addClass("player-"+playerNumber);
      });
    });
  }

  function _loadPlayer() {
    Board.current_player = $("#player_id").val();
  }


}( window.Board = window.Board || {}, jQuery ));