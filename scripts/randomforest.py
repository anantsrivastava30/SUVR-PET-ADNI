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
     0 if n[2:8] in  dic['Normal'] else \
    -1 for n in names]
Y = np.asarray(Y)

mat = sio.loadmat('X.mat')
X = mat['Data']
print np.shape(X)

forest = RandomTreesEmbedding(n_estimators=100, max_depth=3, random_state=0)
forest.fit(X)

count = 1

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
    

    pos = []
    neg = []
    label=[]
    {node_dict[leaf_nodes[i]].append(i) for i in range(len(leaf_nodes))}
       
    
    if len(node_dict.keys()) == 8:
        val = [ len(node_dict[n]) for n in node_dict.keys()]
        print node_dict.keys(), count, sum(val)
        count += 1 
    












