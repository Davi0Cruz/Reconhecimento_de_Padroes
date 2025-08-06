

Pessoal,

Em virtude de algumas questões feitas por vocês, resolvi prestar aqui algumas orientações gerais sobre os classificadores a serem implementados e comparados no TC2.

1) classificador quadrático gaussiano: implementar a função discriminante na Eq. (167). Para isso, requere-se a execução das eqs. (165) e (166).

2) Variante 1: Requer a implementação da função discriminante da Eq. (177) com as Eqs. (175) e (176).

3) Variante 2: Requer a implementação da função discriminante da Eq. (201) com a Eq. (197).

4) Variante 3: Requer a implementação da função discriminante da Eq. (204) com as Eqs. (202) e (203).

5) Variante 4: Requer a implementação da função discriminante da Eq. (209) com as Eqs. (207) e (208).

Os classificadores 1-NN está na Eq. (9) e o de Máxima Correlação (MC) está na Eq. (64).

É isso.

Guilherme
Segue a Parte 2 das orientações gerais sobre o TC2.

Para o classificador quadrático gaussiano e suas variantes peço que retornem as seguintes métricas de desempenho:

1) STATS: Estatísticas da taxa de acerto/acurácia global (média, taxa mínima, taxa máxima, mediana, desvio padrão) após Nr rodadas de treino/teste.

2) TX_OK: Vetor com os Nr valores da taxa de acerto global para as Nr rodadas de treino/teste.

3) X: Dados de treinamento de cada classe (última rodada apenas).

4) m: Centroides de cada classe (última rodada apenas)

5) S: Matrizes de covariância de cada classe (última rodada apenas)

6) posto: Postos das matrizes de covariância (última rodada apenas)

Enviarei um código como exemplo, para um classificador baseado apenas na distância de Mahalanobis.

Atenciosamente,

Guilherme


Olá pessoal,

Para rodar o exemplo, basta descompactar o arquivo ZIP e chamar no prompt do Octave/Matlab o arquivo "avaliacao_mahalanobis.m".

É isso.

Guilherme

