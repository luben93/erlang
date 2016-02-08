%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% File: db.erl
%%% @author trainers@erlang-solutions.com
%%% @copyright 1999-2015 Erlang Solutions Ltd.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% The database is an ordered unbalanced tree of
%% {Key,Value,Left,Right} | empty.

-module(db).
-export([new/0,destroy/1,read/2,write/3,delete/2,keys/1,match/2]).

%% Create a new database.

new() -> empty.

%% Destroy the database.

destroy(_Db) -> ok.

%% Read an element with the matching key.

read(Key, {K1,_,Left,_}) when Key < K1 ->
    read(Key, Left);
read(Key, {K1,_,_,Right}) when Key > K1 ->
    read(Key, Right);
read(_, {_, Val, _, _}) -> {ok,Val};
read(_, empty) -> {error,instance}.


%% Write and element Key/Value into the tree overwriting any existing
%% value.

write(Key, Val, {K1,V1,Left,Right}) when Key < K1 ->
    {K1,V1,write(Key, Val, Left),Right};
write(Key, Val, {K1,V1,Left,Right}) when Key > K1 ->
    {K1,V1,Left,write(Key, Val, Right)};
write(Key, Val, {_,_,Left,Right}) ->
    {Key,Val,Left,Right};
write(Key, Val, empty) -> {Key,Val,empty,empty}.

%% Remove an element from the database.

delete(Key, {K1,V1,Left,Right}) when Key < K1 ->
    {K1,V1,delete(Key, Left),Right};
delete(Key, {K1,V1,Left,Right}) when Key > K1 ->
    {K1,V1,Left,delete(Key, Right)};
delete(_, {_,_,Left,Right}) ->
    merge(Left, Right);
delete(_, empty) -> empty.

%% merge(Left, Right) -> Tree.
%%  A very simple merge. We know that keys in Right are always bigger
%%  then in Left so we step down the rightmost branch of Left and
%%  insert Right at the bottom.

merge(empty, Right) -> Right;
merge(Left, empty) -> Left;
merge({K1,V1,L1,R1}, Right) ->
    {K1,V1,L1,merge(R1, Right)}.

%% Return all the keys in the database.

keys(Db) -> keys(Db, []).

keys(empty, Acc) -> Acc;
keys({Key,_,Left,Right}, Acc) ->
    keys(Left, [Key] ++ keys(Right, Acc)).

%% Return all the keys whose values match the given element.

match(Val, Db) -> match(Val, Db, []).

match(empty, _, Acc) -> Acc;
match({Key,Val,Left,Right}, Val, Acc) ->
    match(Left, Val, [Key] ++ match(Right, Val, Acc));
match({_,_,Left,Right}, Val, Acc) ->
    match(Left, Val, match(Right, Val, Acc)).

compile(empty) -> empty.