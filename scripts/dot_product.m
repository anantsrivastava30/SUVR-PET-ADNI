%% This file calculates the dot product of the samples with 116 AAL masks in ...
%% /asriva20/analysis/1_Target/ 
%% Also this calculates the sum, SD of 116 VOI's and the difference between ...
%% Left and Right Brain regions in 54 VOI's of the brain 
%% output sample X 286
%%--------------------- AD and Normal-------------------------------------------

PETDir = '/home/asriva20/SrivastavaA/Data/3_AD_Normal/';
PETList = dir(PETDir);
PETList = PETList(3:length(PETList));

MaskDir = '/home/asriva20/analysis/1_Target/';
MaskList = dir(MaskDir);
MaskList = MaskList(3:length(MaskList));

Data = zeros(length(PETList),286);

OutDir = '/home/asriva20/analysis/';

    [n, name] = textread('aalAnnotation2Intensity.txt','%d %s');

for i = 1 : length(PETList)
    if PETList(i).isdir
        continue
    end
    PETFile = strcat(PETDir,PETList(i).name);
    PET = spm_read_vols(spm_vol(PETFile));
    img_i = im2single(PET);
    img_i(isnan(img_i)) = 0;
    for j = 1 : length(MaskList)
        if MaskList(j).isdir
            continue
        end
        maskFile = strcat(MaskDir,MaskList(j).name);
            temp = spm_read_vols(spm_vol(maskFile));
        img_t = im2single(temp);
        %% dot product between PET and mask
        img_new = img_t .* img_i;
        Data(i,j) = sum(sum(sum(img_new)))/length(find(temp));
    %break
    end
    for j = length(MaskList) + 1: 2 * length(MaskList)
        if MaskList(j-116).isdir
            continue
        end
        maskFile = strcat(MaskDir,MaskList(j-116).name);
        temp = spm_read_vols(spm_vol(maskFile));
        img_t = im2single(temp);
        %% dot product between PET and mask
        img_new = img_t .* img_i;
        [r,c,v] = find(img_new);
        if length(find(img_new)) ~= length(find(img_t))
            disp(length(find(img_new)) - length(find(img_t)))
        end
        Data(i,j) = std(v);
    %break
    end
    off = length(MaskList);
    for j = 2 * off + 1: 2 * off  + 54
        Data(i,j) = Data(i, 2 * (j - 2 * off) - 1) -  Data(i, 2 * (j - 2 * off));
    end
disp(i)
%break
end

save('./data/X.mat','Data')
%dlmwrite('FM.txt',Data,' ');
%image.img = img_new;
%save_untouch_nii(image,outFile);
