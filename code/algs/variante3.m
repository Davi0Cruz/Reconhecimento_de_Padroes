function [STATS TX_OK X m S posto]=variante3(data,Nr,Ptrain, lambda)

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
  Spool = zeros(size(Dtrn, 2) - 1);  % Initialize pooled covariance matrix
  for k=1:K,
    I=find(Dtrn(:,end)==k);  % Find rows with samples from k-th class
    X{k}=Dtrn(I, 1:end-1); %%%% se não funcionar colocar 1:end-1
    m{k}=mean(X{k})';   % Centroid of the k-th class
    S{k}=cov(X{k})*length(I); % Compute the covariance matrix of the k-th class
    %posto(k)=rank(S{k}); % Check invertibility of covariance matrix by its rank
    w{k} = length(I)/Ntrn;  % Weight of the k-th class
    Spool = Spool + S{k} * w{k};  % Accumulate weighted covariance
  end
  %iS = pinv(Spool);  % Inverse of the pooled covariance matrix
  for k=1:K,
    C{k} = ((1-lambda) * S{k}+Spool*lambda)/((1-lambda)*w{k}*Ntrn + lambda*Ntrn);  % Regularized covariance matrix
    qposto += rank(S{k})==p-1; % Check invertibility of covariance matrix by its rank
    %iC{k}=inv(C{k});    % Inverse covariance matrix of the k-th class
    [V D{k}] = eig(C{k}); % Eigen decomposition of the covariance matrix
    iC{k} = V * diag(1./diag(D{k})) * V';  % Inverse covariance matrix of the k-th class using eigen decomposition
  end

  % Testing phase
  correct=0;  % number correct classifications
  for i=1:Ntst,
    Xtst=Dtst(i,1:end-1)';   % test sample to be classified
    Label_Xtst=Dtst(i,end);   % Actual label of the test sample
    for k=1:K,
      v=(Xtst-m{k});

      dist(k)=v'*iC{k}*v + sum(log(diag(D{k}))) - 2*log(w{k});  % Mahalanobis distance to k-th class
      %pause
    end
    [dummy Pred_class]=min(dist);  % index of the minimum distance class
    
    if Pred_class == Label_Xtst,
        correct=correct+1;
    end
  end
  
  TX_OK(r)=100*correct/Ntst;   % Recognition rate of r-th run
end
posto = 100*qposto / Nr / K; % Average rank of the covariance matrix
STATS=[mean(TX_OK) min(TX_OK) max(TX_OK) median(TX_OK) std(TX_OK)];
