marsbar('on');
% Basing the root to this directory

for k = 1:116
    val = k;
	% {.} ensures space between boolean expression
	prefix = '../1_Target/'; 

    % creating a function to be passed as a parameter saying : img == ####	 
	func = strcat({'img == '}, {num2str(val)});
	OutName = strcat(prefix, num2str(k), '.nii');
	sprintf('%s \n',OutName)

    % making the ROI 
	BuildRoi = maroi_image(struct('vol', spm_vol('test.nii'), ...
    						'binarize',0,'func',func));
    % saving the rois in NifTi format
	D = maroi_matrix( BuildRoi );
	save_as_image(D, OutName);
end

marsbar('Quit')

