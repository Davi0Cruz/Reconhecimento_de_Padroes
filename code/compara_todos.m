clear; clc;
warning('off', 'all')
pkg load statistics;
addpath('algs')
D=load('recfaces.dat');

Nr=50;  % No. de repeticoes

Ptrain=80; % Porcentagem de treinamentos
tic; [STATS{1} TX_OK{1} X0 m0 S0 posto{1}]=quadratico(D,Nr,Ptrain); Tempo(1)=toc;    % One COV matrix per class
tic; [STATS{2} TX_OK{2} X1 m1 S1 posto{2}]=variante1(D,Nr,Ptrain,0.01); Tempo(2)=toc; % Regularization method 1 (Tikhonov)
tic; [STATS{3} TX_OK{3} X2 m2 S2 posto{3}]=variante2(D,Nr,Ptrain); Tempo(3)=toc;     % One common COV matrix (pooled)
tic; [STATS{4} TX_OK{4} X3 m3 S3 posto{4}]=variante3(D,Nr,Ptrain,0.5); Tempo(4)=toc; % Regularization method 2 (Friedman)
tic; [STATS{5} TX_OK{5} X4 m4 S4 posto{5}]=variante4(D,Nr,Ptrain); Tempo(5)=toc;     % Naive Bayes Local (Based on quadratico)
% tic; [STATS{6} TX_OK{6} X5 m5 S5 posto{6}]=linearMQ(D,Nr,Ptrain); Tempo(6)=toc;     % Classificador Linear de Minimos Quadrados
normalizacoes = {'Sem', 'ZScore', '0_1', '-1_1'};
funcs = {@maxCorr, @dmc, @onekk}; 
funcs_names = {'MaxCorr', 'DMC', '1-KK'};
metadados = {};
for j = 1:length(funcs),
    m = 0;
    t = 0;
    sts = [];
    for i = 1:4
        tic; [stsb tmpb]=funcs{j}(normalization(D, i),Nr,Ptrain); tb=toc; 
        if mean(tmpb) > m
            best = i; m = mean(tmpb); t = tb; sts = stsb; tmp = tmpb;
        end
    end
    TX_OK{end+1} = tmp; Tempo(end+1) = t; STATS{end+1} = sts;
    disp(sprintf('Melhor normalização para %s: %s', funcs_names{j}, normalizacoes{best}));
    metadados{end+1} = sprintf('%s: %s', funcs_names{j}, normalizacoes{best});
end

names = {"Quadrático", "Variante 1", "Variante 2", "Variante 3", "Variante 4", "MaxCorr", "DMC", "1-KK"};
file_id = fopen('../results/table.txt', 'w');
fprintf(file_id, 'Classificador,Média,Mínimo,Máximo,Mediana,Desvio Padrão,Tempo de Execução (s)\n');
for i = 1:length(Tempo),
    media = STATS{i}(1);
    minimum = STATS{i}(2);
    maximum = STATS{i}(3);
    mediana = STATS{i}(4);
    dpadrao = STATS{i}(5);
    fprintf(file_id, '%s,%f,%f,%f,%f,%f,%f\n', names{i}, media, minimum, maximum, mediana, dpadrao, Tempo(i));
end
fclose(file_id);
file_id = fopen('../results/metadata.txt', 'a+');
for i = 1:length(metadados),
    fprintf(file_id, '%s\n', metadados{i});
end
fclose(file_id);
disp('Resultados salvos em ../results/table.txt');
file_id = fopen('../results/posto.txt', 'a+');
for i = 1:length(posto),
    fprintf(file_id, '%f,', posto{i});
end
fprintf(file_id, '\n');
fclose(file_id);

save ../results/tx_ok.mat TX_OK;

