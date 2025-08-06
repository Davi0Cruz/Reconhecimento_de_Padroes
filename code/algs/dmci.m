function [STATS]=dmci(Xi, Xe,Nr,Ptrain)

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
  m = mean(X')';   % Centroid of the training datatrix
  for i=1:Ntrni,
    v=(Xi(:, i) - m);
    disti(i) = norm(v);  % Euclidean distance
  end
  for i=1:Ntrne,
    v=(Xe(:, i) - m);
    diste(i) = norm(v);  % Euclidean distance
  end
  limiar = (max(disti) + min(diste)) / 2;

  % Testing phase
  Y_pred = [];
  Y_true = [];
  for i=1:Ntsti,
    v=(Xi(:, Ntrni+i) - m);
    disti(i) = norm(v);  % Euclidean distance
    if disti(i) < limiar,
      Y_pred(end+1) = 0;  % Class 1 (internos)
    else
      Y_pred(end+1) = 1;  % Class 2 (externos)
    end
    Y_true(end+1) = 0;  % Class 1 (internos)
  end
  for i=1:Ntste,
    v=(Xe(:, Ntrne+i) - m);
    diste(i) = norm(v);  % Euclidean distance
    if diste(i) < limiar,
      Y_pred(end+1) = 0;  % Class 1 (internos)
    else
      Y_pred(end+1) = 1;  % Class 2 (externos)
    end
    Y_true(end+1) = 1;  % Class 2 (externos
  end

  VP = sum((Y_pred == 1) & (Y_true == 1));  % True Positives
  VN = sum((Y_pred == 0) & (Y_true == 0));  % True Negatives
  FP = sum((Y_pred == 1) & (Y_true == 0));  % False Positives
  FN = sum((Y_pred == 0) & (Y_true == 1));  % False Negatives

    acuracia(r) = (VP + VN) / (VP + VN + FP + FN);  % Accuracy
    taxa_falsos_positivos(r) = FP / (FP + VN);  % False Positive Rate
    taxa_falsos_negativos(r) = FN / (FN + VP);  % False Negative Rate
    sensibilidade(r) = VP / (VP + FN);  % Sensitivity
    if (VP + FP) == 0,
      precisao(r) = 0;  % Avoid division by zero
    else
      precisao(r) = VP / (VP + FP);  % Precision
    end
end


  STATS = [mean(acuracia) std(acuracia) mean(taxa_falsos_positivos) std(taxa_falsos_positivos) mean(taxa_falsos_negativos) std(taxa_falsos_negativos) mean(sensibilidade) std(sensibilidade) mean(precisao) std(precisao)];
