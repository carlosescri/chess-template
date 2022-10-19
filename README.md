# Chess - Doofinder Code Challenge 2022

- **October 18 and 19, 2022 at the Doofinder offices at 63 Cronos Street**. 
- Starts the 18th at 12:00 and ends on the 19th at 12:00.
- The presentation and awards ceremony will be on the 19th at 15:30.

## Please, read me

**MAKE SURE YOU READ THE ENTIRE DOCUMENT AND PROPERLY UNDERSTAND IT BEFORE START CODING!!!**

## Challenge Rules

- Participation in the competition will be individual.
- It's mandatory that all devs participate except the jury.
- The jury will be made up of Antonio Gutiérrez, Carlos Escribano, Enrique Martínez and Manuel Dominguez.
- **When the time available to code the application is over, the code will be pushed to the dev's own fork. If the application is not finished, what has been done will be uploaded.**
- Each participant will show the application to the member of the jury he's assigned to for evaluation.

## Awards

The prizes will be Amazon gift cards (no more than one prize per project):

- **King Award:** €100
- **Queen Award:** €50
- **Bishop Award:** €50
- **Knight Award:** €50

## Project requisites

- Create a web application to play chess with another player in real time ([chess rules in Spanish](https://es.wikipedia.org/wiki/Leyes_del_ajedrez)).
- You must use Phoenix and Phoenix LiveView.
- There must be a graphical UI to perform chess movements.
- UI must be updated in real time.
- UI must display which player won the game, if any.
- Apart from the board, feel free to add user/game feedback and to decide how to display it.
- Any other enhancement will be taken into account for the final score.

### Scope

The idea is that two players should be able to play a single game. You can make reasonable simplifications, like:

- Create a game by accessing a random URL like `/game/:game_name`. Sharing that URL the other player would be able to join the game.
- The user that creates the game uses the white pieces.

### Chess Board

- There's a pre-defined chess board with styles you can use as a starting point. It looks like the one in the image below.
- Final HTML is provided, you are responsible of generating the HTML based on your project's data models.

![imagen](https://user-images.githubusercontent.com/482075/194532319-b5dc8969-2737-4546-9f39-d6dc2b3a92b7.png)

## Time to start coding!

1. Press the _Fork_ button at the top-right part of the page to create your own copy.

![imagen](https://user-images.githubusercontent.com/482075/194920831-23fb1e14-83c6-4327-a496-bde225a77561.png)

2. Fill in the details.
3. Clone your newly created repo.
4. Make sure you use at least Elixir 1.12 (asdf!).
5. Install dependencies.
6. Think.
7. Code.
8. Remember to push your code to your fork!!!

**IMPORTANT:** No other dependencies than those listed in `mix.exs` are allowed. Any extra dependency must be approved by the jury.

## Diagrams

```mermaid
classDiagram
    Game "1" --> "1..2" Player
    Game "1" --> "1" Board
    Board "1" --> "64" Square
    Player "1" --> "16" ChessPiece
    Square "1" --> "0..1" ChessPiece
    class Player{
        -int id
        -bool white
    }
    class ChessPiece{
        -int id
        -bool white
        -str type
    }
    class Square{
        -int id
        -bool white
        -int chesspiece_id
        -coordinates
    }
```
