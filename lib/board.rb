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
    new_square['content'].has_moved = true if new_square['content'].instance_variable_defined?(:@has_moved)
    sel_square['content'] = EmptySpace.new(sel_square['content'].pos)
    promote_pawn(new_square, cur_player)
    check_enpassant(sel_square, new_square, cur_player) if @original_board
  end

  def make_enpassant_move(sel_square, new_square, captured_pos)
    puts "making enpassant move"
    duplicate = sel_square['content'].dup
    duplicate.pos = new_square['content'].pos
    new_square['content'] = duplicate
    sel_square['content'] = EmptySpace.new(sel_square['content'].pos)
    find_square(captured_pos[0], captured_pos[1].to_i)['content'] = EmptySpace.new(captured_pos)
  end

  def make_castling_move(player, castling_rooks)
    king_sq = @board_array.select { |sq| (sq['content'].is_a?(King) && sq['content'].color == player) }[0]
    if castling_rooks.length == 1
      rook_sq = find_square(castling_rooks[0].pos[0], castling_rooks[0].pos[1].to_i)
    else
      choices = [castling_rooks[0].pos.join, castling_rooks[1].pos.join]
      rook_pos = $prompt.select('Choose rook', choices)
      rook_sq = find_square(rook_pos[0], rook_pos[1].to_i)
    end
    new_rook_square = rook_sq['column'] == 'a' ? find_square('d', rook_sq['row']) : find_square('f', rook_sq['row'])
    new_king_square = rook_sq['column'] == 'a' ? find_square('c', rook_sq['row']) : find_square('g', rook_sq['row'])
    make_move(rook_sq, new_rook_square, player)
    make_move(king_sq, new_king_square, player)
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

  def find_unmoved_pieces(cur_player)
    @board_array.select do |sq|
      sq['content'].instance_variable_defined?(:@has_moved) &&
        sq['content'].has_moved == false && sq['content'].color == cur_player
    end
        .map {|sq| sq['content']}
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

  def castling_rooks(cur_player)
    # Neither the king nor the chosen rook has previously moved.
    unmoved_classes = find_unmoved_pieces(cur_player).map {|piece| piece.class}
    return false unless unmoved_classes.include?(King) && unmoved_classes.include?(Rook)
    castlable_rooks = castlable_rooks(cur_player)
    castlable_rooks.empty? ? false : castlable_rooks
  end

  def castlable_rooks(cur_player)
    # There are no pieces between the king and the chosen rook.
    unmoved_king = find_unmoved_pieces(cur_player).select {|piece| piece.class == King}[0]
    unmoved_rooks = find_unmoved_pieces(cur_player).select {|piece| piece.class == Rook}
    unmoved_rooks.select do |rook|
      (any_piece_inbetween?(rook, unmoved_king) == false) &&
      (any_king_pos_check?(rook,unmoved_king) == false)
    end

  end

  def any_piece_inbetween?(rook, king)
    range = range_of_movement(rook, king)
    range_inbetween = range[1..-2]
    pieces_array = range_inbetween.map do |column|
                    find_square(column, rook.pos[1].to_i)['content']
                   end
    !pieces_array.all? {|piece| piece.is_a?(EmptySpace)}
  end

  def any_king_pos_check?(rook, king)
      range = range_of_movement(rook, king)
      range[0] == 'a' ? range.shift(2) : range.pop
      # go through range of movement and see if any of them are in check
      range.map! do |column|
        opp_player_capture_moves(rook.color).include?([column, rook.pos[1]])
      end
      range.any?
  end

  def range_of_movement(rook, king)
    range = [rook.pos[0], king.pos[0]].sort
    for i in (range[0].ord + 1)..(range[1].ord) - 1
      range << i.chr
    end
    range.sort
  end

  def in_check?(player)
    king_sq = @board_array.select { |sq| (sq['content'].is_a?(King) && sq['content'].color == player) }[0]
    opp_player_capture_moves = opp_player_capture_moves(player)
    opp_player_capture_moves.include?(king_sq['content'].pos)
  end

  def opp_player_capture_moves(player)
    opp_player = player == 'white' ? 'black' : 'white'
    @board_array.select do |sq|
      sq['content'].color == opp_player && sq['content'].class != Pawn
    end
                .map { |sq| sq['content'].moves_array }.flatten(1) +
    @board_array.select do |sq|
      sq['content'].color == opp_player && sq['content'].instance_of?(Pawn)
    end
                .map { |sq| sq['content'].capture_moves_array }.flatten(1)
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
