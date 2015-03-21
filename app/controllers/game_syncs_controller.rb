class GameSyncsController < WebsocketRails::BaseController
  def initialize_session
  end

  def move_game
    puts "Calling move_game"
    # send_message :move_game_success, { "message" => "movement received" }, :namespace => :game_syncs
    WebsocketRails[:players].trigger(:update_board, "this is from server")
    trigger_success message
  end

end