:- module(maps, [map/2]).
:- use_module(main).

map(Keys, Map) :-
    sort(Keys, Map).
