import numpy as np
from sklearn import svm
import random
import pdb
import random
import tables
import scipy.io as sio

if __name__ == '__main__':

	# upload the ORN response data matrix
	matfile=tables.open_file('training_test_data.mat')
	
	rawData=matfile.root.train_signal[:]
	rawData=np.transpose(rawData)

	test_data=matfile.root.test_data[:]
	test_data=np.transpose(test_data)
	
	labels=matfile.root.labels[:]
	labels=labels[0]
	import os
	folder=os.path.dirname(os.path.abspath(__file__))
	

	#folder=matfile.root.folder[:]
	#pdb.set_trace()
	#upload class identity - array of int's indicate label

	classNum = np.amax(labels) #number of classes
	#set up classifier
	clf = svm.SVC()
	clf.decision_function_shape='ovo'
	clf.kernel='linear'
	#train classifier
	clf.fit(rawData,labels)
	#query classifier
	predict_class=clf.predict(test_data)
	
	#output parameters of classifier
	coefs=clf.coef_
	dual_coef=clf.dual_coef_
	intercept=clf.intercept_
  	
  	#save to matfile
  	sio.savemat('\predictions.mat',{'predict_class':predict_class,'coefs':coefs,'dual_coef':dual_coef,'intercept':intercept})

  	#save classifier to file
  	# import pickle
  	# from sklearn.externals import joblib
  	# joblib.dump(clf,folder + '\classifier\classifier.pkl')