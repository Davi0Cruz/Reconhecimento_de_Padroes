function ndata = normalization(data, method)
    % Normaliza os dados de acordo com o método especificado
    switch method
        case 1
            ndata = data;  % Sem normalização
        case 2
            [ndata, ~, ~] = normalizationZScore(data);
        case 3
            [ndata, ~, ~] = normalizationZeroOne(data);
        case 4
            [ndata, ~, ~] = normalizationOneOne(data);
        otherwise
            error('Método de normalização desconhecido: %s', method);
    end
end

function [ndata, mu, sigma] = normalizationZScore(data)
    % Normaliza os dados para média 0 e desvio padrão 1 por coluna
    X = data(:, 1:end-1);  % Exclui a última coluna (rótulos)
    Y = data(:, end);  % Última coluna (rótulos)
    mu = mean(X);
    sigma = std(X);
    ndata = (X - mu) ./ sigma;
    ndata = [ndata Y];  % Reconstrói a matriz de dados normalizada
end

function [ndata, min_val, max_val] = normalizationZeroOne(data)
     % Normaliza os dados para a faixa [0, 1] por coluna
    X = data(:, 1:end-1);  % Exclui a última coluna (rótulos)
    Y = data(:, end);  % Última coluna (rótulos)
    min_val = min(X);
    max_val = max(X);
    ndata = (X - min_val) ./ (max_val - min_val);
    ndata = [ndata Y];  % Reconstrói a matriz de dados normalizada
end

function [ndata, min_val, max_val] = normalizationOneOne(data)
    % Normaliza os dados para a faixa [-1, 1] por coluna
    X = data(:, 1:end-1);  % Exclui a última coluna (rótulos)
    Y = data(:, end);  % Última coluna (rótulos)
    min_val = min(X);
    max_val = max(X);
    % Normaliza para a faixa [-1, 1]
    ndata = 2 * (X - min_val) ./ (max_val - min_val) - 1;
    ndata = [ndata Y];  % Reconstrói a matriz de dados normalizada
end