function [STATS TX_OK]=onekk(data,Nr,Ptrain)

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


  % Testing phase
  correct=0;  % number correct classifications
  for i=1:Ntst,
    Xtst=Dtst(i,1:end-1)';   % test sample to be classified
    Label_Xtst=Dtst(i,end);   % Actual label of the test sample
    for k=1:Ntrn,
      dist(k)= norm(Xtst-Dtrn(k,1:end-1)');  % Compute distance to each training sample
      %pause
    end
    [dummy Pred_class]=min(dist);  % index of the minimum distance class

    if Dtrn(Pred_class,end) == Label_Xtst,
        correct=correct+1;
    end
  end
  
  TX_OK(r)=100*correct/Ntst;   % Recognition rate of r-th run
end

STATS=[mean(TX_OK) min(TX_OK) max(TX_OK) median(TX_OK) std(TX_OK)];
