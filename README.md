#  MafiaViews
So this is intended to be the project where I put together the mafia game views. I am trying to focus on making the view functional and encapsulated then I will take the busniess logic.

It should go like this. Note i am not aware of any official notation so I will include any user action in brackets. and then I will start any view with > and then a , if it is within any views then a : to end it. If there are () then that means there is a file with the visual codes on.
Exclamation marks mean something should be changed that isn't.

Also note that because I'm lazy some things may be missing. Be on your guard for missing stuff or details.

[Opens App]
>MafiaMenuView()
[Hits play]
>SetUpGameView()
!There needs to be an actual method to add and subtract players when needed and modify the role distribution!
[Hits begin]
>FirstDawnView()
[Tap]
>DayView
!For this first day since nobody has died, there should be no voting!
[Tap]
>DuskView()
!This will say something like "hand the device to [name of first player alive] turn. They will start"!
[Tap]
>PlayerCoverView
!This will say something like "it is now [name of next player] turn."!
[Tap]
>NightView
!This will look like day view except dark. There will be no option to skip. Once the player chooses a target and confirms their action it will return to playercoverview until all players have done their turn!
[Repeat until all players have made their actions]
>ConfirmNightView()
!This will allow any redos incase there were any accidents.
[Confirmed]
>DawnView()
[Tap]
>News !I am not sure how this will be presented!
[Tap]
>DiscussionView()
!There will be a timer!
>DayView
Players can choose someone to vote on or they can abstain. Once the player confirms their action it will return to playercoverview until all players have done their turn!
[Repeat until all players have made their actions]
>ConfirmVoteView()
!This is like confirm night view!
[Confirmed]
>ResultsView
!This will inform the players of the execution if it took place and who. Depending on the game settings, it may or may not share the role!
[Assuming no game over]
>DuskView()
[Game loop cycles]

[By the end of an execution or night if any team has met their win condition]
>GameOverView()

