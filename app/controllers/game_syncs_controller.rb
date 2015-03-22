class GameSyncsController < WebsocketRails::BaseController

  def move_game
    puts "Calling move_game -> #{message.inspect}"

    Game.current.play(message)

    WebsocketRails[:players].trigger(:update_board, Game.current.grid )

    trigger_success message
  end

end