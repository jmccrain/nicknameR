
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nicknameR

<!-- badges: start -->
<!-- badges: end -->

nicknameR facilitates matching common English first names to common
nicknames, a frequent problem when dealing with any name merging. The
primary function returns a long or wide dataframe of names and
nicknames. The function also allows on the fly formatting of the names.
There are 580 unique names and 671 unique nicknames in the data.

The names data come from this GitHub repository:
<https://github.com/onyxrev/common_nickname_csv>

## Installation

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jmccrain/nicknameR")
```

## Usage

The function `nicknamer` results in a dataframe formatted base on the
parameters `format`, `transform`, `reverse`, and `opt_function`.

``` r
library(nicknameR)

# standard long dataframe
names <- nicknamer()

dplyr::glimpse(names)
#> Rows: 1,431
#> Columns: 2
#> $ name     <chr> "Aaron", "Aaron", "Aaron", "Abel", "Abel", "Abel", "Abel",...
#> $ nickname <chr> "Erin", "Ron", "Ronnie", "Ab", "Abe", "Eb", "Ebbie", "Ab",...

length(unique(names$name))
#> [1] 580
length(unique(names$nickname))
#> [1] 671
```

The default output is a long dataframe, with one row per name-nickname
combination. In other words, both names and nicknames will be duplicated
in each column, such as Alex being a nickname for Alexander or
Alexandra.

Another option is to convert the output a wide format, using the
`format` parameter. You can also transform the strings to either full
uppercase or full lower case with `transform`.

``` r
# wide dataframe transformed to lower case
names.wide <- nicknamer(format="wide", transform = "to_lower")

head(names.wide)
#> # A tibble: 6 x 17
#> # Groups:   name [6]
#>   name  nickname_1 nickname_2 nickname_3 nickname_4 nickname_5 nickname_6
#>   <chr> <chr>      <chr>      <chr>      <chr>      <chr>      <chr>     
#> 1 aaron erin       ron        ronnie     <NA>       <NA>       <NA>      
#> 2 abel  ab         abe        eb         ebbie      <NA>       <NA>      
#> 3 abiel ab         <NA>       <NA>       <NA>       <NA>       <NA>      
#> 4 abig~ abby       gail       nabby      <NA>       <NA>       <NA>      
#> 5 abner ab         <NA>       <NA>       <NA>       <NA>       <NA>      
#> 6 abra~ ab         abe        <NA>       <NA>       <NA>       <NA>      
#> # ... with 10 more variables: nickname_7 <chr>, nickname_8 <chr>,
#> #   nickname_9 <chr>, nickname_10 <chr>, nickname_11 <chr>, nickname_12 <chr>,
#> #   nickname_13 <chr>, nickname_14 <chr>, nickname_15 <chr>, nickname_16 <chr>
```

If you instead want to use the nicknames as the specific rows, you can
set `reverse` to TRUE. Now there will be one row per *nickname*, so the
name Alex will now have one row with two full names associated with it
(Alexander and Alexandra).

``` r
# wide dataframe with nickname as the row
names.wide <- nicknamer(format="wide", transform = "to_lower", reverse=T)
```

Finally, the `opt_function` parameter allows you to pass any custom
function to resulting dataframe. This transforms each name and nickname
column.:

``` r
# optional function applied to names:
short.names <- nicknamer(
  format="wide",
  transform = "to_lower",
  opt_function = function(x) { str_sub(x, 1, 3) }
)
```
