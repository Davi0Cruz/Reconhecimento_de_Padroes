function [STATS]=variante1i(Xi, Xe, Nr,Ptrain, lambda)
% 
[Pi Ni]=size(Xi);
[Pe Ne]=size(Xe);

Ntrni=round(Ptrain*Ni/100);  % Number of training samples
Ntrne=round(Ptrain*Ne/100);  % Number of training samples
Ntsti=Ni-Ntrni; % Number of testing samples
Ntste=Ne-Ntrne; % Number of testing samples
for r=1:Nr,  % Loop of independent runs
  rng(r);
  Ii=randperm(Ni);
  Ie=randperm(Ne);
  Xi=Xi(:, Ii); % Shuffle rows of the data matrix
  Xe=Xe(:, Ie); % Shuffle rows of the data matrix
  X = Xi(:, 1:Ntrni);  % Training data

  % Partition of training data into K subsets
  m = mean(X')';   % Centroid of the training data
  S = cov(X'); % Compute the covariance matrix of the training data
  S+=eye(size(S))*lambda; % Regularization to avoid singularity
  [V D] = eig(S); % Eigen decomposition of the covariance matrix
  iS = V*diag(1./diag(D))*V'; % Inverse covariance matrix
  for i=1:Ntrni,
    v=(Xi(:, i) - m);
    disti(i) = v'*iS*v + sum(log(diag(D)));  % Mahalanobis distance
  end
  for i=1:Ntrne,
    v=(Xe(:, i) - m);
    diste(i) = v'*iS*v + sum(log(diag(D)));  % Mahalanobis distance
  end
  limiar = (max(disti) + min(diste)) / 2;
  Y_pred = [];
  Y_true = [];
  for i=1:Ntsti,
    v=(Xi(:, Ntrni+i) - m);
    disti(i) = v'*iS*v + sum(log(diag(D)));  % Mahalanobis distance
    if disti(i) < limiar,
      Y_pred(end+1) = 0;  % Class 1 (internos)
    else
      Y_pred(end+1) = 1;  % Class 2 (externos)
    end
    Y_true(end+1) = 0;  % Class 1 (internos)
  end
  for i=1:Ntste,
    v=(Xe(:, Ntrne+i) - m);
    diste(i) = v'*iS*v + sum(log(diag(D)));  % Mahalanobis distance
    if diste(i) < limiar,
      Y_pred(end+1) = 0;  % Class 1 (internos)
    else
      Y_pred(end+1) = 1;  % Class 2 (externos)
    end
    Y_true(end+1) = 1;  % Class 2 (externos)
  end
  VP = sum((Y_pred == 1) & (Y_true == 1));  % True Positives
  VN = sum((Y_pred == 0) & (Y_true == 0));  % True Negatives
  FP = sum((Y_pred == 1) & (Y_true == 0));  % False Positives
  FN = sum((Y_pred == 0) & (Y_true == 1));  % False Negatives
  acuracia(r) = (VP + VN) / (VP + VN + FP + FN);  % Accuracy
  taxa_falsos_positivos(r) = FP / (FP + VN);  % False Positive Rate
  taxa_falsos_negativos(r) = FN / (FN + VP);  % False Negative Rate
  sensibilidade(r) = VP / (VP + FN);  % Sensitivity
  precisao(r) = VP / (VP + FP);  % Precision
end
STATS = [mean(acuracia) std(acuracia) mean(taxa_falsos_positivos) std(taxa_falsos_positivos) mean(taxa_falsos_negativos) std(taxa_falsos_negativos) mean(sensibilidade) std(sensibilidade) mean(precisao) std(precisao)];
