-- 
-- _tim@menzies.us_   
-- _August'17_   
--
--
-- -------
--
-- [Why](WHY) | Install | [What](WHAT) | [Guide](GUIDE) | [Style](STYLE) 
--
-- ------
--
-- ### Using LuaRocks
-- 
-- Coming soon.
-- 
-- ### Using Github
-- 
-- Check out the repo, then create an environment
-- variable `Lure` to hold the repo's location.
-- 
--     git clone http://github.com/lualure/src src
--     Lure=$PWD/src 
-- 
-- Add the following function to your $HOME/.bashrc.
-- 
--     lure() { 
--       f=$(basename $1 .lua).lua
--       shift
--       if [ -f "$Lure/lib/$f" ]; then
--         LUA_PATH="$Lure/lib/?.lua;;" $(which luajit) $Lure/lib/$f "$*"
--         return 0
--       fi
--       echo "not found $f"
--     }
-- 
-- Make sure your source this code; e.g. logout then log
-- back in or (much faster):
-- 
--     . ~/.bashrc
-- 
-- ### Test
-- 
-- Change directories to some other part of your computer (away from the source code). Then
-- try to run any code from lure. e.g.
-- 
--     $ lure listsok
--     # test:	1
--     0.000167 secs
--     # test:	2
--     1.1e-05 secs
--     # test:	3
--     3.9999999999997e-06 secs
--     # test:	4
--     4e-05 secs
--     :pass 4 :fail 0 :percentPass 100
--     -- Global: the
--     -- Global: defaults
-- 
-- The above code is reporting that none of the `listsok` tests can file fault with the `lists`
-- functions (hence `:fail 0`). It also shows that those tests run fast (in tenths of milliseconds)
-- and that this code suffers from only two globals `the` and `defaults` (and these two are meant to
-- be the only defaults known to  the system-- see the notes on coding style, below).

require "show"

-- --------------------------------------------------------
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
