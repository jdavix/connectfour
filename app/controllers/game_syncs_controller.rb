class GameSyncsController < WebsocketRails::BaseController

  def move_game
    puts "Calling move_game -> #{message.inspect}"

    game_result = Game.current.play(message)


    WebsocketRails[:players].trigger(:update_board, {"grid" => Game.current.grid, "game_result" => game_result } )

    trigger_success message
  end

end