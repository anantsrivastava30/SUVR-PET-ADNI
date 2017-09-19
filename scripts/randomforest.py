import numpy as np 
import scipy.io as sio
import pickle 
from sklearn.ensemble import RandomTreesEmbedding
from sklearn.model_selection import KFold
from os import listdir
from sklearn.metrics import classification_report
from collections import defaultdict
#d = defaultdict(list)
## labels for the data
dic = pickle.load(open('letterdict_normalized.pickle'));
mypath = '/home/asriva20/SrivastavaA/Data/3_AD_Normal/'
names = [name for name in sorted(listdir(mypath))]

Y = [1 if n[2:8] in dic['AD'] else \
     -1 if n[2:8] in  dic['Normal'] else \
    0 for n in names]
Y = np.asarray(Y)

mat = sio.loadmat('X.mat')
X = mat['Data']

gamma = np.zeros((51,8))
n_pos = len([n for n in Y if n == 1])
n_neg = len([n for n in Y if n == -1]) 
X_transformed = np.zeros((51,16))

print np.shape(X), n_pos, n_neg

# estimators fixed from 50 to 100 to 400, we force the tree to have atleat 2 elements at the 
# leaf as there is a numerical error when calculating the covarience of a single element! 
# there has to be some parameter or tree object which makes balanced grown trees.
forest = RandomTreesEmbedding(n_estimators=400, max_depth=3, random_state=0, min_samples_leaf=2)
forest.fit(X)

count = 0

# for each decision tree in forest we want to find the values in all
# the leaf nodes. after that we must have meu_m = {- 1,...,L, + 1,...,L}
# TODO! assumption : the odd numbered leaves are - and vice versa  
 
for tree in forest.estimators_:
    n_nodes = tree.tree_.node_count
    children_left = tree.tree_.children_left
    children_right = tree.tree_.children_right
    feature = tree.tree_.feature
    threshold = tree.tree_.threshold   
    
    leaf_nodes = tree.apply(X)
    node_dict = defaultdict(list)
    # print leaf_nodes 
    node_depth = np.zeros(shape=n_nodes)
    is_leaves = np.zeros(shape=n_nodes, dtype=bool)
    parent_id = {}
   
    # seed is root node and id is parent depth
    stack = [(0, -1)]
 
    while len(stack) > 0:
        node_id, parent_depth = stack.pop()
        node_depth[node_id] = parent_depth + 1
        if (children_left[node_id] != children_right[node_id]):
            stack.append((children_left[node_id], parent_depth + 1))
            parent_id[children_left[node_id]]=node_id
            stack.append((children_right[node_id], parent_depth + 1))
            parent_id[children_right[node_id]]=node_id
        else:
            is_leaves[node_id] = True
    
    # at this point all 100 trees are grown and we will filter the ones fully grwon
    # TODO: a method to make only 50 fully grown trees. 
    pos = 0
    neg = 4
    mu_m = np.zeros(shape=8)
    sigma_m = np.zeros(shape=8)
    label_m = np.zeros(shape=8)
    {node_dict[leaf_nodes[i]].append(i) for i in range(len(leaf_nodes))}
    
    # the purpose of node_dict is to store all the samples at the leafs so that 
    # the extraction of information is straightforward     
    if len(node_dict.keys()) == 8:
        # print node_dict.keys(), count  
        for leaf in node_dict.keys():
           feat = feature[parent_id[leaf]]
           mu = np.mean([X[n,feat] for n in node_dict[leaf]])
           sigma = np.cov([X[n,feat] for n in node_dict[leaf]]) 
           if leaf == children_left[parent_id[leaf]]:
               mu_m[pos] = mu
               sigma_m[pos] = sigma
               label_m[pos] = 1
               # print mu, pos
               gamma[count, pos] = float(len([n for n in node_dict[leaf] if Y[n] == 1]))/n_pos
               pos += 1
           else: 
               mu_m[neg] = mu
               sigma_m[neg] = sigma
               label_m[neg] = -1
               gamma[count, neg] = float(len([n for n in node_dict[leaf] if Y[n] == -1]))/n_neg
               # print mu, neg 
               neg += 1
        
        X_transformed[count, 0:8] = mu_m
        X_transformed[count, 8:16] = sigma_m

        count += 1 
print gamma

sio.savemat('X\'.mat', {'X_mu_sigma':X_transformed})       
sio.savemat('gamma.mat', {'gamma':gamma})       
# processing the transformaed data








