import numpy as np 
import scipy.io as sio
import pickle 
from sklearn.ensemble import RandomForestClassifier
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

clf = RandomForestClassifier(max_depth=10, random_state=0)
clf.fit(X[:310,232:286],Y[:310])
z = clf.predict(X[310:332,232:286])

print classification_report(Y[310:332], z)

