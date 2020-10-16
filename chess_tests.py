#!/usr/bin/env python3

from itertools import chain, groupby
from math import inf

from constants import *
from vector import Vec2


from utils import call_timer
timing_log = {}

####

class Movement:
    CELL_DIMENSIONS = [10, 10]
    UP = Vec2(0, -1)
    DOWN = Vec2(0,  1)
    RIGHT = Vec2(1,  0)
    LEFT = Vec2(-1, 0)

    _UNDEFINED_START = Vec2(inf, inf)

    def __init__(self, start=None, cell_dimensions=CELL_DIMENSIONS) -> None:
        if start is None:
            self.start_position = self._UNDEFINED_START
        else:
            self.start_position = start
        self.cell_dimensions = cell_dimensions
        self.UP_real = self.UP * self.cell_dimensions.x
        self.DOWN_real = self.DOWN * self.cell_dimensions.x
        self.RIGHT_real = self.RIGHT * self.cell_dimensions.y
        self.LEFT_real = self.LEFT * self.cell_dimensions.y

    def _mv(self, direction_unit_vector, n):
        def inner(start):
            if type(start) != Vec2:
                if type(start) == int:
                    start = Vec2(start, start)
                elif len(start) == 2:
                    start = Vec2(x=start[0], y=start[1])
            return start + direction_unit_vector * n
        if self.start_position != self._UNDEFINED_START:
            return inner(self.start_position)
        return inner

    def up(self, n=1):
        return self._mv(self.UP, n)

    def down(self, n=1):
        return self._mv(self.DOWN, n)

    def left(self, n=1):
        return self._mv(self.UP, n)

    def right(self, n=1):
        return self._mv(self.DOWN, n)

#####

class ChessPiece:
    @classmethod
    def as_white(cls, position):
        return cls(position, "White")
    @classmethod
    def as_black(cls, position):
        return cls(position, "Black")
    
    def __repr__(self):
        return self.__str__()
    
    def __str__(self):
        return f"{self.color} {self.__class__.__name__}"

    def __init__(self, start_position, color) -> None:
        self.color = color
        if type(start_position) != Vec2 and len(start_position) == 2:
            self.position = Vec2(*start_position)
        else:
            self.position = start_position

    def show_methods(self):
        print("\n".join(s for s in Movement().__dir__() if not s.startswith('_')))
##
class Rook(ChessPiece):
    pass
class Queen(ChessPiece):
    pass
class King(ChessPiece):
    pass
class Bishop(ChessPiece):
    pass
class Knight(ChessPiece):
    pass
class Pawn(ChessPiece):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.never_moved = True
    def available_moves(self):
        moves = []
        if self.color == "White":
            moves.append(self.up(self.position))
            if self.never_moved:
                moves.append(self.up(self.position, 2))
        else:
            moves.append(self.down())
            if self.never_moved:
                moves.append(self.down(self.position, 2))
        kept = []
        for p in moves:
            print(p)
            

    
def new_game(start_positions=STARTING_POSITIONS):
    """start_positions : Dict[str, Dict[str, List[List[int]]]]"""

    # initiate sets of pieces
    white_pieces = {}
    black_pieces = {}
    for pcolor in start_positions:
        for pname, positions in start_positions[pcolor].items():
            for pos in positions:
                pos = Vec2(pos[0], pos[1])
                if pname == "Pawn":
                    white_pieces[pos] = Pawn(pos, pcolor)
                elif pname == "Rook":
                    white_pieces[pos] = Rook(pos, pcolor)
                elif pname == "Bishop":
                    white_pieces[pos] = Bishop(pos, pcolor)
                elif pname == "Queen":
                    white_pieces[pos] = Queen(pos, pcolor)
                elif pname == "King":
                    white_pieces[pos] = King(pos, pcolor)
                elif pname == "Knight":
                    white_pieces[pos] = Knight(pos, pcolor)
    # constuct a board
    board = {}
    for pos in white_pieces:
        board[pos] = white_pieces[pos]
    for pos in black_pieces:
        board[pos] = black_pieces[pos]
    
    # fill up remaining positions with empty placeholders
    def _2dgrid():
        for y in range(8):
            for x in range(8):
                yield Vec2(x,y)
    for pos in _2dgrid():
        if pos in board:
            # print(f"{board[pos]} is at {pos}")
            continue
        else:
            board[pos] = None
    return board


@call_timer(timing_log)
def board_analyzer(gboard):
    allys = {}
    enemy = {}
    free = []
    for pos in gboard:
        if gboard[pos]:
            if hasattr(gboard[pos], "color"):
                if gboard[pos].color == "Black":
                    enemy[pos] = gboard[pos]
                elif gboard[pos].color == "White":
                    allys[pos] = gboard[pos]
            else:
                free.append(pos)
        else:
            free.append(pos)
    return allys, enemy, free


@call_timer(timing_log)
def white_to_pick(game_board):
    a,e,f = board_analyzer(game_board)
    print("Mine:", a)
    print("#"*8)
    print("Enemy's:", e)
    print("#"*8)
    print("Free: ", f)
    print("#"*8)

# pwhite = Pawn.as_white(Vec2(0,6))
# pblack = Pawn.as_black(Vec2(0,1))
# print(pwhite)
# print(pblack)
# # p.show_methods()
# mw = Movement(pwhite.position)
# mb = Movement(pblack.position)
# m = Movement()

game_board = new_game()
white_to_pick(game_board)
