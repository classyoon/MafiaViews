# MafiaViews

A SwiftUI implementation of the Mafia party game for iOS devices. This project focuses on creating an engaging and easy-to-use interface for playing Mafia with friends.

## Game Flow

The game follows this sequence:

1. **Setup Phase**
   - Players are added
   - Roles are assigned (Mafia, Doctor, Detective, Townspeople)

2. **Game Loop**
   - **First Night**: Players discover their roles
   - **Day Phase**: 
     - News is presented about night events
     - Discussion period with timer
     - Voting to eliminate a suspect
     - Execution results shown
   - **Night Phase**:
     - Players take individual actions based on their roles
     - Mafia kill, Doctors protect, Detectives investigate
   - The loop continues until win conditions are met

3. **Game Over**
   - Mafia wins if they equal or outnumber the townspeople
   - Town wins if all mafia members are eliminated

## Navigation Flow

```
[Opens App]
> MafiaMenuView()
  [Hits play]
  > SetUpGameView()
    [Hits begin]
    > DuskView()
      [Tap]
      > PlayingView (Night phase)
        [Each player takes their turn]
        > DawnView()
          [Tap]
          > NewsView
            [Tap]
            > DiscussionView()
              [Timer ends or Skip pressed]
              > PlayingView (Day phase - voting)
                [All players vote]
                > DuskView()
                  [Game loop continues...]
                  
[At any point]
> PauseView
  [Resume/Restart options]
  
[When win condition met]
> GameOverView()
```

## Features

- **News System**: Reports game events with thematic text
- **Role-Based Actions**: Different interfaces based on player role
- **Pause Functionality**: Pause and resume game at any point
- **Day/Night Cycle**: Visual transitions between game phases
- **Discussion Timer**: Timed discussion phase
- **Voting System**: Town voting mechanism
- **Notes**: Personal notes for each player
- **Win Detection**: Automatically detects when a team has won

## Code Organization

- **AppSection**: Core app components
- **Mafia Game**: Game play views
- **MetaGame**: Setup, menu, and non-game components
- **Business**: Data models and game logic
- **Player SubView**: Reusable player UI components
- **Game**: Core game flow views
- **JSON**: JSON handling and data structures

## Technical Implementation

- **Observer Pattern**: Game state observers to update UI
- **MVVM Architecture**: View models handle business logic
- **Singleton Game Manager**: Central game state management
- **SwiftUI Navigation API**: For view transitions

## Future Enhancements

- Online multiplayer
- Custom roles and special abilities
- Game statistics and history
- Themes and customization
- Sound effects and music
