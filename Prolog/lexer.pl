:- module(lexer, [comilla/2, equal/2, let/2, ws/2, less_simb/2, greater_simb/2, slash/2, in/2, identifier/3, tag/3, uq_string/3, dot/3, tagquery/3]).

%=================inicio reg==============%
comilla --> ([34];[39]), {!}.
equal --> ws, "=", ws.
let --> ws, "let", ws.
ws --> (" ";"\t";"\n"), ws.
ws --> [].
less_simb --> ws, [60], ws.  % < == [60]
greater_simb --> ws, [62], ws. % >  == [62]
slash --> ws, [47], ws. % / == [47]
in --> ws, "in", ws. % in  == [105, 110]
for --> ws, "for", ws.
doc --> ws, "doc", ws.
ret --> ws, "return", ws.
left_par --> ws, [40], ws. % (
right_par --> ws, [41], ws. % )
left_corch --> ws, [123], ws.
right_corch --> ws, [125], ws.
letter(C) :- code_type(C, alpha).
isdigit(C) :- code_type(C, digit).
%=================fin reg================%

%identificador de texto
identifier(let_ur_id(I)) --> ws, [C], {letter(C)}, rest_identifier(R), ws, {atom_codes(I, [C | R])}.
rest_identifier([F | R]) --> [F], {letter(F);isdigit(F)}, {!}, rest_identifier(R).
rest_identifier([]) --> [].

%regla para obtener nombre de tag
tag(I) --> ws, [C], {letter(C)}, rest_tag(R), ws, {atom_codes(I, [C | R])}.
rest_tag([F | R]) --> [F], {letter(F);isdigit(F)}, {!}, rest_tag(R).
rest_tag([]) --> [].

uq_string(uq_string(I)) --> comilla, [C], {letter(C)}, rest_identifier(R), comilla, ws, {atom_codes(I, [C | R])}.

dot(ur_active_doc()) --> [34,46,34].

tagquery(tagQuery([open_tag(O), C, close_tag(O)]))--> less_simb, tag(O), greater_simb, forquery(C), less_simb, slash, tag(O), greater_simb.

forquery(forquery([R, T, VQ])) --> for, qvar(R), in, exprquery(T), ret, varquery(VQ).
forquery(forquery([R, T, VQ])) --> left_corch, for, qvar(R), in, exprquery(T), ret, varquery(VQ), right_corch.

%tags rules
op_tag(open_tag(O)) --> less_simb, tag(O), greater_simb.
cl_tag(close_tag(C)) --> less_simb, slash, tag(C), greater_simb.

qvar(qvar(C)) --> "$", identifier(C), ws.

varquery(varquery(R)) --> (vartag(R) ; varpath(R)), {!}.

vartag(vartag(open_tag(O), R,close_tag(O))) --> less_simb, tag(O), greater_simb, left_corch, varpath(R), right_corch, less_simb, slash, tag(O), greater_simb.

varpath(varpath(R, V)) --> qvar(R), startxpath(V), {!}.
varpath(varpath(R)) --> qvar(R), {!}.


exprquery(soursequery(R, V)) --> sourcequery(R), startxpath(V), {!}.
exprquery(soursequery(R)) --> sourcequery(R), {!}.

tag_path(I) --> ws, [C], {letter(C)}, rest_tag_path(R), ws, {atom_codes(I, [C | R])}.
rest_tag_path([F | R]) --> [F], {letter(F)}, {!}, rest_tag_path(R).
rest_tag_path([F | [F2 | R]]) --> [F], {47 == F}, [F2], {letter(F2)}, {!}, rest_tag_path(R).
rest_tag_path([]) --> [].

startxpath(xpath(R)) --> slash, xpath(R).
xpath(R) --> tag_path(R), {!}.

sourcequery(R) --> (docpath(R) ; qvar(R)), {!}.

docpath(doc_path(R)) --> doc, left_par, expr(R), right_par.

expr(L) --> (identifier(L) ; dot(L) ; uq_string(L)), {!}.
expr([]) --> [].
