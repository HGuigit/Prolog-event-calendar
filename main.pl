% Grupo: Vinicius Atsushi, Marina Chagas e Guilherme de Souza.


% / --------------------------------------------------/

%               Variáveis Globais

:- dynamic ini_hora/1.
:- dynamic fim_hora/1.
:- dynamic ini_dia/1.
:- dynamic fim_dia/1.

% setando inicialmente como valores inválidos
:- asserta(ini_hora(99)).
:- asserta(fim_hora(99)).
:- asserta(ini_dia(99)).
:- asserta(fim_dia(99)).

% Criando o fato global para armazenar a lista do roteiro / Inicializando com a string 'Vazio'
:- dynamic roteiro_global/1.
:- assertz(roteiro_global('Vazio')).

% / --------------------------------------------------/

%               Arquivo de leitura de eventos:

:- consult('eventos.pl').

% / --------------------------------------------------/

%               Funções:

if(Condição,Then,_):- Condição, !, Then.
if(_,_,Else) :- Else.

% / --------------------------------------------------/

%               3. Mostar o calendário de Fevereiro sem eventos:

diasSemana(1, terça).
diasSemana(2, quarta).
diasSemana(3, quinta).
diasSemana(4, sexta).
diasSemana(5, sábado).
diasSemana(6, domingo).
diasSemana(7, segunda).
diasSemana(Dia, Nome) :-
 (Dia =< 28),
 OutroDiaMesmoDiaSemana is Dia - 7,
 diasSemana(OutroDiaMesmoDiaSemana, Nome)
.

imprimeDia(N,Max) :-
  (

  (N =< Max),
  diasSemana(N, Nome),
  format("Dia: ~d: ~a;~n", [N,Nome]),
  Proximo is N + 1,
  imprimeDia(Proximo,Max)

  ); true
.

calendario :-
 tell('Calendario.txt'),
 write("Fevereiro de 2022"), nl,
 imprimeDia(1,28),
 told.

%           Fim do 3.

% / --------------------------------------------------/

%           1. Funções para exibir o roteiro como lista:

% Lendo Ini Roteiro / Fim Roteiro / Ini_hora Roteiro / Fim_hora Roteiro

parametros :-
  % Lendo Primeiro dia
   read(Num),
   
  % Lendo Ultimo dia
   read(Num2),
   
  % Lendo Primeira hora
   read(Num3),
   
  % Lendo Ultima hora
   read(Num4),
   
   verifica_parametros(Num, Num3, Num2, Num4),

   % setando variáveis globais depois de verificadas:
   retract(ini_dia(_)),
   retract(fim_dia(_)),
   retract(ini_hora(_)),
   retract(fim_hora(_)),

   assertz(ini_dia(Num)),
   assertz(fim_dia(Num2)),
   assertz(ini_hora(Num3)),
   assertz(fim_hora(Num4)),

   % Printando os valores lidos (depois de validados)

   write('Primeiro dia: '),
   ini_dia(Dia), write(Dia), nl, 

   write('Ultima dia: '),
   fim_dia(Dia2), write(Dia2), nl,

   write('Primeira hora de cada dia: '),
   ini_hora(Hora), write(Hora), nl,

   write('Última hora de cada dia: '),
   fim_hora(Hora2), write(Hora2), nl,


   % setando configurações de controle do dia e hora do roteiro:

   assertz(ctrl_dia(Dia)),
   assertz(ctrl_hora(Hora)).


% Roteiro = [horario(evento('EventoExemplo', <duração>),data(<dia>, <hora_inicio>, <hora_fim>)) , ...]

roteiro :-
  Event = evento(_,_),
  findall(Event, Event, ListaEventos),

  % Lista eventos possui todos os eventos
  [Head|Tail] = ListaEventos,
  L = [],

  ini_hora(Ini_hora),
  ini_dia(Ini_dia),
  criar_roteiro(Head, Tail, L, Ini_hora, Ini_dia).

  
% Criar roteiro para o caso em que existe apenas um evento (Tail = Lista vazia)

