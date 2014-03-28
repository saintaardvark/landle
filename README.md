# landle

Welcome to landle, a Small but Useful(tm) utility to clone your github
repos: those you watch, own or star.  It's a straight-up ripoff of
[ghsync][0]. ghsync is a great idea, but I couldn't get it to work for
me...so here's landle.

It'll organize your repos like so:

+ repos 
  ├── forks    (public fork repos) 
  ├── mirrors  (public mirror repos) 
  ├── private  (private repos) 
  ├── public   (public repos) 
  └── watched  (public watched repos) 

(Again, straight from ghsync.  All hail the original author!)

## Usage

Create ~/.landlerc, which should look like this:

    [landle]
    # Github username
    user = saintaardvark
    # Where Landle should store its repos
    repodir = /home/aardvark/landle

Then just run "landle".  It'll download the info it needs from Github,
create the directories under repodir, and clone or pull as necessary.

Additional options:

    -d	Work on already-downloaded test data only (see below)
    -v	Be verbose.
    -n	Testing only: show what clone/pull/mkdir operations would happen.
    -h	Help

## Test data

If you want to use test data for working offline, fetch it like so:

    wget https://api.github.com/users/[username]/starred -O user.starred.json
    wget https://api.github.com/users/[username]/repos -O user.repos.json

Then supply the "-d" option.

## Dependencies

Perl, plus the following non-base modules:

* Config::Simple
* JSON::XS

On Debian/Ubuntu, you can install them like so:

     apt-get install libconfig-simple-perl libjson-xs-perl

## Shortcomings and TODO

Bad:

* Direct fetch/parsing of Github v3 API URLs rather than using something like
  [Pithub][1]
* Direct running of git commands rather than using Perl Git module

TODO:

* Look for .landlerc in pwd, home directory or other specified directory
* Per-repo hooks using project sections in .landlerc

## License

GPL v3.

## Home Page

Either on [Github][2] or [my own repo][3].

## Thanks!

* The authors of [ghsync][0] for the idea
* The Random [Javascript Project Name Generator][4] for the name "landle"

[0]: https://github.com/kennethreitz/ghsync
[1]: https://metacpan.org/pod/Pithub
[2]: https://github.com/saintaardvark/landle
[3]: http://git.saintaardvarkthecarpeted.com/?p=landle.git;a=summary
[4]: http://mrsharpoblunto.github.io/foswig.js/
