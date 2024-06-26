% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dsb.R
\name{dsb}
\alias{dsb}
\title{Simple and powerful string manipulation with the dot square bracket operator}
\usage{
dsb(
  ...,
  frame = parent.frame(),
  sep = "",
  vectorize = FALSE,
  nest = TRUE,
  collapse = NULL
)
}
\arguments{
\item{...}{Character scalars that will be collapsed with the argument \code{sep}. You can use \code{".[x]"} within each character string to insert the value of \code{x} in the string. You can add string operations in each \code{".[]"} instance with the syntax \code{"'arg'op ? x"} (resp. \code{"'arg'op ! x"}) to apply the operation \code{'op'} with the argument \code{'arg'} to \code{x} (resp. the verbatim of \code{x}). Otherwise, what to say? Ah, nesting is enabled, and since there's over 30 operators, it's a bit complicated to sort you out in this small space. But type \code{dsb("--help")} to prompt an (almost) extensive help.}

\item{frame}{An environment used to evaluate the variables in \code{".[]"}.}

\item{sep}{Character scalar, default is \code{""}. It is used to collapse all the elements in \code{...}.}

\item{vectorize}{Logical, default is \code{FALSE}. If \code{TRUE}, Further, elements in \code{...} are NOT collapsed together, but instead vectorised.}

\item{nest}{Logical, default is \code{TRUE}. Whether the original character strings should be nested into a \code{".[]"}. If \code{TRUE}, then things like \code{dsb("S!one, two")} are equivalent to \code{dsb(".[S!one, two]")} and hence create the vector \code{c("one", "two")}.}

\item{collapse}{Character scalar or \code{NULL} (default). If provided, the resulting character vector will be collapsed into a character scalar using this value as a separator.

There are over 30 basic string operations, it supports pluralization, it's fast (e.g. faster than \code{glue} in the benchmarks), string operations can be nested (it may be the most powerful feature), operators have sensible defaults.

See detailed help on the console with \code{dsb("--help")}. The real help is in fact in the "Examples" section.}
}
\value{
It returns a character vector whose length depends on the elements and operations in \code{".[]"}.
}
\description{
Compactly performs many low level string operations. Advanced support for pluralization.
}
\examples{

#
# BASIC USAGE ####
#

x = c("Romeo", "Juliet")

# .[x] inserts x
dsb("Hello .[x]!")

# elements in ... are collapsed with "" (default)
dsb("Hello .[x[1]], ",
    "how is .[x[2]] doing?")

# Splitting a comma separated string
# The mechanism is explained later
dsb("/J. Mills, David, Agnes, Dr Strong")

# Nota: this is equivalent to (explained later)
dsb("', *'S !J. Mills, David, Agnes, Dr Strong")

#
# Applying low level operations to strings
#

# Two main syntax:

# A) expression evaluation
# .[operation ? x]
#             | |
#             |  \-> the expression to be evaluated
#              \-> ? means that the expression will be evaluated

# B) verbatim
# .[operation ! x]
#             | |
#             |  \-> the expression taken as verbatim (here ' x')
#              \-> ! means that the expression is taken as verbatim

# operation: usually 'arg'op with op an operation code.

# Example: splitting
x = "hello dear"
dsb(".[' 's ? x]")
# x is split by ' '

dsb(".[' 's !hello dear]")
# 'hello dear' is split by ' '
# had we used ?, there would have been an error

# By default, the string is nested in .[], so in that case no need to use .[]:
dsb("' 's ? x")
dsb("' 's !hello dear")

# There are 35 string operators
# Operators usually have a default value
# Operations can be chained by separating them with a comma

# Example: default of 's' is ' ' + chaining with collapse
dsb("s, ' my 'c!hello dear")

#
# Nesting
#

# .[operations ! s1.[expr]s2]
#              |    |
#              |     \-> expr will be evaluated then added to the string
#               \-> nesting requires verbatim evaluation: '!'

dsb("The variables are: .[C!x.[1:4]].")

# This one is a bit ugly but it shows triple nesting
dsb("The variables are: .[w, C!.[2* ! x.[1:4]].[S, 4** ! , _sq]].")

#
# Splitting
#

# s: split with fixed pattern, default is ' '
dsb("s !a b c")
dsb("' b 's !a b c")

# S: split with regex pattern, default is ', *'
dsb("S !a, b, c")
dsb("'[[:punct:] ]'S !a! b; c")

#
# Collapsing
#

# c and C do the same, their default is different
# syntax: 's1||s2' with
# - s1 the string used for collapsing
# - s2 (optional) the string used for the last collapse

# c: default is ' '
dsb("c?1:3")

# C: default is ', || and '
dsb("C?1:3")

dsb("', || or 'c?1:4")

#
# Extraction
#

# x: extracts the first pattern
# X: extracts all patterns
# syntax: 'pattern'x
# Default is '[[:alnum:]]+'

x = "This years is... 2020"
dsb("x ? x")
dsb("X ? x")

dsb("'\\\\d+'x ? x")

#
# STRING FORMATTING ####
#

#
# u, U: uppercase first/all letters

# first letter
dsb("u!julia mills")

# title case: split -> upper first letter -> collapse
dsb("s, u, c!julia mills")

# upper all letters
dsb("U!julia mills")

#
# L: lowercase

dsb("L!JULIA MILLS")

#
# q, Q: single or double quote

dsb("S, q, C!Julia, David, Wilkins")
dsb("S, Q, C!Julia, David, Wilkins")

#
# f, F: formats the string to fit the same length


score = c(-10, 2050)
nm = c("Wilkins", "David")
dsb("Monopoly scores:\n.['\n'c ! - .[f ? nm]: .[F ? score] US$]")

# OK that example may have been a bit too complex,
# let's make it simple:

dsb("Scores: .[f ? score]")
dsb("Names: .[F ? nm]")

#
# w, W: reformat the white spaces
# w: suppresses trimming white spaces + normalizes successive white spaces
# W: same but also includes punctuation

dsb("w ! The   white  spaces are now clean.  ")

dsb("W ! I, really -- truly; love punctuation!!!")

#
# \%: applies sprintf formatting

dsb("pi = .['.2f'\% ? pi]")

#
# a: appends text on each item
# syntax: 's1|s2'a, adds s1 at the beginning and s2 at the end of the string
# It accepts the special values :1:, :i:, :I:, :a:, :A:
# These values create enumerations (only one such value is accepted)

# appending square brackets
dsb("'[|]'a, ' + 'c!x.[1:4]")

# Enumerations
acad = dsb("/you like admin, you enjoy working on weekends, you really love emails")
dsb("Main reasons to pursue an academic career:\n .[':i:) 'a, C ? acad].")

#
# A: same as 'a' but adds at the begging/end of the full string (not on the elements)
# special values: :n:, :N:, give the number of elements

characters = dsb("/David, Wilkins, Dora, Agnes")
dsb("There are .[':N: characters: 'A, C ? characters].")


#
# stop: removes basic English stopwords
# the list is from the Snowball project: http://snowball.tartarus.org/algorithms/english/stop.txt

dsb("stop, w!It is a tale told by an idiot, full of sound and fury, signifying nothing.")

#
# k: keeps the first n characters
# syntax: nk: keeps the first n characters
#         'n|s'k: same + adds 's' at the end of shortened strings
#         'n||s'k: same but 's' counts in the n characters kept

words = dsb("/short, constitutional")
dsb("5k ? words")

dsb("'5|..'k ? words")

dsb("'5||..'k ? words")

#
# K: keeps the first n elements
# syntax: nK: keeps the first n elements
#         'n|s'K: same + adds the element 's' at the end
#         'n||s'K: same but 's' counts in the n elements kept
#
# Special values :rest: and :REST:, give the number of items dropped

bx = dsb("/Pessac Leognan, Saint Emilion, Marguaux, Saint Julien, Pauillac")
dsb("Bordeaux wines I like: .[3K, ', 'C ? bx].")

dsb("Bordeaux wines I like: .['3|etc..'K, ', 'C ? bx].")

dsb("Bordeaux wines I like: .['3||etc..'K, ', 'C ? bx].")

dsb("Bordeaux wines I like: .['3|and at least :REST: others'K, ', 'C ? bx].")

#
# Ko, KO: special operator which keeps the first n elements and adds "others"
# syntax: nKo
# KO gives the rest in letters

dsb("Bordeaux wines I like: .[4KO, C ? bx].")

#
# r, R: string replacement
# syntax: 's'R: deletes the content in 's' (replaces with the empty string)
#         's1 => s2'R replaces s1 into s2
# r: fixed / R: perl = TRUE

dsb("'e'r !The letter e is deleted")

# adding a perl look-behind
dsb("'(?<! )e'R !The letter e is deleted")

dsb("'e => a'r !The letter e becomes a")

dsb("'([[:alpha:]]{3})[[:alpha:]]+ => \\\\1.'R !Trimming the words")

#
# *, *c, **, **c: replication, replication + collapse
# syntax: n* or n*c
# ** is the same as * but uses "each" in the replication

dsb("N.[10*c!o]!")

dsb("3*c ? 1:3")
dsb("3**c ? 1:3")

#
# d: replaces the items by the empty string
# -> useful in conditions

dsb("d!I am going to be annihilated")

#
# ELEMENT MANIPULATION ####
#

#
# D: deletes all elements
# -> useful in conditions

x = dsb("/I'll, be, deleted")
dsb("D ? x")

#
# i, I: inserts an item
# syntax: 's1|s2'i: inserts s1 first and s2 last
# I: is the same as i but is 'invisibly' included

characters = dsb("/David, Wilkins, Dora, Agnes, Trotwood")
dsb("'Heep|Spenlow'i, C ? characters")

dsb("'Heep|Spenlow'I, C ? characters")


#
# PLURALIZATION ####
#

# There is support for pluralization

#
# *s, *s_: adds 's' or 's ' depending on the number of elements

nb = 1:5
dsb("Number.[*s, D ? nb]: .[C ? nb]")
dsb("Number.[*s, D ? 2 ]: .[C ? 2 ]")

# or
dsb("Number.[*s, ': 'A, C ? nb]")


#
# v, V: adds a verb at the beginning/end of the string
# syntax: 'verb'v

# Unpopular opinion?
brand = c("Apple", "Samsung")
dsb(".[V, C ? brand] overrated.")
dsb(".[V, C ? brand[1]] overrated.")

win = dsb("/Peggoty, Agnes, Emily")
dsb("The winner.[*s_, v, C ? win].")
dsb("The winner.[*s_, v, C ? win[1]].")

# Other verbs
dsb(".[' have'V, C ? win] won a prize.")
dsb(".[' have'V, C ? win[1]] won a prize.")

dsb(".[' was'V, C ? win] unable to come.")
dsb(".[' was'V, C ? win[1]] unable to come.")

#
# *A: appends text depending on the length of the vector
# syntax: 's1|s2 / s3|s4'
#         if length == 1: applies 's1|s2'A
#         if length >  1: applies 's3|s4'A

win = dsb("/Barkis, Micawber, Murdstone")
dsb("The winner.[' is /s are '*A, C ? win].")
dsb("The winner.[' is /s are '*A, C ? win[1]].")

#
# CONDITIONS ####
#

# Conditions can be applied with 'if' statements.",
# The syntax is 'type comp value'if(true : false), with
# - type: either 'len', 'char', 'fixed' or 'regex'
#   + len: number of elements in the vector
#   + char: number of characters
#   + fixed: fixed pattern
#   + regex: regular expression pattern
# - comp: a comparator:
#   + valid for len/char: >, <, >=, <=, !=, ==
#   + valid for fixed/regex: !=, ==
# - value: a value for which the comparison is applied.
# - true: operations to be applied if true (can be void)
# - false: operations to be applied if false (can be void)

dsb("'char <= 2'if('(|)'a : '[|]'a), ' + 'c ? c(1, 12, 123)")

sentence = "This is a sentence with some longish words."
dsb("s, 'char<=4'if(D), c ? sentence")

dsb("s, 'fixed == e'if(:D), c ! Only words with an e are selected.")

#
# ARGUMENTS FROM THE FRAME ####
#

# Arguments can be evaluated from the calling frame.
# Simply use backticks instead of quotes.

dollar = 6
reason = "glory"
dsb("Why do you develop packages? For .[`dollar`*c!$]?",
    "For money? No... for .[U,''s, c?reason]!", sep = "\n")





}
