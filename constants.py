#-*- coding: utf-8 -*-
# Constant data


STARTING_POSITIONS = {
    "White" : {
        "Pawn" : [[0,6], [1,6], [2,6], [3,6], [4,6], [5,6], [6,6], [7,6]],
        "Rook" : [[0,7], [7,7]],
        "Knight" : [[1,7], [6,7]],
        "Bishop" : [[2,7], [5,7]],
        "Queen": [[3,7]],
        "King" : [[4,7]],
    },
    "Black" : {
        "Pawn" : [[0,1], [1,1], [2,1], [3,1], [4,1], [5,1], [6,1], [7,1]],
        "Rook" : [[0,0], [7,0]],
        "Knight" : [[1,0], [6, 0]],
        "Bishop" : [[2,0], [5,0]],
        "Queen" : [[3, 0]],
        "King" : [[4, 0]]
    }
}


SCORE_VALUES = {
    "Pawn":1,
    "Rook":3,
    "Bishop":2,
    "Knight":4,
    "Queen" : 50,
}
