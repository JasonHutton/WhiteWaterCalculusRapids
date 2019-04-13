Comp8051

README file for Mr Marble's Maze

Controls:
	To roll the marble left, tilt the phone left
	To roll the marble right, tilt the phone right
	Note: the further you tilt the phone, the faster it will roll, max tilt angle is 45 degrees
	Tap the screen once to flip the gravity in the opposite direction (tilt still works the same way)
	
Objective:
	Survive for as long as possible by travelling down the maze and avoiding the falling lava wall (touching it will cause the game to end).
	The wall will accelerate as you pull away, but will slow down as it gets closer. It will also speed up over time until it reaches a maximum velocity.
	The wall is proceeded by a glowing warning light to alert the player of the lava's proximity.

Score system:
	The score starts at 0 and simply increases with time, the longer you survive, the higher your score will be.
	The game will save your 3 highest scores. The first time you open the game, all 3 will be set to zero. They will be replaced as you play more games.
	
Menus:
	There are 4 basic screens in our game	
		1. Main Menu: this contains 2 buttons, one goes to the instruction page, and the other starts the game. It also contains 3 labels for your 3 highest scores, these will be updated as you get higher scores. Lastly, there are 2 mute buttons on the top left hand corner, the music note mutes music, and the other mutes sound effects.
		2. Instruction Page: This has a text box with instructions on how to play and what the goal is. A back button is located at the bottom which returns you to the main menu.
		3. Game Screen: This is where the game is played, like the main menu it contains the same 2 mute buttons in the top left corner, they perform the same function. There is also an "x" button in the lower left hand corner, pressing this quits the game (note, this will mean your score for that game will be discarded)
		4. Game Over Screen: This screen comes up when the player loses, it displays the player's score, as well as whether they obtained a high score. It also contains a button to return to the main menu.

To Build:
	No special requirements, simply checkout master branch, then compile and run in Xcode.

Final Report is also in the repo