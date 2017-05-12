# for schedule:
SELECT sum(pageCount) as total FROM acceptance JOIN manuscript ON manuscript_id = manuscript.id WHERE issue_id = issueID; 



# ManuScripts
*INCOMPLETE*

## Commands

If an attribute being entered is more than one word (such as address) then entered that attribute within quotes.
Opt. designates an optional input

### Initially:

```
$ register author <fname> <lname> <email> <address> <affiliation>
```


```
$ register editor <fname> <lname>
```


```
$ register reviewer <fname> <lname> <email> <affiliation> <RIcode1> <opt. RIcode2> <opt. RIcode3>
```

```
$ login <id>
```


### When logged in as an author:

```
$ submit <title> <RICode> <filename> <opt. author2> <opt. author3> <opt. author4> 
```

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
typeset <manu#> <pp>
```

```
schedule <manu#> <issue>
```

```
publish <issue>
```

### When logged in as an editor:

```
$ resign
```

```
$ status
```

```
$ review <accept/reject> <appropriateness> <clarity> <methodology> <contribution>
```

where the last four attributes are integers 1-10. A reviewer can only review a manuscript which is under review and they have been assigned to. 


## Dependencies
*INCOMPLETE*

## How to Build
*INCOMPLETE*

## Architecture
*INCOMPLETE*

## Credits
- [Kevin Farmer](mailto:kevin.r.farmer.18@dartmouth.edu)
- [Yusuf Olokoba](mailto:olokobayusuf@gmail.com)