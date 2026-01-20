## Space Laser

<img width="640" height="480" alt="pico-8 screenshot" src="screenshot-rc-shooter.png" />

Small arcade shooter built with at [Recurse Center](https://www.recurse.com/) with [PICO-8](https://www.lexaloffle.com/pico-8.php) to try out using the Pico-8 fantasy console.
It features a ship that can move and shoot lasers at falling enemies. The lasers have a limited battery and they need to charge after a bit, making the game harder.
Complete the 10 levels with increasing difficulty to beat the game!

### Running the game

Clone the repo:
``` bash
git clone https://github.com/nadia-nh/rc-pico8-shoot-em-up.git
cd pico8-shoot-em-up
```

Run with PICO-8:

1. Using the free web editor
   
&nbsp; &nbsp; Open https://www.pico-8-edu.com/, click on the play button to start and type `ESC`.

&nbsp; &nbsp; Paste the contents of `exported.p8` and into the terminal that opened.

&nbsp; &nbsp; Type
```
  ESC
  SAVE game.p8
  LOAD game.p8
  RUN
```
&nbsp; &nbsp; This goes back to the terminal, saves and loads the game so it can be interpreted correctly,
and then runs it.

2. Using the desktop build

&nbsp; &nbsp; Open the app and type `FOLDER` to open an explorer window where games are loaded from.

&nbsp; &nbsp; Copy the `exported.p8.png` file to that folder.

&nbsp; &nbsp; Inside the app, type
```
  LOAD exported.p8.png
  RUN
```

Controls:
- Left / right / up / down – Move
- X – Fire laser (hold)
- Esc – Quit PICO-8 menu

### How the game works

The [PICO-8 lifecycle](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure) functions are:
- `_init()` – Runs once on startup, used for setting up constants, and initial state
- `_update()` – Runs every frame, used for moving the player and the enemies, handling collisions, and tracking the player's laser charge and cooldown
- `_draw()` – Runs after each update, used for rendering the sprites, displaying the player's life and the laser's battery charge status

The logic is organized across small cart files:
- *`00-main.p8`* – Ties everything together, calls player's, enemy's and scoring's lifecycle methods
- *`01-player_controls.p8`* – Handles player movement, drawing the ship and lasers, handles collisions with enemies, and draining and recharging of the laser battery
- *`02-enemy_controls.p8`* – Spawns enemies, handles movement, checks for laser hits
- *`03-scoring.p8`* – Tracks level, score, and remaining health, draws the hearts and horizontal laser meters
- *`04-utils.p8`* – Defines palette IDs, sprite indices, button constants, small helper methods

### Reference

- [PICO-8 Manual](https://www.lexaloffle.com/pico-8.php?page=manual) – General API and cartridge structure
- [Simple space shooter Pico-8 Mini Course](https://www.youtube.com/watch?v=0EUlGg9ie_Y) - Loosely followed this tutorial for structuring the code and as an asset drawing guide
