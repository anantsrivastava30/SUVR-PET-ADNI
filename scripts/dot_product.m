fid = fopen('id_short.txt');
formatSpec = '%s';
id = textscan(fid, formatSpec);
id = id{1};

input_path = '/home/hohokam/Huntington/Data/ADNI2/PET/2_Normalized_new/';
output_path = '/home/hohokam/Huntington/Data/ADNI2/PET/3_Segmented_cerebral_new/';

for i = 1 : length(id)
    inFile = strcat(input_path,id{i});
    outFile = strcat(output_path,'s',id{i});
    image = load_untouch_nii(inFile);
    img_i = image.img;
    img_new = img_t.*img_i;
    image.img = img_new;
    save_untouch_nii(image,outFile);
end
