clear; clc;
pkg load statistics;
addpath('algs')

load model11.dat
load model22.dat
Xi1 = X1{1};
Xe1 = X1{2};
Xi2 = X2{1};
Xe2 = X2{2};

Nr=50;  % No. de repeticoes
m = mean(Xi2, 2);
st = std(Xi2')';
Xi2 = (Xi2 - m) ./ st;  % Normalization of the data
Xe2 = (Xe2 - m) ./ st;  % Normalization of the data

Ptrain=80; % Porcentagem de treinamentos
% tic; [STATS{1} TX_OK{1} X1 m1 S1 posto]=variante1(M1,Nr,Ptrain, 0.01); Tempo(1)=toc; 
% tic; [STATS{2} TX_OK{2}]=dmc(normalization(M2, 2),Nr,Ptrain); Tempo(2)=toc;
tic; [STATS{1}]=variante1i(Xi1, Xe1,Nr,Ptrain, 0.01); Tempo(1)=toc; 
tic; [STATS{2}]=dmci(Xi2, Xe2, Nr,Ptrain); Tempo(2)=toc;

names = {"Média", "Desvio Padrão"};
for i = 1:length(Tempo),
    nome = sprintf('../results/model%d.txt', i);
    file_id = fopen(nome, 'w');
    fprintf(file_id, 'Métrica,Média,Desvio Padrão\n');
    media_acuracia = STATS{i}(1);
    std_acuracia = STATS{i}(2);
    fprintf(file_id, 'Acurácia,%f,%f\n', media_acuracia, std_acuracia);
    media_falso_positivo = STATS{i}(3);
    std_falso_positivo = STATS{i}(4);
    fprintf(file_id, 'Falso Positivo,%f,%f\n', media_falso_positivo, std_falso_positivo);
    media_falso_negativo = STATS{i}(5);
    std_falso_negativo = STATS{i}(6);
    fprintf(file_id, 'Falso Negativo,%f,%f\n', media_falso_negativo, std_falso_negativo);
    media_sensibilidade = STATS{i}(7);
    std_sensibilidade = STATS{i}(8);
    fprintf(file_id, 'Sensibilidade,%f,%f\n', media_sensibilidade, std_sensibilidade);
    media_precisao = STATS{i}(9);
    std_precisao = STATS{i}(10);
    fprintf(file_id, 'Precisão,%f,%f\n', media_precisao, std_precisao);
    fclose(file_id);
end
% fprintf(file_id, 'Classificador,Média,Mínimo,Máximo,Mediana,Desvio Padrão,Tempo de Execução (s)\n');
% for i = 1:length(Tempo),
%     media = STATS{i}(1);
%     minimum = STATS{i}(2);
%     maximum = STATS{i}(3);
%     mediana = STATS{i}(4);
%     dpadrao = STATS{i}(5);
%     str = sprintf('%s,%f,%f,%f,%f,%f,%f\n', names{i}, media, minimum, maximum, mediana, dpadrao, Tempo(i));
%     fprintf(file_id, '%s', str);
%     disp(str);
% end
% fclose(file_id);
