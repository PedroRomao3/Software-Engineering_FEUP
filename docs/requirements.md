# User stories
[comment]: <> (admin setting)
- As an admin, I want to delete or edit lobbies so that I can delete empty lobbies.
- As an admin, I want to ban users so that I can control toxic users.


[comment]: <> (perfil settings)
- As a registered user, I want to block other users so that I don't have to play with them again.
- As a registered user, I want to define my favorite games / rank / language so that I can create/find a lobby faster.
- As a registered user, I want to connect my account with discord so that I can be automatically connect to a discord voice chat.

[comment]: <> (lobby main page)
- As a registered user, I want to create a lobby so that I can search people to play.
- As a registered user, I want to join a lobby so that I can find people to play.
- As a registered user, I want to be able to filter the existing lobbies by rank/game/language/nº slots so that I can find the perfect lobby for me.
- As a registered user, I want to be able to chat with people in my lobby so that I can comunicate.

- As a lobby owner, I want to change privacy setting of my lobby so i can turn it from private to public or vice-versa.
- As a lobby owner, I want to delete my lobby so I can search or create another one.

# Domain Model

*The following domain model represents all the classes used in the software system.* <br> <br>

![domain_model](/images/class_diagram.png)

**We represent 4 diferent classes in our system:** <br>
- ***Lobby*** <br>
    Countains all the necessary values so we can set an elo for the lobby itself (the ranks accept), a *private_key* (null by default) that can be used when set a *is_private* to *true*. We also have a list of all the *languages* accepted and a lobbyID to be used later on.
- ***Game*** <br>
    Countains the *name* of the game itself and the *description*
- ***Rank*** <br>
    Contains the *name* of the elo itself and the number associated to it so that it can be used on the lobby *min* and *max*
- ***User*** <br>
    Contains the *username*, the *password_hash* of the account, *birthday*, *discord_userID* to connect to the discord account later on and *nationality* that can be used on an automatic language filter and in lobby display.
