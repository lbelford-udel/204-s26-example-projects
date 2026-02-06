# internship-farming-game

9/2 - Farming tile distance 
Version 0.0.1
    - Very basic version of the game
    - Blank title screen with buttons to play the game or quit the program
    - Basic sprite that can move around (no jumping or gravity)
    - Farming tile that player can click when close to "till" it for future planting 

10/8 - Version 0.0.2
    - Basic implementation of Game State system 
    - Inventory system 
        - can pickup items 
        - the amount is tracked 
        - big inventory menu and a hot bar 
        - active item is tracked 
    - Basic player movement 
    - Dialogue system 
        - clicking on a npc brings up their text lines 
Key:

# G
Anything related to game states 
Mainly in the GameState script 

# I 
Anything related to the inventory system 
# I1
Hiding and showing active slots based on when the main inventory screen is open. 
# I2 
Removing items from the inventory system 

# D 
Anything related to the dialogue system

# D1 
Passing between the three dialogue scripts 

# D2 
Parsing the text file into readable lines and seperating them 