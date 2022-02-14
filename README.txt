
Grupo: Vinicius Atsushi, Marina Chagas e Guilherme de Souza.

Instruções para execução:

        ->  Executar no terminal o main.pl

        ->  ?- parametros.   
            (
                A função parametros vai ler na seguinte ordem: 
                1. dia inicial do roteiro
                2. dia final do roteiro
                3. hora inicial de cada dia do roteiro
                4. hora final de cada dia do roteiro
            )

        ->  ?- roteiro.
            (
                Vai exibir na tela o roteiro como uma lista de eventos,
                o roteiro está organizado da seguinte forma:

                Roteiro = [horario(evento('NomeEvento', <duração>),data(<dia>, <hora_inicio>, <hora_fim> )), horario(...), horario(...), ...] 

            )

        ->  ?- calendario.
            (
                Vai exibir na tela o calendário do mês de fevereiro
                sem os eventos cadastrados. Exemplo:
                Fevereiro de 2022
                Dia: 1: terça;
                Dia: 2: quarta;
                Dia: 3: quinta;
                Dia: 4: sexta;
                ...
            )

        ->  ?- calendarioEventos.
            (
                Vai exibir na tela o calendário do mês de fevereiro
                com os eventos cadastrados no roteiro. Exemplo:
                Fevereiro de 2022
                Dia: 1: terça;
                Dia: 2: quarta;
                'Evento1'
                'Evento2'
                Dia: 3: quinta;
                'Evento3'
                Dia: 4: sexta;
                'Evento4'
                Dia: 5: sábado;
                'Evento5'
                'Evento6'
                Dia: 6: domingo;
                'Evento7'
                'Evento8'
                ...
            )

OBS:
    Ambas as funções calendario e calendarioEventos abrem arquivos de texto e escrevem o calendario de Fevereiro
    sem e com eventos respectivamente. (Itens opcionais 1 e 2).

TRATAMENTO DE ERROS:

    O roteiro só é gerado caso todos os eventos sejam válidos.

    CASOS DE ERRO: 

    -> Caso o evento tenha uma duração > Fim_hora - Ini_hora do roteiro, retorna false.

    -> Caso o evento tenha que ser cadastrado em um dia > Fim_dia do roteiro 
    (Neste caso o roteiro é printado até o dia máximo do roteiro), retorna false.

    -> Os parametros da função parametros só são cadastrados em memória se estiverem válidos:
    Eles já vão servir como filtros para testar os eventos cadastrados no roteiro.

        ->> Dia_inicio > Dia_fim AND Dia_inicio > 0 AND Dia_inicio < 29
        ->> Dia_fim < Dia_inicio AND Dia_fim > 0 AND Dia_fim < 29

        ->> Hora_inicio < Hora_fim AND Hora_inicio >= 0 AND Hora_inicio < 24 
        ->> Hora_fim > Hora_inicio AND Hora_fim >= 0 AND Hora_fim < 24 