import itertools as it
import sys, pygame
pygame.init()

size = width, height = 1800, 900
speed = [1, 1]
black = [0, 0, 0]
white = [255,255,255]
tilesize = [100, 100]
screen = pygame.display.set_mode(size)
clock = pygame.time.Clock()

tile_rects = {"White" : [], "Black" : []}
_blacktile = pygame.image.load("assets/blacktile.png").convert()
_whitetile = pygame.image.load("assets/whitetile.png").convert()
_pieces = {
    'pawn'   : pygame.image.load('assets/pawn.png').convert(),
    'rook'   : pygame.image.load('assets/rook.png').convert(),
    'knight' : pygame.image.load('assets/knight.png').convert(),
    'bishop' : pygame.image.load('assets/bishop.png').convert(),
    'queen'  : pygame.image.load('assets/queen.png').convert(),
    'king'   : pygame.image.load('assets/king.png').convert()
}

def create_tile_rects():
    gentiles = it.cycle([("Black",_blacktile), ("White",_whitetile)])
    board = {}
    for y in range(8):
        next(gentiles)
        for x in range(8):
            color, _tile = next(gentiles)
            tr = _tile.get_rect()
            board[(x,y)] = [tilesize[0] * x, tilesize[1] * y]
            tr = tr.move(board[(x,y)])
            tile_rects[color].append(tr)
    return board


board = create_tile_rects()
ballrect = _pieces['king'].get_rect()

while 1:
    clock.tick(60)
    try:
        for event in pygame.event.get():
            if event.type == pygame.QUIT: sys.exit()
    except SystemExit:
        break


    #ballrect = ballrect.move(speed)
    #if ballrect.left < 0 or ballrect.right > width:
    #    speed[0] = -speed[0]
    #if ballrect.top < 0 or ballrect.bottom > height:
    #    speed[1] = -speed[1]


    screen.fill(black)
    for tcolor in tile_rects:
        for tilerect in tile_rects[tcolor]:
            if tcolor == "White":
                screen.blit(_whitetile, tilerect)
            elif tcolor =="Black":
                screen.blit(_blacktile, tilerect)
    
    screen.blit(_pieces['king'], ballrect)
    pygame.display.flip()