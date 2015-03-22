class GamesController < ApplicationController
  def index
  end

  def player
    @current_player = params[:id]
    @last_board     = Game.current.grid.to_json

    @player_turn = 1 # The owner of the current turn

    render :game
  end

end