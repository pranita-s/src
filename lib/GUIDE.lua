--  
-- _tim@menzies.us_   
-- _August'18_   
--
-- --------
--
-- [Why](WHY) |[Install](INSTALL) | [What](WHAT) | Guide | [Style](STYLE) 
--
-- ------
--
-- ### Learning Lua
-- 
-- Some great on-line resources:
-- 
-- - Quick start http://tylerneylon.com/a/learn-lua/
-- - [Read the book](https://www.lua.org/pil/).
--     - The 4th edition in [on Amazon](https://goo.gl/D4dwGi).
--     - The 2nd edition (which is still pretty good) is available [on-line](https://goo.gl/jgwXVZ).
-- 
-- ### Before Reading This...
--
-- Read notes  on the LURE [LUA coding style](STYLE). Note, in particular, that some of the
-- `X.lua` files have `Xok.lua` demo/test files.
--
-- --------------------------------
-- ### File Groupings
--
-- As of August 8 2017, the files of LURE divide into the following  groups
--                                    
--      base       support    stats    table    learners
--      ------     -------    ------   -----    -----------
--      config     csv        num      row      contrasts
--      show       id         range    tbl      sdtree    
--      tests      lists      sample            superrange
--                 random     spy               trees
--                 str        sym
--                            sk
--                            tiles                     
--
-- ### Base code
--
-- The following _base_ code should be assumed to be global across all the rest.
--
-- - [config.lua](config): store global options in the global `the`.  These can be changed by the other code, then reset
--   to the default values by `defaults()`.
-- - [show.lua](show): changes LUA's default printer such that printing a table also prints
--                     its contents (recursively). To avoid printing very long items,
--                     give them a keyname starting with `_`.
-- - [tests.lua](tests): a simple unit test framework.
--
-- ### Support code
--
-- Simple stand alone utilities.
--
-- - [csv.lua](csv): reads comma seperates values from strings or files. Pass each found row to a function.
-- - [id.lua](id): generates uniqie ids;
-- - [lists.lua](lists): basic lists utilities
-- - [random.lua](random): random number generation that is stable across different platforms.
--   This is a nice place to see how a basic LUA module is formed.
-- - [str.lua](str): basic string routines: print lists of item, replace characters, etc
--
-- ### Stats code
--
-- Code for studying single distributions (and for studying multiple distributions, see _table_, below).
--
-- - [num.lua](num): watches a stream of numbers, summarized as Gaussians
-- - [range.lua](range): divides a list of numbers into a set of breaks. Note that this uses a dumb `unsupervosed`
--   approach. For a smaller approach, that reflects over the class variable, see [superranges.lua](superranges).
-- - [sample.lua](sample): watches a stream of numbers, keeps a random sample, never keeps more than (say) 
--   a few hundred values.
-- - [spy.lua](spy): watches numbers and, every so often, prints out the current stats.
-- - [sym.lua](sym): watches a stream of symbols
-- - [sk.lua](sk): ranks  a list of `sample`s, using a recursive top-down bi-clustering algorithm;
-- - [tiles.lua](tiles): divides a table of numbers into percentiles. Not very smart (for a smarter approach, see `range`).
-- 
-- Note also that the "watcher" modules (`num`, `sym`, `spy` and `sample`) all have a very similar protocol:
--
-- - `create`: make new watcher
-- - `update`: add an item to a watcher
-- - `updates`: add many items to a watcher, optionally filtered through some function `f`. Returns a new
--     watcher unless an optional third argument is supplied (in which case, the item is addes to this third arg).
-- - `watch`: returns a new watcher _and_ a convenience function for adding values to this watcher.
--
-- Another shared protocol is between `num` and `sym`:
--
-- - `distance` between two items (and if one or both are the `unknown` symbol react appropriately)
-- - `norm` (called by `distance`) to reduce numbers to the range 0..1 min..max (and for `sym`s, this function just
--    returns the value
--
-- Also, we can test is two `num` and `sample` distributions are statistically the same. 
--
-- - For `num`s, we use parametric Gaussian effect size and significance tests;
-- - For `sample`s, we use non-parametric effect size and significance tests (Scott-Knot in the [sk.lua](sk) file, 
--   bootstrap, and cliff's delta be checked 
--
-- ### Table code
-- One of my core data structures is `tbl` (table). Its a place to store
-- `row`s of data. 
--
-- - When data comes in from disk. I store it as a `tbl`;
-- - When data in one `tbl` is divided, the divisions are `tbl`s.
-- - When we cluster, each lucster it its own `tbl`.
-- - When we build a denogram (a recursive division of data into sub-data, then subn-s data, then sub-sub-sub data, etc)
--   then each node in that tree is `tbl`.
--
-- Each column in   `tbl` has a header that is a `num` or a `sym` 
-- and that header maintains a summary of what was seen in each column.
--

--
-- ### Learner code
-- 
-- The  discretzation and tree growing code (in [superranges.lua](superranges) and [sdtree.lua](strree)) needs to know the 
-- dependent variable. Hence, that code accepts  a `y` function otherwise the code won't know how to split the data. Currently,
-- two such functions are defined:
--
-- - "dom": divide trees on the "domination score" (how many times the objectives in one row dominate others)
-- - "goal1" divides the data according to the first  numeric goal.
--
-- To define other goal functions, edit the functions in `tbl.lua`.
--
--
-- that needs to bassed into 
-- that needs to be passed in withi
-- - tests.lua
-- - [tiles.lua](tiles):
-- - [spy.lua](spy): basic lists utilities
-- Support One of my core data structures is `tbl` (table). Its a place to store
--
-- `row`s of data. Each column in   `tbl` has a header that is a `num` or a `sym` 
-- and that header maintains a summary of what was seen in each column.
--
-- `Tbl`s are very useful.
--
-- `Tbl`s can be read in from ascii files or strings (see `csv.lua`) or
-- copied from other `tbl`s (plus or minus some of the `row`s of that other table.
--
-- `Tbl` data is read one row at a time using `update`:
--
-- - If this is other than  the first `row` then `Tbl` assumes it is a `row` to be stored in the table.
--   As a side-effect of storage, all the column headers are updated.
-- - If this is the first `row`
--   then `Tbl` assumes it is a `header` that lists the names and types of each column.
--        -- If the name contains `?`, then `Tbl` should ignore this column;
--        -- If the name contains `<,>`, then the column can be categoried as a numeric goal to eb minimized or maximized;
--        -- If the name contains `!`, then the column can be categorised as a   symbolic goal, to be used in classification;
--        -- If the name contains `$`, then the column is categorised as a  numeric indepedent variable;
--        -- Otherwise, the column can be categories as  a symbolic independent variable.
--  
-- Note that there is nothing hard-wired in this code about `?<>!$`. These can be easily changed in 
-- the `categories` function. 
--
-- What `Tbl` does assume is that columns of data can be categoried as :
-- 
-- - `x` : the independent columns;
-- - `y` : the dependent columns;
-- - `all` : all columns.
--
-- Within `all,x,y` the columns are further categorised as:
--
-- - `nums`: the numeric columns;
-- - `syms`: the symbolic columns;
-- - `cols`: all columns.
--
-- Note that a column can have multiple categories (see `categories`). This is done
-- since sometimes we have to (e.g.) process all the numerics together or  process all
-- the independent symbolics together etc.

require "show"


--------------------------------------------------------
--
-- ## Legal
--
-- <img align=right width=150 src="https://www.xn--ppensourced-qfb.com/media/reviews/photos/original/e2/b9/b3/22-bsd-3-clause-new-or-revised-modified-license-60-1424101605.png">
-- LURE, Copyright (c) 2017, Tim Menzies
-- All rights reserved, BSD 3-Clause License
--
-- Redistribution and use in source and binary forms, with
-- or without modification, are permitted provided that
-- the following conditions are met:
--
-- - Redistributions of source code must retain the above
--   copyright notice, this list of conditions and the
--   following disclaimer.
-- - Redistributions in binary form must reproduce the
--   above copyright notice, this list of conditions and the
--   following disclaimer in the documentation and/or other
--   materials provided with the distribution.
-- - Neither the name of the copyright holder nor the names
--   of its contributors may be used to endorse or promote
--   products derived from this software without specific
--   prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
-- CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
-- THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
-- USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
-- IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
