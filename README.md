# landle

Welcome to landle, a straight-up ripoff of ghsync which wouldn't work for me.

It'll organize your repos like so:

+ repos
      forks    (public fork repos)
      mirrors  (public mirror repos)
      private  (private repos)
      public   (public repos)
      starred  (public watched repos)
      watched  (public watched repos)

## Test data

    wget https://api.github.com/users/saintaardvark/starred -O users.starred.json
    wget https://api.github.com/users/saintaardvark/repos -O users.repos.json
