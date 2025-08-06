% Routines for opening face images and convert them to column vectors
% by stacking the columns of the face matrix one beneath the other.
%
% Last modification: 10/08/2021
% Author: Guilherme Barreto

clear; clc; close all;

pkg load image;
pkg load statistics;

args = argv(); 
% args{1} = size of the face image (default: 20)
% args{2} = number of individuals (default: 3)
% args{3} = apply PCA (default: 0, no PCA; 1, apply PCA)
if isempty(args)
    args = {20, 3, 0};  % Default values
else
    if length(args) < 3
        args{3} = 0;  % Default to no PCA if not specified
    end
    for i=1:3
        args{i} = str2num(args{i});  % Convert string arguments to numbers
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fase 1 -- Carrega imagens disponiveis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
part1 = '../faces/subject0';
part2 = '../faces/subject';
part3 = {'.centerlight' '.glasses' '.happy' '.leftlight' '.noglasses' '.normal' '.rightlight' '.sad' '.sleepy' '.surprised' '.wink'};
part4 = strvcat(part3);

Nind=args{2};   % Quantidade de individuos (classes)
Nexp=length(part3);  % Quantidade de expressoes

X=[];  % Matriz que acumula imagens vetorizadas
Y=[];  % Matriz que acumula o rotulo (identificador) do individuo
Z=[];
NAME=[];
metadados = {};
for i=1:Nind,  % Indice para os individuos
    for j=1:Nexp,   % Indice para expressoes
        if i<10,
            nome = strcat(part1,int2str(i),part4(j,:));    % Monta o nome do arquivo de imagem
        else
            nome = strcat(part2,int2str(i),part4(j,:));
        end

        Img=imread(nome);  % le imagem

        Ar = imresize(Img,[args{1} args{1}]);   % (Opcional) Redimensiona imagem
        An=Ar; %An=imnoise(Ar,'gaussian',0,0.005);  % (Opcional) adiciona ruido

        A=im2double(An);  % converte (im2double) para double precision

        a=A(:);  % Etapa de vetorizacao: Empilhamento das colunas
        if args{3} == 3,
            % Box-Cox com teste de komogorov-smirnov
            lamb = 0.2;
            al = (a .^ lamb - 1) / lamb; %log(a);
            m = mean(a);
            s = std(a);
            Xn = normrnd(m, s, size(a));
            H = kstest2(al, Xn);
            if H == 1,
                a = al;
            else
                disp('Box-Cox not applied');
                metadados{end+1} = sprintf('Box-Cox not applied for individual %d, expression %d', i, j);
                break;
            end
        end
        %ROT=zeros(Nind,1); ROT(i)=1;  % Cria rotulo da imagem (binario {0,1}, one-hot encoding)
        %ROT=strcat(part1,int2str(i));
        %ROT=-ones(Nind,1); ROT(i)=1;  % Cria rotulo da imagem (bipolar {-1,+1})
        ROT = i;   % Rotulo = indice do individuo

        X=[X a]; % Coloca cada imagem vetorizada como coluna da matriz X
        Y=[Y ROT]; % Coloca o rotulo de cada vetor como coluna da matriz Y
    end
end
%%%%%%%% APLICACAO DE PCA (PCACOV) %%%%%%%%%%%
if args{3} > 0,
    % normalize data
    % X = X';
    % disp(size(std(X)));
    % X = (X - mean(X));
    % X = X';
    [V L VEi]=pcacov(cov(X'));
    q=args{1}*args{1}; Vq=V(:,1:q); Qq=Vq';
    VEq=cumsum(VEi); 
    % figure; plot(VEq,'r-','linewidth',3);
    % xlabel('Autovalor');
    % ylabel('Variancia explicada acumulada');
    % waitforbuttonpress;
    if args{3} >= 2
        I = find(VEq >= 98.0)(1);  % Seleciona componentes principais que explicam pelo menos 95% da variancia
        q = I;  % Reduz dimensionalidade
        Vq = V(:,1:q); Qq = Vq';
        metadados{end+1} = sprintf('PCA applied with %d components for individual %d', q, i);
        if args{3} == 2,
            name = sprintf('../figs/pca_variance.pdf');
        else
            name = sprintf('../figs/pca_variance_box.pdf');
        end
        %figure('position', [0, 0, 900, 600]);
        plot(1:length(VEq),VEq, 'r-', 'linewidth', 3);
        xlabel('Componentes principais');
        ylabel('Variância explicada acumulada (%)');
        title(sprintf('PCA: Variância explicada (98%% - %d componentes)', q));
        % point where variance is 98%
        % scatter(q, VEq(q), 100, 'b', 'filled');
        print(name, '-dpdf');
        close all;
    end
    X=Qq*X;
    
end

Z=[X;Y];  % Formato 01 vetor de atributos por coluna: DIM(Z) = (p+1)xN
Z=Z';     % Formato 01 vetor de atributos por linha: DIM(Z) = Nx(p+1)
disp(size(Z));
file_id = fopen('../results/metadata.txt', 'a+');
for i = 1:length(metadados),
    fprintf(file_id, '%s\n', metadados{i});
end
fclose(file_id);

save -ascii recfaces.dat Z

%save -ascii yale1_input20x20.txt X
%save -ascii yale1_output20x20.txt Y



