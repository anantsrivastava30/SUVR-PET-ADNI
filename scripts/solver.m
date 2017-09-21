
%- parameter vector
g = load('gamma.mat');

gamma = mean(g.gamma(:,1:4)');
gamma = [gamma mean(g.gamma(:,5:8)')];

%- data
X_T = load('X_T.mat');

s_mu = mean(X_T.X_T(:,1:4)');
s_mu = [s_mu mean(X_T.X_T(:,5:8)')];

s_sigma = mean(X_T.X_T(:,9:12)');
s_sigma = [s_sigma mean(X_T.X_T(:,13:16)')];

%- label 
Y_T = load('Y_T.mat');

Y = mean(Y_T.Y_T(:,1:4)');
Y = [Y mean(Y_T.Y_T(:,5:8)')];

%- randomize
i = randperm(102);
gamma = gamma(i);
s_mu = s_mu(i);
s_sigma = s_sigma(i);
Y = Y(i);




