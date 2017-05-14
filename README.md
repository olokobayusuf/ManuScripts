# for schedule:
SELECT sum(pageCount) as total FROM acceptance JOIN manuscript ON manuscript_id = manuscript.id WHERE issue_id = issueID; 



# ManuScripts
*INCOMPLETE*

**Authentication**

We included an AES encryption method for passwords, which uses a 128-bit (16 character) secret key which
is prompted for at the startup of the system.


## Commands

If an attribute being entered is more than one word (such as address) then entered that attribute within quotes.
() rather than <> designates an optional input.

### Initially:

```
$ register author <fname> <lname> <email> <address> <affiliation>
```


```
$ register editor <fname> <lname>
```


```
$ register reviewer <fname> <lname> <email> <affiliation> <RIcode1> (RIcode2) (RIcode3)
```

```
$ login <id>
```

After logging in, you can logout of the current user with

```
$ logout
```

If not logged in, you can exit the system with

```
$ exit
```


### When logged in as an author:

```
$ submit <title> <RICode> (author2) (author3) (author4)
```

we are not including the filename since blobs are not being implemented.


```
$ status
```

```
$ retract <manu#>
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

A reviewer can only review a manuscript which is under review and they have been assigned to. 


## Dependencies
*INCOMPLETE*

## How to Build
*INCOMPLETE*

## Architecture
*INCOMPLETE*

## Credits
- [Kevin Farmer](mailto:kevin.r.farmer.18@dartmouth.edu)
- [Yusuf Olokoba](mailto:olokobayusuf@gmail.com)
