Deej
====

Deej is an office jukebox where anyone can vote on songs to be played through
a local icecast server. Since this is bound to our local network, there is no 
user authentication. Votes are limited by IP. When there aren't any votes in
the system, Deej will play songs at random.

Here is a [screenshot](http://cl.ly/GR9e) of it in action.

Dependencies
------------
You'll need to have an icecast server setup somewhere to use this.

Getting started
---------------
* Edit config/app_config.yml
* Setup your database with rake db:schema:load
* Import your music with rake songs:import
* Start playing your music with rake songs:play
