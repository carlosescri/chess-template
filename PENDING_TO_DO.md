# The following are a list of things that the program does badly right now

- White can play endless turns right now
- Pawns and king cant move. The rest of the figures can move
- Collisions are not implemented. A queen would be allowed to move to a square even if a figure is in its way
- Win condition is not implemented


# The following is a list of things that I've done and I think is worth mentioning

- Accessing to a new game assigns you as white
- Accessing again in a new browser assigns you as black
- Further accessings assigns you as a viewer

- My turn's first click on a piece of mine highlights it
- If in my second click I click a different piece of mine (because I may have changed my mind), it highlights this one and removes the highlight for the previous one
- If in my second click I click on a valid square, it moves
- If that move means an enemy piece dies, it works

(All this can be tested using the white knight)
