class GameSyncsController < WebsocketRails::BaseController

  def move_game
    @game = Game.current
    puts "LAST TURN:"
    puts @game.current_turn
    if @game.current_turn.nil? || @game.current_turn == message["player"]
      game_result = @game.play(message)
      WebsocketRails[:players].trigger(:update_board, {"grid" => @game.grid, "game_result" => game_result } )
      trigger_success message
    else
      trigger_failure("Wait, it is Player #{@game.current_turn} Turn")
    end
  end

end