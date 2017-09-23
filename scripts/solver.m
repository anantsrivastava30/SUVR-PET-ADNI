clear;
clc;
%- parameter vector
g = load('./data/gamma.mat');

gamma = mean(g.gamma(:,1:4)');
gamma = [gamma mean(g.gamma(:,5:8)')];

%- data
X_T = load('./data/X_T.mat');

s_mu = mean(X_T.X_T(:,1:4)');
s_mu = [s_mu mean(X_T.X_T(:,5:8)')];

s_sigma = mean(X_T.X_T(:,9:12)');
s_sigma = [s_sigma mean(X_T.X_T(:,13:16)')];

%- label 
Y_T = load('./data/Y_T.mat');

Y = mean(Y_T.Y_T(:,1:4)');
Y = [Y mean(Y_T.Y_T(:,5:8)')];

%- randomize
i = randperm(102);

gamma = gamma(i);
s_mu = s_mu(i);
s_sigma = s_sigma(i);
Y = Y(i);

gamma_train = gamma(1:90)
s_mu_train = s_mu(1:90)
s_sigma_train = s_sigma(1:90)
Y_train = Y(1:90)

gamma_test = gamma(91:102)
s_mu_test = s_mu(91:102)
s_sigma_test = s_sigma(91:102)
Y_test = Y(91:102)

w = rand(1, 90);
b = rand(1, 1);
zai = rand(1, 90);
C = 50;
one = ones(1,90);
n=90
%t = 1e-5
tmp = w
cvx_begin 
%    variable t,w(1,n),b,zai(1,n)
%    minimize (t + C * sum(zai))
    variable w(1,n),b,zai(1,n)
    minimize (0.5*sum_square_abs(w,2) + C*sum(zai))
    subject to
%        norm(w,2) <= t
        Y_train * (s_mu_train' * w + b) >= one - zai + gamma_train * norm(sqrt(s_sigma_train') * w,2)
cvx_end

for i=1:12
    if w' * s_mu_test(i) + b > 0
        fprintf('Positive : %d\n', Y(i))      
    else
        fprintf('Negative : %d\n', Y(i))
    end

end



disp(find(tmp-w))
