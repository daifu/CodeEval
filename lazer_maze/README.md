PROBLEM STATEMENT

You are standing in a rectangular room and are about to fire a laser
toward the east wall.  Inside the room a certain number of prisms have
been placed.  They will alter the direction of the laser beam if it hits
them.  There are north-facing, east-facing, west-facing, and
south-facing prisms. If the laser beam strikes an east-facing prism, its
course will be altered to be East, regardless of what direction it had
been going in before.  If it hits a south-facing prism, its course will
be altered to be South, and so on. You want to know how far the laser
will travel before it hits a wall.

 

INPUT

Your program should read the input from standard input, which contains
the data describing the room setup.  This room description is a string
with embedded newline (\n) characters that separate the string into
multiple lines.  Each line from the input represents a row in the room.
The characters inside each row denote the placement of the objects on
that row.  

The input might or might not end with a newline character and your code
must handle either case.

Your program will have to determine the number of rows and columns
implicit in input.  However, the number of lines of input will be at
most 50. Each line will contain the same number of characters.

The room description contains exactly one '@' character, representing
the laser's position in the room.  It may contain any number of object
markers from the set ["<", "^", ">", "v"], which represent prisms.  Each
prism affects the laser by redirecting the laser in the indicated
direction (e.g. if the laser hits a 'v' object - note, lower-case v - it
will be directed south).  All other locations in the room are indicated
with a "-".  Whitespace is not significant, other than newlines
separating rows.

 

OUTPUT

Your program must output an integer representing the distance that the
laser will travel before hitting a wall.  For example, if the laser
travels a distance of 14 cells before hitting a wall, then your program
should call console.log("14").   Your program should treat the "@'"
symbol the same as the "-" character, that is, as empty space.  So the
laser will pass through the original location from which it was fired.

If the laser will get caught in an infinite loop, then -1 must be
returned.

