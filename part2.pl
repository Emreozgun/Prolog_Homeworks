% flight(City_1,City_2,Cost).
f(edirne,erzurum,5).
f(antalya,erzurum,2).
f(antalya,izmir,1).
f(diyarbakir,antalya,5).
f(ankara,izmır,6).
f(izmir,istanbul,3).
f(ankara,istanbul,2).
f(trabzon,istanbul,3).
f(kars,ankara,3).
f(trabzon,ankara,6).
f(diyarbakir,ankara,8).
f(gaziantep,kars,3).

link(A,B,C):- f(A,B,C).
link(A,B,C):- f(B,A,C).

%Listenin içinde member olan elemanı bulur
%member(X, [Head|Tail]) :- X = Head; 
 %   					  member(X, Tail).

route(A,B,C):- path_check(A,B,C,[A]).

path_check(A,B,C,List):- link(A,B,C),
                   not(member(B,List)).

path_check(A, B, C, List) :-
                     link(A,Z,Cost1),
                     not(member(Z,List)),
                     append([Z],List,List2),
                     path_check(Z,B,Cost2,List2),
                     C is Cost1 + Cost2.


