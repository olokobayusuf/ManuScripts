# ManuScripts
ManuScripts is a lightweight application for science journal publications.

## Setup
- Build the project with the makefile: `make`
- Run it: `make run`
    - To run in verbose mode, use the debug target: `make debug`
    - To run with password authentication, use the auth target: `make auth`

## Usage
The app starts by requesting user authentication. To do so, either register or login:

## Author Registration
To register as an author, simply supply the author's first name, last name, email address, affiliation, and address. For example:
```
$ => register author Yusuf Olokoba olokobayusuf@gmail.com "Dartmouth College" "Hinman box 2982, Hanover, NH"
```
You will then be shown a welcome message and given the ability to use the author UI. Note that when in authentication mode, you will be prompted for a password for your account.

## Editor Registration
To register as an editor, simply supply your first and last names:
```
$ => register editor Kevin Farmer
```
You will then be shown a welcome message and given the ability to use the editor UI. Note that when in authentication mode, you will be prompted for a password for your account.

## Reviewer Registration
To register as a reviewer, simply supply your first name, last name, at between one and three RI codes:
```
$ => register reviewer Chris Palmer 1 2 3
```
You will then be shown a welcome message and given the ability to use the reviewer UI. Note that when in authentication mode, you will be prompted for a password for your account. Also note that you must provide the appropriate number of RI codes.

## Logging In
To login, use the `login` command with your user ID:

```
$ => login 15
```
You will then be shown a welcome message and given the ability to use the UI that corresponds to your user type. Note that when in authentication mode, you will be prompted for a password.


## Logging Out and Exiting

To logout, use the `logout` command:

```
$ => logout
```

To exit the app, you must first log out. Once logged out, you can use either the `exit` or `quit` commands to exit:

```
$ => exit
$ => quit
```


### When logged in as an editor:

```
$ status
```

```
$ assign <manu#> <reviewer id>
```

```
$ reject <manu#>
```

```
$ accept <manu#>
```

```
$ typeset <manu#> <pp>
```

```
$ schedule <manu#> <issue>
```

```
$ publish <issue>
```

### When logged in as a reviewer:

```
$ resign
```

```
$ status
```

```
$ accept <manu#> <appropriateness> <clarity> <methodology> <contribution>
```

```
$ reject <manu#> <appropriateness> <clarity> <methodology> <contribution>
``` 


## Performing Tasks
See the [ManuScripts Specification](http://www.cs.dartmouth.edu/~cs61/Labs/Lab%202/Lab%202.html).


## Dependencies
- Java/JDK 8
- Makefile (for using `make`)
- [MySQL JDBC Connector](https://dev.mysql.com/downloads/connector/j/5.1.html). Place this in the `lib` directory

## Credits
- [Kevin Farmer](mailto:kevin.r.farmer.18@dartmouth.edu)
- [Yusuf Olokoba](mailto:olokobayusuf@gmail.com)
