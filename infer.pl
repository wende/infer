:- module(infer, [
    (=>)/2, op(500, xfy, (=>)),
    (<-)/2, op(400, xfy, (<-)),
    (<<)/2, op(300, xfy, (<<)),
    app/4,
    type/4
]).

% Helpers
:- op( 500, xfy, [ => ]).
:- op( 400, xfy, [ <- ]).
:- op( 300, xfy, [ << ]).

:- discontiguous(a/4).

=>(_, _).
<<(Var, (F, Args)) :- app(F, Args, Var, []).
<-(L, R) :- let(L, R).


% Application
app(L, R, T2, Meta) :-
    duplicate_term(L, LCopy),
    a(LCopy, R, T2, Meta).

a(A, [], A, _M).
a(A => B, [A | As], T, M) :- a(B, As, T, M).

% Unions
type((N, Args), N, Args, Inst) :- maplist(inst((N, Args)), Inst).

% Create functions to instantiate the type
% Currently for sake of copying, even empty
inst((Name, Args), ((Name, Args), [])).
inst((Name, Args), (X => Result, [X | Xs])) :-
    inst((Name, Args), (Result, Xs)).

% Let
let(X, X).

% Error cases

a(A => _, [Arg | _], _, [(0, wrong_argument, {A, Arg}) | _]).