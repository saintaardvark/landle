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

## Dependencies

Perl, plus the following non-base modules:

* LWP::Simple;
* JSON::XS;

## Shortcomings

* Direct fetch of Github v3 API URLs rather than using something like
  [Pithub][1]
* While it (so far) works for me, it's pretty young just yet.

## License

GPL v3.

## Test data

If you want to use test data for working offline, fetch it like so:

    wget https://api.github.com/users/[username]/starred -O user.starred.json
    wget https://api.github.com/users/[username]/repos -O user.repos.json

## Home Page

Either on [Github][2] or [my own repo.][3]

[0]: https://github.com/kennethreitz/ghsync
[1]: https://metacpan.org/pod/Pithub
[2]: https://github.com/saintaardvark/landle
[3]: http://git.saintaardvarkthecarpeted.com/?p=landle.git;a=summary
