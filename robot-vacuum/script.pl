% Fatos iniciais
posicao(1, 1, sujeira).
posicao(2, 2, sujeira).
posicao(3, 3, sujeira).
posicao(4, 4, obstaculo).
posicao(5, 5, sujeira).

% Predicado para verificar se uma posição possui sujeira
possuiSujeira(X, Y) :-
    posicao(X, Y, sujeira).

% Predicado para verificar se uma posição possui obstáculo
possuiObstaculo(X, Y) :-
    posicao(X, Y, obstaculo).

% Predicado para limpar uma posição
limpar(X, Y) :-
    retract(posicao(X, Y, sujeira)).

% Predicado para mover o robô para a esquerda
moverEsquerda(X, Y, Xn, Y) :-
    Xn is X - 1,
    \+ possuiObstaculo(Xn, Y).

% Predicado para mover o robô para a direita
moverDireita(X, Y, Xn, Y) :-
    Xn is X + 1,
    \+ possuiObstaculo(Xn, Y).

% Predicado para mover o robô para cima
moverCima(X, Y, X, Yn) :-
    Yn is Y - 1,
    \+ possuiObstaculo(X, Yn).

% Predicado para mover o robô para baixo
moverBaixo(X, Y, X, Yn) :-
    Yn is Y + 1,
    \+ possuiObstaculo(X, Yn).

% Heurística de custo - Distância Manhattan
custo(X1, Y1, X2, Y2, Custo) :-
    Custo is abs(X1 - X2) + abs(Y1 - Y2).

% Heurística de avaliação - Soma do número de sujeiras restantes e custo até a sujeira mais próxima
avaliacao(X, Y, SujeirasRestantes, Avaliacao) :-
    findall(Custo, (posicao(Xs, Ys, sujeira), \+limpar(Xs, Ys), custo(X, Y, Xs, Ys, Custo)), Custos),
    sum_list(Custos, CustoTotal),
    SujeirasRestantes is CustoTotal + 1,
    Avaliacao is SujeirasRestantes.

% Predicado para encontrar o próximo movimento do robô
encontrarProximoMovimento(X, Y, Xn, Yn) :-
    findall(Avaliacao-Xn-Yn, (
        (moverEsquerda(X, Y, Xn, Yn); moverDireita(X, Y, Xn, Yn); moverCima(X, Y, Xn, Yn); moverBaixo(X, Y, Xn, Yn)),
        avaliacao(Xn, Yn, _, Avaliacao)
    ), ListaMovimentos),
    sort(ListaMovimentos, [_-Xn-Yn|_]).

% Predicado principal para limpar a sala
limparSala(X, Y) :-
    posicao(X, Y, sujeira),
    limpar(X, Y),
    write('Limpando posição ('

