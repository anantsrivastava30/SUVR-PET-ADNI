@asriva20
<!-- Incomplete Random Forest with AAL parcellation features   -->
----------------------------------------------------------------------

Imaging Modality - PET (ADNI 2)

s1: Normal Target, Reference and Source Images.

s2: Get all the target AAL regions.

s3: Inculded 116 AAL parcellations.

s4: Dot product of each sample with parcellation masks in s3.

s5: Change of AAL template now reduced to integer values.

s6: 286 Features complete mean, std and difference b/w 54 pairs

s7: preliminary analysis

s8: features transformed by incomplete random forest. (http://www.sciencedirect.com/science/article/pii/S0895611117300010#!) 

----------------------------------------------------------------------

s9: exported all variables to play around with CVX matlab.
    - cvx contains matlab package CVX for cone or convex optimization problems
    - to install do 
    	- wget http://web.cvxr.com/cvx/cvx-a64.tar.gz
    	- tar -xvf cvx-a64.tar.gz
    	- module load matlab/2016a
    	- matlab -nodesktop

    	IN MATLAB
    	>> cd cvx 
    	>> cvx_setup

----------------------------------------------------------------------

<!-- Optimal second order convex/conex classification  -->