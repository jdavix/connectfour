class GameSyncController < WebsocketRails::BaseController
  def initialize_session
  end

  def move_game
    send_message :move_success, { "message" => "movement received" }, :namespace => :game_syncs
  end

end