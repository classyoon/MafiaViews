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
>DuskView()
!The dusk view is not actually supposed to be the first view but since it is so similiar to the dawn view, I figure they can probably be made in a way that makes less repeition!
[Tap]
>PlayingView()
!The notes feature is a bit cramped. I may want to revisit it.!
[Tap]
>DuskView()
[Tap]
>Tranisition view
I want to have a transition view between player turns.

[Game ends]
>GameOverView()

