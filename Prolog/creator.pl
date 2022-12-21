
:- module(creator, [create/2]).
:- use_module(lexer).
:- dynamic lista/1.
:- discontiguous emit/2.
:- discontiguous emit/3.


test(R, O) :- 
    File = 'test.txt',
    read_file_to_codes(File, Codes, []),
    atom_codes(Input, Codes),
    format('Input=~n~s~n', [Input]),
    progUrQuery(R, Codes, O),
    show(R, AstJS),
    generate_jsAst_to_js_atom(AstJS, B),
    writeln(B)
    . 

create(I, O):-
    atom_codes(I, Codes),
    progUrQuery(R, Codes, _),
    show(R, AstJS),
    generate_jsAst_to_js_atom(AstJS, O).


%=========================================LEXER==============================================%

progUrQuery(urProg(R)) --> (letprog(R);urQuery(R)),{!}.

%regla letprog --> devuelve el arbol de la forma -> [let(let_id(L), R), urQuery]
letprog([let(L, R), UrQ]) --> let, {!}, identifier(L), equal, {!}, expr(R), in, urQuery(UrQ). %let con urQuery

%regla urQuery --> devuelve el arbol de la forma -> tagQuery(open_tag(O),R,close_tag(O))
urQuery(R) --> tagquery(R).

expr(L) --> (identifier(L) ; dot(L) ; uq_string(L)), {!}.
expr([]) --> [].

show(urProg([A|Rest]), jsProg([RA|RRest])) :-
    show(A, RA), show(Rest, RRest), !.

show([tagQuery([A|Rest])], [jstagQuery([RA|RRest])]) :- 
     show(A, RA), show(Rest, RRest).

show(forquery([A|Rest]), jsfor([RA|RRest])) :- 
    show(A, RA), show(Rest, RRest).

show([A|A2],[RA,RA2]) :-show(A,RA), show(A2,RA2).

show(A,RA):- toJS(A, RA).


toJS(let(A, B), let(RA, RB)):-toJS(A, RA), toJS(B, RB).
toJS(uq_string(A), js_string(A)).
toJS(let_ur_id(A), js_id(A)).
toJS(ur_active_doc(),active_doc()).

%parte del urquery

toJS(tagQuery([F | R]), tagjs([FR | RR])) :- toJS(F, FR), toJS(R, RR).
toJS(open_tag(A), open_tag(A)).
toJS(close_tag(A), close_tag(A)):-!.
toJS(qvar(A), jsqvar(RA)) :- toJS(A,RA).

    %urQuery
toJS(soursequery(A, B), soursequeryjs(RA, RB)):- toJS(A, RA), toJS(B, RB).
toJS(soursequery(A), soursequeryjs(RA)):- toJS(A, RA).

toJS(doc_path(A), jsDoc_path(RA)) :- toJS(A, RA).
toJS(xpath(A), jsXpath(A)).

toJS(varquery(A), jsvarquery(RA)) :- toJS(A, RA).
toJS(vartag(A,B,C), jsvartag(RA,RB,RC)):- toJS(A,RA), toJS(B,RB), toJS(C,RC).
toJS(varpath(A,B), jsvarpath(RA,RB)):-toJS(A,RA), toJS(B,RB).
toJS(varpath(A), jsvarpath(RA)) :- toJS(A, RA).

toJS([],[]).

