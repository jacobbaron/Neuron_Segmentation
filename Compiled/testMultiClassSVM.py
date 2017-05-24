import numpy as np
from sklearn import svm
import random
import pdb
import random
import tables
import scipy.io as sio

if __name__ == '__main__':

	# upload the ORN response data matrix
	matfile=tables.open_file('training_data.mat')
	rawData=matfile.root.signal[:]
	rawData=np.transpose(rawData)
	cID=matfile.root.labels[:]
	cID=cID[0]
	#upload class identity - array of int's indicate label

	classNum = np.amax(cID) #number of classes


	
	score_matrix=np.zeros((classNum,classNum))
	#pdb.set_trace()
	#Test the classifier - select 80% of data for training, 20% for testing
	trial_N = 2000

	for i in range(0, trial_N):
	    # randomize the sequence
	    sel_t_num = cID.shape[0]
	    population = range(sel_t_num)
	    rseq = random.sample(population, sel_t_num)

	    rawData_s_r = rawData[rseq, :]
	    cID_s_r = cID[rseq]

	    #pick 80% for training, 20% for testing
	    seperate = int(sel_t_num*0.8)

	    train_data = rawData_s_r[range(seperate)]
	    train_class = cID_s_r[range(seperate)]

	    test_data = rawData_s_r[range(seperate, sel_t_num)]
	    test_class = cID_s_r[range(seperate, sel_t_num)]
	    
	    # SVM fit classifier
	    X =  train_data
	    Y =  np.ravel(train_class)
	    
	    clf = svm.SVC()
	    clf.decision_function_shape='ovo'
	    clf.kernel='linear'
	    clf.fit(X, Y) 
	    
	    # make prediction
	    predict_class = clf.predict(test_data)
	    #pdb.set_trace()
	    for i in range(0, predict_class.shape[0]):
	        row = predict_class[i]-1
	        col = test_class[i]-1
	        score_matrix[row, col] = score_matrix[row, col] + 1
	#pdb.set_trace()	
	#now train classifier on entire data set
	clf.fit(rawData,cID)
	coefs=clf.coef_
	dual_coef=clf.dual_coef_
	intercept=clf.intercept_
  	sio.savemat('score_matrix.mat',{'score_matrix':score_matrix,'coefs':coefs,'dual_coef':dual_coef,'intercept':intercept})

  	import pickle
  	from sklearn.externals import joblib
  	joblib.dump(clf,'.\classifier\classifier.pkl')
