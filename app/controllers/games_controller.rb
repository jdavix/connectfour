class GamesController < ApplicationController
  def index
  end

  def player
    @current_player = params[:id]
    @player_turn = 1 # The owner of the current turn
    render :game
  end

end