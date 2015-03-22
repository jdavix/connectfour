class Game
  ROWS=6
  COLUMNS=7

  attr_accessor :grid
  attr_accessor :columns

  @@game = Game.new

  def self.current
    #Singleton Pattern for the whole game
    @@game.load_from_cache
    return @@game
  end

  def initialize()
    start_grid()
    start_columns()
  end

  def play(movement)
    #movement example = {"player"=>"2", "column"=>4}
    movement_index = movement["column"].to_i - 1

    if @columns[ movement_index  ].size <  ROWS
      @columns[ movement_index ] << movement["player"]
      add_item_into_grid(movement)
    end
    cache_state
  end

  def load_from_cache
    if $redis.get("game_columns") && $redis.get("game_grid")
      @columns = JSON.parse($redis.get("game_columns"))
      @grid    = JSON.parse($redis.get("game_grid"))
    else
      start_grid()
      start_columns()
    end
  end

  private_class_method :new


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
      row    = last_row_for_column( movement["column"].to_i ).to_s
      column = movement["column" ].to_s
      @grid[ row ][ column ] = movement["player"]
    end

    def last_row_for_column(column)
      ROWS - @columns[ column - 1 ].size + 1
    end

    def cache_state
      $redis.set( "game_columns", JSON.generate(@columns) )
      $redis.set( "game_grid", JSON.generate(@grid) )
    end
end