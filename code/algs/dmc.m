function [STATS TX_OK M]=dmc(data,Nr,Ptrain)

[N p]=size(data);  % Get dataset size (N)
Ntrn=round(Ptrain*N/100);  % Number of training samples
Ntst=N-Ntrn; % Number of testing samples
K=max(data(:,end)); % Get the number of classes

for r=1:Nr,  % Loop of independent runs
  rng(r);
  I=randperm(N);
  data=data(I,:); % Shuffle rows of the data matrix
  %data(:,1:end-1)=data(:,1:end-1)+0.5*randn(size(data(:,1:end-1)));
  % Separate into training and testing subsets
  Dtrn=data(1:Ntrn,:);  % Training data
  Dtst=data(Ntrn+1:N,:); % Testing data

  % Partition of training data into K subsets
  for k=1:K,
    I=find(Dtrn(:,end)==k);  % Find rows with samples from k-th class
    X{k}=Dtrn(I, 1:end-1); %%%% se não funcionar colocar 1:end-1
    M{k}=mean(X{k})';   % Centroid of the k-th class
  end

  % Testing phase
  correct=0;  % number correct classifications
  for i=1:Ntst,
    Xtst=Dtst(i,1:end-1)';   % test sample to be classified
    Label_Xtst=Dtst(i,end);   % Actual label of the test sample
    for k=1:K,
      dist(k)= norm(Xtst-M{k});  % Compute distance to each class centroid
      %pause
    end
    [dummy Pred_class]=min(dist);  % index of the minimum distance class
    Y_pred(i) = Pred_class;  % Store predicted class for evaluation
    Y_true(i) = Label_Xtst;  % Store true class for evaluation
    
    if Pred_class == Label_Xtst,
        correct=correct+1;
    end
  end
  if K == 2,
    VP = sum((Y_pred == 2) & (Y_true == 2));  % True Positives
    VN = sum((Y_pred == 1) & (Y_true == 1));  % True Negatives
    FP = sum((Y_pred == 2) & (Y_true == 1));  % False Positives
    FN = sum((Y_pred == 1) & (Y_true == 2));  % False Negatives
    
    acuracia(r) = (VP + VN) / Ntst;  % Accuracy
    taxa_falsos_positivos(r) = FP / (FP + VN);  % False Positive Rate
    taxa_falsos_negativos(r) = FN / (FN + VP);  % False Negative Rate
    sensibilidade(r) = VP / (VP + FN);  % Sensitivity
    precisao(r) = VP / (VP + FP);  % Precision
    disp([VP VN FP FN]);
    disp([acuracia(r) taxa_falsos_positivos(r) taxa_falsos_negativos(r) sensibilidade(r) precisao(r)]);
  end
  TX_OK(r)=100*correct/Ntst;   % Recognition rate of r-th run
end

STATS=[mean(TX_OK) min(TX_OK) max(TX_OK) median(TX_OK) std(TX_OK)];
if K == 2,
  STATS = [mean(acuracia) std(acuracia) mean(taxa_falsos_positivos) std(taxa_falsos_positivos) mean(taxa_falsos_negativos) std(taxa_falsos_negativos) mean(sensibilidade) std(sensibilidade) mean(precisao) std(precisao)];
end