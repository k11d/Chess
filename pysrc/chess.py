#!/usr/bin/env python3

from itertools import chain, groupby
from pysrc.pieces import Movement
from vector import Vec2

from constants import *
from pieces import Pawn, Bishop, Rook, Knight, King, Queen
from utils import call_timer, TimingData

timing_log = TimingData()


####

#####

@call_timer(timing_log)
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
        return (Vec2(x,y)
                for y in range(8)
                for x in range(8)
        )

    for pos in _2dgrid():
        if not (pos in board):
            board[pos] = None
    return board


@call_timer(timing_log)
def board_analyzer(gboard):
    allys = {}
    enemy = {}
    free = {}
    for pos in gboard:
        if gboard[pos]:
            if hasattr(gboard[pos], "color"):
                if gboard[pos].color == "Black":
                    enemy[pos] = gboard[pos]
                elif gboard[pos].color == "White":
                    allys[pos] = gboard[pos]
            else:
                free[pos] = None
        else:
            free[pos] = None
    print("Mine:", allys)
    print("#"*24)
    print("Enemy's:", enemy)
    print("#"*24)
    print("Free: ", free)
    print("#"*24)
    return allys, enemy, free


@call_timer(timing_log)
def white_to_pick(game_board):
    a,e,f = board_analyzer(game_board)
    moves_by_piece = {}
    for pos in a:
        try:
            moves_by_piece[pos] = a[pos].available_moves()
        except Exception as e:
            print(e)
            continue
    print(moves_by_piece)
    print("####\n#a: ", a, "\n####\n#")



game_board = new_game()
white_to_pick(game_board)
# print(game_board[Vec2(3,7)].available_moves())
# print(game_board[Vec2(2,7)].available_moves())
print(game_board[Vec2(4,7)].available_moves())


m = Movement(game_board[Vec2(3,7)].position)
