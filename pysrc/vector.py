
class Vec2:
    """
    2D vector funcname
    """
    def __init__(self, xv, y) -> None:
        try:
            self.x = xv.x
            self.y = xv.y
        except AttributeError:
            self.x = xv
            self.y = y
    def __add__(self, v):
        try:
            return Vec2(self.x + v.x, self.y + v.y)
        except AttributeError:
            if type(v) == int:
                return Vec2(self.x + v, self.y + v)

    def __mul__(self, v):
        try:
            return Vec2(self.x * v.x, self.y * v.y)
        except AttributeError:
            if type(v)== int:
                return Vec2(self.x * v, self.y * v)
    def __iadd__(self, v):
        self.__add__(v)
    def __imul__(self, v):
        self.__mul__(v)
    def __repr__(self) -> str:
        return self.__str__()
    def __str__(self) -> str:
        return f"Vec2({self.x}, {self.y})"
    def __eq__(self, o) -> bool:
        return all([type(o) == Vec2, self.x == o.x, self.y == o.y])
    def __hash__(self) -> int:
        return hash(self.x*self.y+self.x+self.y)
    def delta(self, v):
        return Vec2(v.x - self.x, v.y - self.y)