criar_roteiro(Head, [], L, Hora, Dia) :-
  evento(NomeEvento,Duracao) = Head,
  fim_hora(F_hora),
  ini_hora(Ini_hora),
  fim_dia(F_dia),
  
  if(
      (Duracao > (F_hora - Ini_hora)),

      (format('Evento ~s inválido, parando execução!!',NomeEvento), false),

      (true)

  ),

  if(

    % Condição do IF
    (
      (Duracao + Hora) =< F_hora
    ),

    % Caso TRUE (Evento cabe no mesmo dia)
    (
        Total_hora is (Duracao + Hora),
        NewHora is Total_hora,
        NewDia is Dia,
        append(L,[horario(Head, data(NewDia, Hora, NewHora))],NewL)
    ),
      
    % Caso FALSE (Evento deve ser adicionado no próximo dia)
    (
        NewDia is (Dia + 1),
        NewHora is (Duracao + Ini_hora),
        if(
          (NewDia > F_dia),

          (
            false
          ),

          (
            append(L,[horario(Head, data(NewDia, Ini_hora, NewHora))],NewL)
          )
        )
    )

  ),
  print('Roteiro =  '),
  print(NewL),

  % armazenando a lista do roteiro em um fato global
  retract(roteiro_global(_)),
  assertz(roteiro_global(NewL)),
  true
.

% Criar roteiro para o evento atual (Head) e Tail possui mais eventos a serem inseridos

criar_roteiro(Head, Tail, L, Hora, Dia) :-
  evento(NomeEvento,Duracao) = Head,
  fim_hora(F_hora),
  ini_hora(Ini_hora),
  fim_dia(F_dia),

  if(
      (Duracao > (F_hora - Ini_hora)),

      (format('Evento ~s inválido, parando execução!!',NomeEvento), false),

      (true)

  ),


  if(

    % Condição do IF
    (
      (Duracao + Hora) =< F_hora
    ),

    % Caso TRUE (Evento cabe no mesmo dia)
    (
        Total_hora is (Duracao + Hora),
        NewHora is Total_hora,
        NewDia is Dia,
        append(L,[horario(Head, data(NewDia, Hora, NewHora))],NewL)
    ),
      
    % Caso FALSE (Evento deve ser adicionado no próximo dia)
    (
        NewDia is (Dia + 1),
        NewHora is (Duracao + Ini_hora),
        if(
          (NewDia > F_dia),

          (
            print(L),
            false
          ),

          (
            append(L,[horario(Head, data(NewDia, Ini_hora, NewHora))],NewL)
          )
        )

    )

  ),
  
  [Head2|Tail2] = Tail,
  criar_roteiro(Head2, Tail2, NewL,NewHora, NewDia)
.


%             Fim do 1.

% / --------------------------------------------------/

%             2. Funções para Exibir o calendário Mensal com os eventos de cada dia:


exibir_eventos(Dia) :-
  roteiro_global(L),
  [Head|Tail] = L,

  printar_evento(Head, Tail, Dia)
.


printar_evento(Head, [], Dia) :-
  horario(evento(Nome,_),data(Day,_,_)) = Head,

  if(
    (Day =:= Dia),

    (print(Nome), nl),

    (write(''))
  )
.

printar_evento(Head, Tail, Dia) :-
  horario(evento(Nome,_),data(Day,_,_)) = Head,

  if(
    (Day =:= Dia),

    (print(Nome), nl),

    (write(''))
  ),

  [Head2|Tail2] = Tail,
  printar_evento(Head2, Tail2, Dia)
.


imprimeDiaEventos(N,Max) :-
  (
  (N =< Max),
  diasSemana(N, Nome),
  format("Dia: ~d: ~a;~n", [N,Nome]),
  Proximo is N + 1,
  exibir_eventos(N),
  imprimeDiaEventos(Proximo,Max)

  ); true
.

calendarioEventos :-
 tell('CalendarioEventos.txt'),
 write("Fevereiro de 2022"), nl,
 imprimeDiaEventos(1,28),
 told.


%               Fim do 2.

% / --------------------------------------------------/


%               Funções de Validação


verifica_parametros(Dia_ini, Hora_ini, Dia_fim, Hora_fim) :- 

% validando dias

  if(
    (
      Dia_ini < Dia_fim,
      Dia_ini > 0,
      Dia_ini < 29,
      Dia_fim > 0,
      Dia_fim < 29
    ),

    (true),

    (false)
  ),

  % validando horas

  if(
    (
      Hora_ini < Hora_fim,
      Hora_ini >= 0,
      Hora_ini < 24,
      Hora_fim >= 0,
      Hora_fim < 24
    ),

    (true),

    (false)
  )
.


% / --------------------------------------------------/