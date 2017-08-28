%% This file calculates the dot product of the samples with 116 AAL masks in ...
%% /asriva20/analysis/1_Target/ 
%% Also this calculates the mean, SD of 116 VOI's and the difference between ...
%% Left and Right Brain regions in 54 VOI's of the brain 
%% output sample X 286
%%--------------------- AD and Normal-------------------------------------------

PETDir = '/home/asriva20/SrivastavaA/Data/3_AD_Normal/';
PETList = dir(PETDir);

MaskDir = '/home/asriva20/analysis/1_Target/';
MaskList = dir(MaskDir);

Data = zeros(length(PETList),286);

OutDir = '/home/asriva20/analysis/';

input_path = '/home/hohokam/Huntington/Data/ADNI2/PET/2_Normalized_new/';
output_path = '/home/hohokam/Huntington/Data/ADNI2/PET/3_Segmented_cerebral_new/';


for i = 1 : length(PETList)
    if ~PETList(i).isdir
        PETFile = strcat(PETDir,PETList(i).name);
        PET = spm_read_vols(spm_vol(PETFile));
        img_i = im2single(PET);
        img_i(isnan(img_i)) = 0;
        for j = 1 : length(MaskList)
            if ~MaskList(j).isdir
                maskFile = strcat(MaskDir,MaskList(j).name);
                temp = spm_read_vols(spm_vol(maskFile));
                img_t = im2single(temp);
                %% dot product between PET and mask
                img_new = img_t .* img_i;
                Data(i,j) = mean(mean(mean(img_new))); 
           end
        end
    break;
    end
end
