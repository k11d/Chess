import pygame


_TILE_SIZE = [100,100]
_BLACK_TILE = pygame.image.load("assets/blacktile.png")
_WHITE_TILE = pygame.image.load("assets/whitetile.png")


class Tile:
    
    def __init__(self, tilesize):
        self.grid_position = []
        self.real_position = []
        self.tile_rect = None
        self.tilesize = tilesize

    def get_real_position(self, gpos=None):
        if gpos is None:
            gpos = self.grid_position
        return [gpos.x * self.tilesize.x, gpos.y * self.tilesize.y]

    def move_to(self, gpos):
        self.real_position = gpos
        if self.tile_rect is not None:
            # self.tile_rect = self.tile_surface.get_rect()
            self.tile_rect = self.tile_rect.move(self.get_real_position(gpos))


class WhiteTile(Tile):
    tcolor = "White"
    tile_surface = _WHITE_TILE

    def __init__(self, grid_position, tilesize=_TILE_SIZE):
        super().__init__(tilesize)
        self.grid_position = grid_position
        self.tile_rect = self.tile_surface.get_rect()
        self.tile_surface = WhiteTile.tile_surface
        self.move_to(grid_position)


class BlackTile(Tile):
    tcolor = "Black"
    tile_surface = _BLACK_TILE

    def __init__(self, grid_position, tilesize=_TILE_SIZE):
        super().__init__(tilesize)
        self.grid_position = grid_position
        self.tile_rect = self.tile_surface.get_rect()
        self.tile_surface = BlackTile.tile_surface
        self.move_to(grid_position)


class GenTiles:

    white = WhiteTile
    black = BlackTile
    
    def __init__(self):
        self.next_tile = self.black
    
    def next(self):
        self.next_tile = self.white \
            if self.next_tile is self.black \
            else self.black
        return self.next_tile

# wt = WhiteTile([0,0])
# bt = BlackTile([1,0])
# xt = BlackTile([4,6])
