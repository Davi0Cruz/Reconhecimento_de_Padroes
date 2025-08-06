function [STATS TX_OK X m S posto]=variante1(data,Nr,Ptrain, lambda)

[N p]=size(data);  % Get dataset size (N)
Ntrn=round(Ptrain*N/100);  % Number of training samples
Ntst=N-Ntrn; % Number of testing samples
K=max(data(:,end)); % Get the number of classes
qposto = 0.0;
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
    m{k}=mean(X{k})';   % Centroid of the k-th class
    S{k}=cov(X{k}); % Compute the covariance matrix of the k-th class
    S{k}+=eye(size(S{k}))*lambda; % Regularization to avoid singularity
    qposto += rank(S{k})==p-1; % Check invertibility of covariance matrix by its rank
    % iS{k}=pinv(S{k});    % Inverse covariance matrix of the k-th class
    % iS{k}=inv(S{k});    % Inverse covariance matrix of the k-th class
    [V D{k}] = eig(S{k}); % Eigen decomposition of the covariance matrix
    iS{k} = V*diag(1./diag(D{k}))*V';
    w{k} = length(I)/Ntrn;  % Weight of the k-th class
  end

  % Testing phase
  correct=0;  % number correct classifications
  for i=1:Ntst,
    Xtst=Dtst(i,1:end-1)';   % test sample to be classified
    Label_Xtst=Dtst(i,end);   % Actual label of the test sample
    for k=1:K,
      v=(Xtst -m{k});
      dist(k)=v'*iS{k}*v + sum(log(diag(D{k}))) - 2*log(w{k});  % Mahalanobis distance to k-th class
      %pause
    end
    [dummy Pred_class]=min(dist);  % index of the minimum distance class
    Y_pred(i) = Pred_class;  % Store predicted class for evaluation
    Y_true(i) = Label_Xtst;  % Store true class for evaluation
    if Pred_class == Label_Xtst,
        correct=correct+1;
    end
  end
  % label 1 internos, label 2 externos
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
  end
  TX_OK(r)=100*correct/Ntst;   % Recognition rate of r-th run
end
posto = 100*qposto / Nr / K; % Average rank of the covariance matrix
STATS=[mean(TX_OK) min(TX_OK) max(TX_OK) median(TX_OK) std(TX_OK)];
if K == 2,
  STATS = [mean(acuracia) std(acuracia) mean(taxa_falsos_positivos) std(taxa_falsos_positivos) mean(taxa_falsos_negativos) std(taxa_falsos_negativos) mean(sensibilidade) std(sensibilidade) mean(precisao) std(precisao)];
end