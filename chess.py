#!/usr/bin/env python3

import itertools
import random
from itertools import chain
from pieces import Movement
from vector import Vec2

from constants import STARTING_POSITIONS, SCORE_VALUES
from pieces import Pawn, Bishop, Rook, Knight, King, Queen
from utils import call_timer, TimingData

timing_log = TimingData()


####

#####

class Game:

    DEBUG = False

    def __init__(self) -> None:
        self._board = {}
        self._now_playing = "White"
        self.white_captured = []
        self.black_captured = []


    def __repr__(self) -> str:
        s = ""
        for y in range(8):
            for x in range(8):
                bp = self._board[Vec2(x,y)]
                if bp:
                    if bp.__class__.__name__ == "Knight":
                        if bp.color == "Black":
                            s += "n "
                        else:
                            s += "N "
                    else:
                        if bp.color == "Black":
                            s += bp.__class__.__name__[0].lower() + " "
                        else:
                            s += bp.__class__.__name__[0] + " "
                else:
                    s += "- "
            s += " \n"
        return s

    def show_board(self, board) -> None:
        print(self.__repr__())
    
    def get_at(self, pos):
        return self._board[pos]

    def new_game(self, start_positions=STARTING_POSITIONS):
        """start_positions : Dict[str, Dict[str, List[List[int]]]]"""

        # initiate sets of pieces
        for pcolor in start_positions:
            for pname, positions in start_positions[pcolor].items():
                for pos in positions:
                    pos = Vec2(pos[0], pos[1])
                    if pname == "Pawn":
                        self._board[pos] = Pawn(pos, pcolor)
                    elif pname == "Rook":
                        self._board[pos] = Rook(pos, pcolor)
                    elif pname == "Bishop":
                        self._board[pos] = Bishop(pos, pcolor)
                    elif pname == "Queen":
                        self._board[pos] = Queen(pos, pcolor)
                    elif pname == "King":
                        self._board[pos] = King(pos, pcolor)
                    elif pname == "Knight":
                        self._board[pos] = Knight(pos, pcolor)

        # fill up remaining positions with empty placeholders
        def _2dgrid():
            return (Vec2(x,y)
                    for y in range(8)
                    for x in range(8)
            )

        for pos in _2dgrid():
            if not (pos in self._board):
                self._board[pos] = None
        return self, self._board

    @call_timer(timing_log)
    def board_analyzer(self, gboard):
        allys = {}
        enemy = {}
        free = {}

        for pos in gboard:
            if gboard[pos] and hasattr(gboard[pos], "color"):
                piece_color = gboard[pos].color
                if (piece_color != self._now_playing):
                    enemy[pos] = gboard[pos]
                else:
                    allys[pos] = gboard[pos]
            else:
                free[pos] = None
        if self.DEBUG:
            print("Mine:", allys)
            print("#"*24)
            print("Enemy's:", enemy)
            print("#"*24)
            print("Free: ", free)
            print("#"*24)
        return allys, enemy, free

    @call_timer(timing_log)
    def player_pick_piece(self, game_board, method=Movement.LEAST_MOVES):
        # parse the game board
        a,e,f = self.board_analyzer(game_board)
        moves_by_pos = {}
        piece_by_pos = a
        for pos in a:
            try:
                all_mvs = a[pos].available_moves(a,e,f)
                if all_mvs:
                    moves_by_pos[pos] = all_mvs
            except Exception as ex:
                print(ex)
                continue
        
        # choose piece to play
        if method == Movement.RANDOM:
            p = random.choice([*moves_by_pos.keys()])
            return piece_by_pos[p], moves_by_pos[p]

        elif method == Movement.LEAST_MOVES:
            # choose piece with the least moves
            ch_moves_count = 0
            ch_piece = None
            for pos in piece_by_pos:
                if ch_piece and ch_moves_count == 1:
                    break
                if len(moves_by_pos[pos]) > 0 and len(moves_by_pos[pos]) < ch_moves_count or ch_moves_count == 0:
                    ch_piece = piece_by_pos[pos] 
                    ch_moves_count = len(moves_by_pos[pos])
            return ch_piece, moves_by_pos[ch_piece.position]
        
        
    @call_timer(timing_log)
    def player_play(self, board):
        piece, moves = self.player_pick_piece(board)
        fromp = piece.position
        top = random.choice(moves)
        piece.position = top
        if captured := board[top]:
            if self._now_playing == "White":
                self.white_captured.append(captured)
            else:
                self.black_captured.append(captured)
        board[top], board[fromp] = board[fromp], None
        if self._now_playing == "White":
            self._now_playing = "Black"
        else:
            self._now_playing = "White"

game, board = Game().new_game()
while True:
    game.player_play(board)
    game.show_board(board)
    try:
        u = input("ENTER to continue - CTRL-C to quit")
        if 'q' in u:
            break
    except KeyboardInterrupt:
        print()
        break
