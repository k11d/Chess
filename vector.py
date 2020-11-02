#pylint: disable no-member
class _Vector(object):
    def list(self):
        return list(self.__ret())

    def tuple(self):
        return tuple(self.__ret())

    def __ret(self):
        for k, v in vars(self).items():
            if not any([k.startswith("_")]):
                yield v

    def __hash__(self, *values):
        if values:
            return hash(values)
        return hash("".join(map(str, self._ret())))
    
    def __repr__(self) -> str:
        return self.__str__()
    
    def __str__(self) -> str:
        return "VecX(" + ",".join(self.list()) + ')'
    
    def __eq__(self, v) -> bool:
        pass
    
    def delta(self, v):
        pass


class VecX(_Vector):

    def __init__(self, *components):

        def _gennames():
            n = ['a']
            while True:
                _col = len(n) - 1
                for s in map(chr, range(ord('a'), ord('z'), 1)):
                    n[_col] = s
                    yield "".join(n)
                n.append('a')
                
        self._dims = len(components) if type(components[0]) not in [list, tuple, VecX] else 1
        for aname, avalue in zip(_gennames(), components):
            setattr(self, aname, lambda:avalue)    
        print(f"\n\nVecX of dimension: {self._dims}, and values: {self.list()}")
        super().__init__()

v1 = VecX(1)
v2 = VecX(1,2)
v3 = VecX(1,2,3)
v3 = VecX(1,2,3)
v4 = VecX(1,2,3,42)
# v51 = VecX([1,2,3],[4,5,6])
print(v3.list())
print(v3.tuple())
print(v3.a())
print(v3.b())
print(v3.c())
print(v4.d())
