# landle

Welcome to landle v1.5, a Small but Useful(tm) utility to clone your
github repos: those you watch, own or star.  It's a straight-up ripoff
of [ghsync][0]. ghsync is a great idea, but I couldn't get it to work
for me...so here's landle.

It'll organize your repos like so:

    + repos
      ├── forks    (public fork repos)
      ├── mirrors  (public mirror repos)
      ├── private  (private repos)
      ├── public   (public repos)
      └── watching (public watched repos)

(Again, straight from ghsync.  All hail the original author!)

## Usage

Create an INI-style config file like this:

    [landle]
    # Github username
    user = saintaardvark
    # Where landle should store its repos
    repodir = /home/aardvark/landle
    # Optional: post-clone hook
    post-clone-hook = /home/aardvark/src/landle/post-clone-example.sh

Landle will look for its config file in this order:

* `.landlerc` in the directory it's run from (which allows for per-repo configs)
* `~/.landlerc` (per-user config)
* or as specified with the "-f" option (global!)

Then just run "landle".  It'll download the info it needs from Github,
create the directories under `repodir`, and clone or pull as
necessary.  If the optional `post-clone-hook` setting is present, it's
assumed to be the path to a script or some such; landle will run it
after cloning a new repo, and within that repo directory.

(Note that landle is meant to maintain more-or-less read-only mirrors.
It'd be interesting to think about a pre-update hook or some such
that'd push any commits -- a sort of automated
let's-push-all-the-commits-I-made-on-the-airplane mode -- but that
gets more complicated than I want to think about.)

Additional options:

    -d	Work on already-downloaded test data only (see below)
    -v	Be verbose.
	-f [file] Specify path to config file.
    -n	Testing only: show what clone/pull/mkdir operations would happen.
    -m	Show the man page.
    -h	Help

## Test data

If you want test data for the "-d" option , fetch it like so:

    wget https://api.github.com/users/[username]/starred -O user.starred.json
    wget https://api.github.com/users/[username]/repos -O user.repos.json

Then you can work offline.

## Dependencies

Perl, plus the following non-base modules:

* Config::Simple
* JSON::XS
* File::Homedir
* Git::Wrapper

On Debian/Ubuntu, you can install them like so:

     apt-get install libconfig-simple-perl libjson-xs-perl libfile-homedir-perl libgit-wrapper-perl

## Bugs, shortcomings and TODO

Bugs:

* Some repos appear to get "stuck": landle reports unmerged files,
  even though I haven't edited anything, changed the repo, etc.  I'm
  not sure yet what's going on, but `git reset --hard HEAD; git pull`
  seems to get around the problem.

* When cloning a new repo, landle reports an error though everything's
  actually fine.  This may be because I'm checking it's success the
  wrong way -- there's output going to STDERR.  See Git::Wrapper's doc
  for details.

Shortcomings:

* Direct fetch/parsing of Github v3 API URLs rather than using something like
  [Pithub][1]
* A little too verbose...

TODO:

* Per-repo settings/hooks? (would require rename of global landle section)
* Better control over verbosity
* Offer to create missing config
* Make "repodir" optional, assume cwd?
* For forks, add "upstream" remote.  Not sure how to do that...
* What to do if a repo goes away?  Add a "purge = true/false" option,
  or even a "--purge" option for landle itself. Might also want to
  consider two cases:
  - a repo no longer starred/watched (no longer interested; default
    == delete)
  - a starred/watched repo that has disappeared (still interested, but
    the repo has been deleted; default == keep)
* That might imply overwriting config file options, which calls for
  better arg handling; there must be a Perl module which does this
  better.
* Use [this approach][5] for generating documentation.

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
[5]: https://stackoverflow.com/questions/13188404/how-to-make-my-perl-modules-readme-file-compatible-with-githubs-markdown-displ