open_memory_outputstream(Handle, InMemoryStream):-
    new_memory_file(Handle),
    open_memory_file(Handle, write, InMemoryStream)
  .
      
  produce_atom_from_stream(A) :-
    open_memory_outputstream(Handle, InMemoryStream),
    emit_something(InMemoryStream),
    close(InMemoryStream),
    memory_file_to_atom(Handle, A),
    free_memory_file(Handle)
  .
  
  emit_something(InMemoryStream) :-
      format(InMemoryStream, 'let x = ~s~n', [something]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GENERATE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
generate_jsAst_to_js_atom(JsAst, JsAtom):-
    open_memory_outputstream(Handle, InMemoryStream),
    form(JsAst, JsProcesable),
    emit(JsProcesable, InMemoryStream),
    !,
    close(InMemoryStream),
    memory_file_to_atom(Handle, JsAtom),
    free_memory_file(Handle).

form(jsProg([A|B]), R) :- 
    Import = import('ur_doc, ur_evaluate, ur_tag, ur_active_doc'),
    parameter(A, C),
    Function = function(js_id(ur_Query_01), [C], B),
    Main = functionMain(js_id(main), [], A, ret(ur_Query_01)),
    R = elementos([Import, Function, Main]).

parameter(let(js_id(A),_), A).

emit(elementos(A),Stream):-
    forall(member(P, A), (emit(P, Stream), nl(Stream)) ).

%function(js_id(ur_Query_01), B, C) -> B = uri , C= [jstagQuery([open_tag(ul),jsfor([jsqvar(js_id(li)),soursequeryjs(jsDoc_path(js_id(uri)),jsXpath(li)),[jsvarquery(jsvartag(open_tag(li),jsvarpath(jsqvar(js_id(li))),close_tag(li))),[]]]),[close_tag(ul),[]]])]
emit(function(js_id(Name), B, C), Stream) :-
    format(Stream, '~n function ~s(', [Name]),
    emit_argslist(B, Stream),  %progress--> %function ur_Query_01( uri
    format(Stream, ') {~n ~t ~t ~t', []), %progress-->     %function ur_Query_01( uri ) {
    emit(C, Stream, B, R),
    format(Stream, '\treturn ~s_tag([...for_01(', [R]),
    emit(B, Stream),
    format(Stream, ')])~n}', []). %progress-->     %function ur_Query_01( uri ) { ... }

emit(functionMain(js_id(Name), B, C, R), Stream) :-
    format(Stream, '~nfunction ~s(', [Name]),
    emit_argslist(B, Stream),
    format(Stream, ') {~n\t', []),
    emit(C, Stream),
    format(Stream, '~n\treturn ',[]),
    emit(C, R, Stream),
    format(Stream, '~n}', []).

emit([E], Stream):-
    format(Stream, '~s', [E]).

emit([E],Stream, C, R):- %recibe E =[jstagQuery([open_tag(ul),jsfor([jsqvar(js_id(li)),soursequeryjs(jsDoc_path(js_id(uri)),jsXpath(li)),[jsvarquery(jsvartag(open_tag(li),jsvarpath(jsqvar(js_id(li))),close_tag(li))),[]]]),[close_tag(ul),[]]])]
emit(E, Stream, C, R).

emit(jstagQuery(E), Stream, C, R):- %E = [open_tag(ul),jsfor([jsqvar(js_id(li)),soursequeryjs(jsDoc_path(js_id(uri)),jsXpath(li)),[jsvarquery(jsvartag(open_tag(li),jsvarpath(jsqvar(js_id(li))),close_tag(li))),[]]]),[close_tag(ul),[]]]
    devolverUl(E, R),
    forall(member(P, E), (emit(P, Stream, C), nl(Stream)) ).

devolverUl([open_tag(E)|_],E).


emit(open_tag(A), Stream, _):- % A = ul
    format(Stream, '\tconst ~s_tag = ', A),
    emit_lambda(A, Stream, 'children'). %creara lambda -> children => ur_tag(" ul ", children)

emit(jsfor(E), Stream, [C]):- %E -> [jsqvar(js_id(li)),soursequeryjs(jsDoc_path(js_id(uri)),jsXpath(li)),[jsvarquery(jsvartag(open_tag(li),jsvarpath(jsqvar(js_id(li))),close_tag(li))),[]]]
    format(Stream, '\tfunction* for_01(~s){ ~n\t', [C]),
    forall(member(P, E), (emit(P, Stream, C), nl(Stream)) ),
    format(Stream, '\t}', []).

emit(jsqvar(js_id(A)), Stream, _):- %A = li
    format(Stream, '\tconst ~s_tag = ', A),
    emit_lambda(A, Stream, 'child'). %creara lambda -> child => ur_tag(" li ", child)

emit(soursequeryjs(A, B), Stream, _):-  %--> A -> jsDoc_path(js_id(uri)) B-->jsXpath(li))
    format(Stream, '\t\tconst xpathResultIter = ur_evaluate(', []),
    emit(A, Stream),
    emit(B, Stream),
    format(Stream, ')', []).

emit(jsDoc_path(js_id(A)), Stream) :- 
    format(Stream, 'ur_doc(~s),', [A]).

emit(jsXpath(A), Stream) :- 
    format(Stream, '"/~s"', [A]).

emit(let(js_id(A),_), ret(R), Stream):-
    format(Stream, '~s(~s)', [R,A]).

emit([A|_], Stream, _):-  % A ->  jsvarquery(jsvartag(open_tag(li),jsvarpath(jsqvar(js_id(li))),close_tag(li)))
      emit(A, Stream).

emit(jsvarquery(B), Stream):-
    emit(B, Stream).

emit(jsvartag(open_tag(_),jsvarpath(jsqvar(js_id(B))),close_tag(_)), Stream):-
    format(Stream, '\t\tfor(~s of xpathResultIter){~n\t\t\tyield ~s_tag(~s) ~n\t\t}', [B,B,B]).

emitNothing(A, Stream):- 
    format(Stream, '\tFalta procesar instruccion..', []).

emit_lambda(A, Stream, B):- 
    format(Stream, '~s => ur_tag(" ~s ", ~s) ', [B,A,B]).

emit(active_doc(), Stream):- 
    format(Stream, 'active_doc()',[]).

emit(js_id(A), Stream):- 
    format(Stream, '~s',[A]).

emit(js_string(A), Stream):- 
    format(Stream, '"~s"',[A]).

emit_argslist([], _).
emit_argslist([Arg], Stream) :- !,
emit(Arg, Stream)
.
emit_argslist([Arg1, Arg2 | RestArgs], Stream) :-
    emit(Arg1, Stream),
    format(Stream, ', ', []),
    emit_argslist([Arg2 | RestArgs], Stream).

emit(import(A), Stream):-
    format(Stream, 'import { ~s }', [A]).

emit(jstagQuery([A]), Stream) :-
    forall(member(P, A), (emit(P, Stream), nl(Stream)) ).

emit(jsfor([A]), Stream) :-
    forall(member(P, A), (emit(P, Stream), nl(Stream)) ).

emit([], _).

emit(let(js_id(A),B), Stream):-
    format(Stream,'let ~s = ', [A]),
    emit(B, Stream).

emit(close_tag(_), Stream):-
    format(Stream,'', []).

emit(A, Stream):-
    format(Stream,' ~s ', [A]).
