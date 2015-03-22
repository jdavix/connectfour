class Game
  ROWS=6
  COLUMNS=7

  attr_accessor :grid
  attr_accessor :columns
  attr_accessor :last_move_row
  attr_accessor :last_move_column
  attr_accessor :winner
  attr_accessor :game_state

  @@game = Game.new

  def self.current
    #Singleton Pattern for the whole game
    @@game.load_from_cache
    return @@game
  end

  def initialize()
    start_grid()
    start_columns()
    @game_state = {}
  end

  def play(movement)
    #movement example = {"player"=>"2", "column"=>4}

    return @game_state if  @game_state["over"] == true

    movement_index = movement["column"].to_i - 1

    if @columns[ movement_index  ].size <  ROWS

      @columns[ movement_index ] << movement["player"]
      add_item_into_grid(movement)

      if winner?
        @game_state = { "over" => true, "state" => "winner", "winner" => @winner }
      else
        @game_state = { "over" => false, "state" => "playing" }
      end
    elsif is_it_a_draw?
      @game_state = { "over" => true, "state" => "draw" }
    end
    cache_state

    return @game_state
  end

  def count(x, y, horiz, vert, player)
    new_x = x
    new_x = x + 1 if horiz == :right
    new_x = x - 1 if horiz == :left
    new_y = y
    new_y = y + 1 if vert == :up
    new_y = y - 1 if vert == :down
    return 0 if new_x < 0 || new_x > 6 || new_y > 7 || new_y < 0 || @grid[new_x.to_s][new_y.to_s].to_s != player
    return 1 + count(new_x, new_y, horiz, vert, player)
  end

  #note: to determine the winner I have saved some time looking an existing 
  #algorithm and adapted to my implementation
  def winner?
    1.upto(6) do |x|
      1.upto(7) do |y|
        player = @grid[x.to_s][y.to_s].to_s
        next if player == "0"
        left_count = count(x, y, :left, :none, player)
        right_count = count(x, y, :right, :none, player)
        up_count = count(x, y, :none, :up, player)
        down_count = count(x, y, :none, :down, player)
        up_left_count = count(x, y, :left, :up, player)
        down_right_count = count(x, y, :right, :down, player)
        up_right_count = count(x, y, :right, :up, player)
        down_left_count = count(x, y, :left, :down, player)
        best_count = [left_count + right_count + 1, up_count + down_count + 1,
                      up_left_count + down_right_count + 1, up_right_count + down_left_count + 1].max
        if best_count >= 4
          return @winner ||= player
        end
      end
    end
    return nil
  end

  def is_it_a_draw?
    attempts = 0
    @columns.each{ |column|  attempts+= column.size}
    attempts == ROWS * COLUMNS
  end

  def load_from_cache
    if $redis.get("game_columns") && $redis.get("game_grid")
      @columns = JSON.parse($redis.get("game_columns"))
      @grid    = JSON.parse($redis.get("game_grid"))
      @game_state = JSON.parse($redis.get("game_state"))
    else
      start_grid()
      start_columns()
      @game_state = {}
    end
  end

  def restart
    $redis.del("game_columns")
    $redis.del("game_grid")
    $redis.del("game_state")
  end

  private_class_method :new

  private

    def start_grid
      @grid = { }
      ROWS.times { |row|
        @grid[(row+1).to_s] = { }
        COLUMNS.times { |column| @grid[(row+1).to_s][(column+1).to_s] = 0 }
      }
    end

    def start_columns
      @columns = []
      COLUMNS.times do
        @columns << []
      end
    end

    def add_item_into_grid(movement)
      @last_move_row    = last_row_for_column( movement["column"].to_i ).to_s
      @last_move_column = movement["column" ].to_s
      @grid[ @last_move_row ][ @last_move_column ] = movement["player"]
    end

    def last_row_for_column(column)
      ROWS - @columns[ column - 1 ].size + 1
    end

    def cache_state
      $redis.set( "game_columns", JSON.generate(@columns) )
      $redis.set( "game_grid", JSON.generate(@grid) )
      $redis.set( "game_state", JSON.generate(@game_state) )
    end
end