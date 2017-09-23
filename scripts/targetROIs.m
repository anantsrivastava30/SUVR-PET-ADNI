clear;
marsbar('on');

% Basing the root to this directory
xDoc = xmlread('./data/AAL.xml');

labels = xDoc.getElementsByTagName('label');

for k = 0:labels.getLength-1
	TargetRegion = labels.item(k);

	name = TargetRegion.getElementsByTagName('name'); 
	val = TargetRegion.getElementsByTagName('index');

	name = name.item(0).getFirstChild.getData;
	val = val.item(0).getFirstChild.getData;

	% {.} ensures space between boolean expression
	prefix = '../1_Target/T'; 

	func = strcat({'img == '}, {char(val)});
	OutName = strcat(prefix, char(name), '.nii');
	sprintf('%s \n',OutName)

	BuildRoi = maroi_image(struct('vol', spm_vol('wAAL.nii'), ...
    						'binarize',0,'func',func));

	D = maroi_matrix( BuildRoi );
	save_as_image(D, OutName);

end

