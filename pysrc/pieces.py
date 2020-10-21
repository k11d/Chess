from math import inf
from vector import Vec2


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
        self.UP_real = self.UP * self.cell_dimensions[0]
        self.DOWN_real = self.DOWN * self.cell_dimensions[0]
        self.RIGHT_real = self.RIGHT * self.cell_dimensions[1]
        self.LEFT_real = self.LEFT * self.cell_dimensions[1]

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
        return self._mv(self.LEFT, n)

    def right(self, n=1):
        return self._mv(self.RIGHT, n)
    
    def left_up(self):
        return self.start_position + (self.left().delta(self.start_position) + self.up().delta(self.start_position))

    def left_down(self):
        return self.start_position + (self.left().delta(self.start_position) + self.down().delta(self.start_position))
    
    def right_up(self):
        return self.start_position + (self.right().delta(self.start_position) + self.up().delta(self.start_position))
    
    def right_down(self):
        return self.start_position + (self.right().delta(self.start_position) + self.down().delta(self.start_position))


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
        return f"{self.color} {self.__class__.__name__} - {id(self)}"
    def __init__(self, p, color) -> None:
        self.color = color
        if type(p) != Vec2 and len(p) == 2:
            self.position = Vec2(*p)
        else:
            self.position = p
    def is_in_bound(self, p):
        if p:
            return all([p.x >= 0,  p.y >= 0,  p.x <= 7,  p.y <= 7])

    def show_methods(self):
        print("\n".join(s for s in Movement().__dir__() if not s.startswith('_')))

##

class Rook(ChessPiece):

    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
    
    def available_moves(self):
        moves = []

        # to east
        m = Movement(self.position)
        tgt = m.right()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.right()
        
        # to west
        m = Movement(self.position)
        tgt = m.left()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.left()
        
        # to north
        m = Movement(self.position)
        tgt = m.up()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.up()
        
        # to south
        m = Movement(self.position)
        tgt = m.down()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.down()
        return moves


class Queen(ChessPiece):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self._rook = Rook(*args, **kwargs)
        self._bishop = Bishop(*args, **kwargs)
    
    def available_moves(self):
        return self._rook.available_moves() + self._bishop.available_moves()


class King(ChessPiece):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self._queen = Queen(*args, **kwargs)
    
    def available_moves(self):
        m = Movement(self.position)
        return [m.left(), m.right(), m.up(), m.down(),
                m.right_down(), m.right_up(), m.left_up(), m.left_down()]


class Bishop(ChessPiece):

    def available_moves(self):
        moves = []

        m = Movement(self.position)
        tgt = m.left_up()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.left_up()
        
        m = Movement(self.position)
        tgt = m.left_down()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.left_down()
    
        m = Movement(self.position)
        tgt = m.right_up()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.right_up()
    
        m = Movement(self.position)
        tgt = m.right_down()
        while self.is_in_bound(tgt):
            if tgt not in moves:
                moves.append(tgt)
            m = Movement(tgt)
            tgt = m.right_down()
        return moves


class Knight(ChessPiece):
    pass


class Pawn(ChessPiece):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.never_moved = True
    def available_moves(self):
        moves = []
        m = Movement(self.position)
        if self.color == "White":
            moves.append(m.up())
            if self.never_moved and self.is_in_bound(m.up(m.up())):
                moves.append(m.up(2))
        else:
            if self.is_in_bound(m.down()):
                moves.append(m.down())
                if self.never_moved and self.is_in_bound(m.down(m.down())):
                    moves.append(m.down(2))
        return moves

