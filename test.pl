:- begin_tests(inference).
:- use_module(infer).
:- use_module(maps).

% =================================== Application ======================================

% A function that takes an `int` and returns an `int` if applied with an `int` will also return an `int`
test(simple_type_inference_on_application, all(_Count = [1])) :-
    app(int => int, [int], T, []),
    T = int.

test(simple_type_application_to_curried_functions, all(_Count = [1])) :-
    app(int => int => int, [int], T, []),
    T = int => int.

test(simple_type_application_to_curried_functions_with_multiple_arguments, all(_Count = [1])) :-
    app(int => int => int, [int, int], T, []),
    T = int.

% ================================= Polymorphism ===================================

test(polymorphism, all(_Count = [1])) :-
    app(A => A, [A], A, []).

% =============================== Higher order functions ============================

test(higher_order_functions_retain_their_polymorhic_nature, all(_Count = [1])) :-
    Map = (A => B) => (list, A) => (list, B),
    Add = int => int => int,
    app(Add, [int], Add2, []),
    app(Map, [Add2], AddToAll, []),

    var(A), var(B),
    Add = int=>int=>int,
    Add2 = int=>int,
    AddToAll = (list,int)=>(list,int),
    Map = (A=>B) => (list, A) => (list, B).

% ================================= Union types =================================

test(union_types_definitions, all(_Count = [1])) :-
    type(Maybe, maybe, [A], [(Nothing, []), (Just, [A])]),
    JustOne << (Just, [int]),

    Just = A=>(maybe,[A]),
    JustOne = (maybe,[int]),
    Maybe = Nothing, Nothing = (maybe,[A]),
    var(A).

test(destructuring_over_union_types, all(_Count = [1])) :-
    % Just A = Just 10
    app(Just, [A], JustOne, Err) = app(Just, [int], JustOne, Err),

    A = int.

% ============================== Errors =================================

test(wrong_argument, all(_Count = [1])) :-
    app(int => int, [float], _, Err),

    Err = [(_Line, wrong_argument, {int,float}) | _ ].


% ============================= Complex examples =============================

test(define_a_list_type, all(_Count = [1])) :-
    type(List, list, [A], [
        (Nil, []),
        (Cons, [A, (list, [A])])
    ]),
    Nil2 << (Nil, []),
    R << (Cons, [int, Nil2]),

    Cons = A=>(list,[A])=>(list,[A]),
    List = Nil,
    Nil = (list,[A]),
    Nil2 = R, R = (list,[int]).

test(sum_function_defined, all(_Count = [1])) :-
    % sum([]) -> 0
    % sum(x :: xs) -> x + sum(xs)

    Add = int => int => int,
    type(_List, list, [A], [
        (Nil, []),
        (Cons, [A, (list, [A])])
    ]),

    % sum([])) -> 0
    Sum = Nil => int,

    % ---
    % e1 = x :: xs
    E1 << (Cons, [X, Xs]),
    % sum(e1) -> r2
    Sum = E1 => R2,

    % rest = sum(xs)
    SumRest << (Sum, [Xs]),
    % r = x + rest
    R2 << (Add, [X, SumRest]),


    % Assertions

    X = int,
    Xs = (list,[int]),
    Add = int=>int=>int,
    Sum = (list,[int])=>int,
    Cons = int=>(list,[int])=>(list,[int]).

% =============================== Maps =================================

test(simple_map, all(_Count = [1])) :-
    % A = %{x: 10, y: 20}
    % B = %{y: 10, x: 20}
    % A = B
    map([(x, int), (y, int)], A),
    map([(y, int), (x, int)], B),

    A = B.

:- end_tests(inference).
