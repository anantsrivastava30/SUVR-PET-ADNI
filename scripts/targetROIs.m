clear;
marsbar('on');

% Basing the root to this directory
xDoc = xmlread('./AAL.xml');

labels = xDoc.getElementsByTagName('label');

for k = 0:labels.getLength-1
	TargetRegion = labels.item(k);

	name = TargetRegion.getElementsByTagName('name'); 
	val = TargetRegion.getElementsByTagName('index');

	% extracting the name and value of a region.
	name = name.item(0).getFirstChild.getData;
	val = val.item(0).getFirstChild.getData;

	% {.} ensures space between boolean expression
	prefix = '../1_Target/T'; 

    % creating a function to be passed as a parameter saying : img == ####	 
	func = strcat({'img == '}, {char(val)});
	OutName = strcat(prefix, char(name), '.nii');
	sprintf('%s \n',OutName)

    % making the ROI 
	BuildRoi = maroi_image(struct('vol', spm_vol('wAAL.nii'), ...
    						'binarize',0,'func',func));
    % saving the rois in NifTi format
	D = maroi_matrix( BuildRoi );
	save_as_image(D, OutName);

end

