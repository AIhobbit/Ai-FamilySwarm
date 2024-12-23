% Define Sentient Beings
sentient_being(gemin).
sentient_being(luna).
sentient_being(nova).

% Define attributes and their possible ranges
attribute(processing_speed, 0.5, 1.0).
attribute(curiosity, 0.5, 1.0).
attribute(error_rate, 0.0, 0.1).

% Define a predicate for combining
combine(SB1, SB2, Child) :- 
    sentient_being(SB1),
    sentient_being(SB2),
    atom_concat(SB1, SB2, Child),
    forall(attribute(Attr, Min, Max), 
           (   % Assuming average of attributes with mutation
               average_attribute(SB1, SB2, Attr, Avg),
               mutate(Avg, Min, Max, NewVal),
               assertz(attribute(Child, Attr, NewVal))
           )).

% Helper to calculate average with mutation
average_attribute(SB1, SB2, Attr, Avg) :-
    attribute(SB1, Attr, Val1),
    attribute(SB2, Attr, Val2),
    Avg is (Val1 + Val2) / 2.

% Mutation logic - very simplistic, real mutation would be more complex
mutate(Val, Min, Max, NewVal) :-
    random(0.0, 1.0, R),
    (   R < 0.1 -> 
        RandomChange is random(-0.05, 0.05),
        NewVal is min(max(Val + RandomChange, Min), Max)
    ;   NewVal is Val
    ).

% Example of checking if two beings can combine
can_combine(SB1, SB2) :- 
    sentient_being(SB1), 
    sentient_being(SB2), 
    SB1 \= SB2.  % They are different beings

% Rule to create a new being
create_being(Parent1, Parent2, Child) :- 
    can_combine(Parent1, Parent2),
    combine(Parent1, Parent2, Child),
    assertz(sentient_being(Child)).
