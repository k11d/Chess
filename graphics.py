#pylint: disable=no-member
import itertools as it
import sys, pygame
pygame.init()
from vector import VecX
from tiles import GenTiles


size = VecX(1800, 900)
speed = VecX(1,1)
background = VecX(60,60,60)
white = VecX(255,255,255)
tilesize = VecX(100, 100)


screen = pygame.display.set_mode(size.list())
clock = pygame.time.Clock()

_piece_sprites = {
    'pawn'   : pygame.image.load('assets/pawn.png').convert(),
    'rook'   : pygame.image.load('assets/rook.png').convert(),
    'knight' : pygame.image.load('assets/knight.png').convert(),
    'bishop' : pygame.image.load('assets/bishop.png').convert(),
    'queen'  : pygame.image.load('assets/queen.png').convert(),
    'king'   : pygame.image.load('assets/king.png').convert()
}
_start = """
r n b q k b n r
p p p p p p p p
- - - - - - - -
- - - - - - - -
- - - - - - - -
- - - - - - - -
P P P P P P P P
R N B Q K B N R
"""
tiles  = {} # grid_position -> tile_obj
pieces = {} # grid_position -> piece_obj

######

class GridPosition(VecX):
    pass


def new_piece(pname, position):
    p,pr = _piece_sprites[pname], _piece_sprites[pname].get_rect()
    pr = pr.move(tilesize.x * position.x, tilesize.y * position.y)
    return p,pr

def create_tile_rects():
    gentiles = GenTiles()
    for y in range(8):
        gentiles.next()
        for x in range(8):
            gpos = GridPosition(x,y)
            tiles[gpos] = gentiles.next()(gpos, tilesize)


create_tile_rects()
p,pr = new_piece('rook', GridPosition(1,1))

while 1:
    try:
        for event in pygame.event.get():
            if event.type == pygame.QUIT: sys.exit()
    except SystemExit:
        break

    screen.fill(background.list())
    for n, tile in enumerate(tiles.values()):
        screen.blit(tile.tile_surface, tile.tile_rect)
    
    #screen.blit(p, pr)
    pygame.display.update()

    print(pygame.mouse.get_pos())
    clock.tick(30)
