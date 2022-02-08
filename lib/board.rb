# frozen_string_literal: true

require_relative 'chess_pieces'

class Board
  attr_accessor :board_array, :original_board, :enpassant_captured_pos,
    :enpassant_capturing_pos, :enpassant_move

  def initialize(board_array = [], original_board = true)
    @board_array = board_array
    @original_board = original_board
    @enpassant_captured_pos = nil
    @enpassant_capturing_pos = nil
    @enpassant_move = nil
    return unless @board_array.empty?

    (1..8).each do |i|
      ('a'..'h').each do |j|
        @board_array << { 'column' => j, 'row' => i, 'content' => EmptySpace.new([j, i.to_s]) }
      end
    end
    init_board
  end

  def print_board
    rows = @board_array.each_slice(8).to_a
    puts "\n    #{[*'a'..'h'].join('   ')}\n"
    puts "  ┌#{"#{"\u2500" * 3}┬" * 7}#{"\u2500" * 3}┐ BLACK"
    rows.reverse.each do |row|
      print = row.map { |f| " #{f['content'].graphic} " }.join("\u2502")
      puts "#{row[0]['row']} │#{print}│ #{row[0]['row']}"
      puts "  ├#{"#{"\u2500" * 3}┼" * 7}#{"\u2500" * 3}┤" unless row[0]['row'] == 1
    end
    puts "  └#{"#{"\u2500" * 3}┴" * 7}#{"\u2500" * 3}┘  WHITE"
    puts "    #{[*'a'..'h'].join('   ')}\n\n"
  end

  def calc_all_moves(cur_player = nil)
    @board_array.each do |square|
      square['content'].calc_moves(self)
    end
    check_invalid_move(cur_player) if @original_board
    add_enpassant_move unless @enpassant_move.nil?
  end

  def add_enpassant_move
    @enpassant_capturing_pos.each do |pos|
      (find_square(pos[0], pos[1].to_i))['content'].moves_array.push(@enpassant_move)
    end
  end

  def check_invalid_move(cur_player)
    temp_array = @board_array.dup.map do |square|
      square['content'].calc_moves(self)
      if square['content'].instance_of?(EmptySpace) || square['content'].color != cur_player
        square.dup
      elsif square['content'].instance_of?(Pawn)
        temp_square = square.dup
        temp_square['content'].moves_array.keep_if do |move|
          puts_yourself_check?(move, square['content'].pos) == false
        end
        temp_square['content'].capture_moves_array
        temp_square['content'].capture_moves_array.keep_if do |move|
          puts_yourself_check?(move, square['content'].pos) == false
        end
        temp_square
      else
        temp_square = square.dup
        temp_square['content'].moves_array.keep_if do |move|
          puts_yourself_check?(move, square['content'].pos) == false
        end
        temp_square
      end
    end
    @board_array = temp_array.dup
  end

  def puts_yourself_check?(move, pos)
    copy_board_array = (@board_array.map do |sq|
      sq['content'] = sq['content'].dup
      sq.dup
    end)
    temp_board = Board.new(copy_board_array, false)
    sel_square = temp_board.find_square(pos[0], pos[1].to_i)
    new_square = temp_board.find_square(move[0], move[1].to_i)
    temp_board.make_move(sel_square, new_square, sel_square['content'].color)
    temp_board.calc_all_moves
    temp_board.in_check?(new_square['content'].color)
  end

  def init_board
    create_setup
    @init_setup.each do |piece|
      init_piece(piece[0], piece[1], piece[2])
    end
  end

  def init_piece(column, row, content)
    @board_array.collect! do |pos|
      pos['content'] = content if pos['row'] == row && pos['column'] == column
      pos
    end
  end

  def make_move(sel_square, new_square, cur_player)
    duplicate = sel_square['content'].dup
    duplicate.pos = new_square['content'].pos
    new_square['content'] = duplicate
    sel_square['content'] = EmptySpace.new(sel_square['content'].pos)
    promote_pawn(new_square, cur_player)
    check_enpassant(sel_square, new_square, cur_player) if @original_board
  end

  def make_enpassant_move(sel_square, new_square, cur_player)
    # add content
  end

  def check_enpassant(sel_square, new_square, cur_player)
    return unless new_square['content'].class == Pawn
    return unless (sel_square['row'] - new_square['row']).abs == 2
    pawn_positions = adjacent_opp_pawns(new_square['column'], new_square['row'], cur_player)
    return if pawn_positions.empty?
    @enpassant_captured_pos = new_square['content'].pos
    @enpassant_capturing_pos = pawn_positions
    @enpassant_move = [new_square['column'], ((sel_square['row'] + new_square['row']) / 2).to_s, 'en passant']

  end

  def adjacent_opp_pawns(column, row, cur_player)
    columns = []
    [-1, 1].each {|direction| columns << (column.ord + direction).chr}
    columns.select! {|column| column =~ /[abcdefgh]/ }
    pawn_positions = (columns.map do |column|
              sq_occ_by_opp?(column, row, cur_player)? find_square(column, row)['content'].pos : nil
            end)
              .compact
  end

  def promote_pawn(sq, cur_player)
    if cur_player == 'white' && sq['content'].is_a?(Pawn) && sq['row'] == 8
      sq['content'] = Queen.new("#{sq['column']}#{sq['row']}", 'white')
    end
    return unless cur_player == 'black' && sq['content'].is_a?(Pawn) && sq['row'] == 1

    sq['content'] = Queen.new("#{sq['column']}#{sq['row']}", 'black')
  end

  def find_square(column, row)
    @board_array.select { |sq| (sq['column'] == column && sq['row'] == row) }[0]
  end

  def sq_occ_by?(column, row, color)
    find_square(column, row)['content'].color == color
  end

  def sq_occ_by_opp?(column, row, color)
    case color
    when 'black'
      find_square(column, row)['content'].color == 'white'
    when 'white'
      find_square(column, row)['content'].color == 'black'
    end
  end

  def in_check?(player)
    opp_player = player == 'white' ? 'black' : 'white'
    king_sq = @board_array.select { |sq| (sq['content'].is_a?(King) && sq['content'].color == player) }[0]
    opp_player_capture_moves = @board_array.select do |sq|
                                 sq['content'].color == opp_player && sq['content'].class != Pawn
                               end
                                           .map { |sq| sq['content'].moves_array }.flatten(1) +
                               @board_array.select do |sq|
                                 sq['content'].color == opp_player && sq['content'].instance_of?(Pawn)
                               end
                                           .map { |sq| sq['content'].capture_moves_array }.flatten(1)
    opp_player_capture_moves.include?(king_sq['content'].pos)
  end

  def checkmate?(cur_player)
    cur_player_moves = @board_array.select do |sq|
                         sq['content'].color == cur_player
                       end
                                   .map { |sq| sq['content'].moves_array }.flatten(1)
    in_check?(cur_player) && cur_player_moves.empty? ? true : false
  end

  def stalemate?(cur_player)
    cur_player_moves = @board_array.select do |sq|
      sq['content'].color == cur_player
    end
                                   .map { |sq| sq['content'].moves_array }.flatten(1)
    in_check?(cur_player) == false && cur_player_moves.empty? ? true : false
  end

  def create_setup
    @init_setup = [
      ['a', 1, Rook.new('a1', 'white')],
      ['b', 1, Knight.new('b1', 'white')],
      ['c', 1, Bishop.new('c1', 'white')],
      ['d', 1, Queen.new('d1', 'white')],
      ['e', 1, King.new('e1', 'white')],
      ['f', 1, Bishop.new('f1', 'white')],
      ['g', 1, Knight.new('g1', 'white')],
      ['h', 1, Rook.new('h1', 'white')],
      ['a', 8, Rook.new('a8')],
      ['b', 8, Knight.new('b8')],
      ['c', 8, Bishop.new('c8')],
      ['d', 8, Queen.new('d8')],
      ['e', 8, King.new('e8')],
      ['f', 8, Bishop.new('f8')],
      ['g', 8, Knight.new('g8')],
      ['h', 8, Rook.new('h8')]
    ]
    [*'a'..'h'].each do |column|
      @init_setup << [column, 2, Pawn.new("#{column}2", 'white')]
      @init_setup << [column, 7, Pawn.new("#{column}7")]
    end
  end
end
