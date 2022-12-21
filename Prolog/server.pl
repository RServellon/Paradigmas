%%%%%%%%%%%%%%%%%%%%%%%%% MODULES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_log)).
:- use_module(library(http/html_write)).
:- use_module(creator).
% Handlers calls
:- http_handler('/', home, []).

%handlers definitions
server(Port) :- http_server(http_dispatch, [port(Port)]).

set_setting(http:logfile, 'service_log_file.log').

home(_Request) :-
   http_read_json(_Request, DictIn,[json_object(term)]),
   format(user_output,"Request: ~p~n",[_Request]),
   format(user_output,"Body: ~p~n",[DictIn]),
   extractData(DictIn, DO),
   format(user_output,"Prueba: ~p~n",DO),
   create(DO, X),
   format(user_output,"X = : ~p~n",X),
   convert_to_reply(DictIn, X ,Reply),
   format(user_output,"Reply: ~p~n",[Reply]),
   %DictOut=DictIn,
   reply_json(Reply).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
extract_bytes_from_Json(JSon, SourceCode):-
   SourceCode = JSon.get(sourceCode).

%%%%%%%%%%%%%%%%%%%%%%%%PRUEBA Extraer datos%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extrae el urquery enviado por el cliente
extractData(json([data=B,_,_]), B).
%convierte el objeto DicInt en un Json
convert_to_Json(json([timestamp=A,data=B,result=C]), Json):- Json = _{timestamp:A, data: B, result:C}.
%manda el objetocon el mismo formato
convert_to_reply(json([data=A, result=_, timestamp=C]), UrQueryAtom, Reply):- 
   Reply = json([data=A, result=UrQueryAtom, timestamp=C]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- initialization
format('*** Starting Server ***~n', []),
(current_prolog_flag(argv, [SPort | _]) -> true ; SPort='8000'),
atom_number(SPort, Port),
format('*** Serving on port ~d *** ~n', [Port]),
server(Port).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%