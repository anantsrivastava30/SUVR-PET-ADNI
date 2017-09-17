import numpy as np 
import scipy.io as sio
import pickle 
from sklearn.ensemble import RandomTreesEmbedding
from sklearn.model_selection import KFold
from os import listdir
from sklearn.metrics import classification_report

## labels for the data
dic = pickle.load(open('letterdict_normalized.pickle'));
mypath = '/home/asriva20/SrivastavaA/Data/3_AD_Normal/'
names = [name for name in sorted(listdir(mypath))]
Y = [1 if n[2:8] in dic['AD'] else \
     0 if n[2:8] in  dic['Normal'] else \
    -1 for n in names]
Y = np.asarray(Y)

mat = sio.loadmat('X.mat')
X = mat['Data']
print np.shape(X)

forest = RandomTreesEmbedding(n_estimators=50, max_depth=3)
forest.fit(X)
print(forest.apply(X))
sum=0
for tree in forest.estimators_:
    n_nodes = tree.tree_.node_count
    children_left = tree.tree_.children_left
    children_right = tree.tree_.children_right
    feature = tree.tree_.feature
    threshold = tree.tree_.threshold   
 
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
    
    print("The binary tree structure has %s nodes and has  the following tree structure:"% n_nodes)

    pos = []
    neg = []
    label=[]
    for i in range(n_nodes):
        if is_leaves[i]:
            if i == children_left[parent_id[i]]:
                label.append(1)
#                pos.append(X[feature[i])
                print("left child")
            else:
                label.append(-1)
                neg.append(feature[i]) 
                print("right child")
            print("%snode=%s leaf node." % (node_depth[i] * "\n", i))
        else:
            print("%snode=%s test node: go to node %s if X[:, %s] <= %s else to node %s."
              % (node_depth[i] * "\n",
                 i,
                 children_left[i],
                 feature[i],
                 threshold[i],
                 children_right[i],
                 ))
    np_pos = np.array(pos)
    np_neg = np.array(neg)
    pos_mean = np.mean(np_pos)
    neg_mean = np.mean(np_neg)
    print(pos_mean,neg_mean)
    print(np.cov(np_pos).shape)
    

    #print()
    break

