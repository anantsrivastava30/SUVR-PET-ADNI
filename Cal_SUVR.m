%Program to calculate the Standard uptake volume ratios
%Pradeep
%12/22/2015

clear all
clc

%Read PET inputs
controlpet=input('Enter control file name listing PET files: ','s');
filesPET=textread(controlpet,'%s');
filesPET=char(filesPET);

%Read Target regions
controltar=input('  default: /analysis/Clinical_Trails/Pfizer-A9951007-PIB/preprocess/SUVR/threshold/BAItargetROI.txt \n Enter control file name listing the target regions: ','s');
if isempty(controltar)
    controltar='/analysis/Clinical_Trails/Pfizer-A9951007-PIB/preprocess/SUVR/threshold/BAItargetROI.txt';
end
filestar=textread(controltar,'%s');
filestar=char(filestar);
%%
%%Read Reference image
controlref=input('  default: /analysis/Clinical_Trails/Pfizer-A9951007-PIB/preprocess/SUVR/threshold/BAIRefROI.txt \n Enter control file name listing the reference regions: ','s');
if isempty(controlref)
    controlref='/analysis/Clinical_Trails/Pfizer-A9951007-PIB/preprocess/SUVR/threshold/BAIRefROI.txt';
end
filesref=textread(controlref,'%s');
filesref=char(filesref);

%[SUVR,tar_vx,ref_vx] =targetGMsuvr(filesGM,thGM, filesPET, filestar, filesref);

for s=1:size(filesref,1);
 %for s=1;
      %Read Ref Region
     REF=deblank(filesref(s,:));
    imgREF=spm_read_vols(spm_vol(REF));
    
    
    SUVR=zeros(size(filesPET,1),size(filestar,1));
    tar_vx=zeros(size(SUVR));
    ref_vx=zeros(size(SUVR));
   
    for i=1:size(filesPET,1);
        
        
        for j=1:size(filestar,1);
            %Read Target Region
            TR=deblank(filestar(j,:));
            imgTR=spm_read_vols(spm_vol(TR));
                       
            %Read PET image
            PET=deblank(filesPET(i,:));
            imgPET=spm_read_vols(spm_vol(PET));          
            colheader{i,1}=PET;
            %Check and reslice file to match dimentions if needed
            if any(size(imgPET)~=size(imgREF));
                disp('image dimentions does not match. Reslice all images and masks')
            end;
            
                                 
            %Calculate Target Mean
             %the voxel intensities over the intersect
            tmp_TR=find(imgTR~=0 & ~isnan(imgTR) & ~isinf(imgTR));
            PET_TR=imgPET(tmp_TR);
            meanROIT=mean(PET_TR);
            
            
            %Calculate Reference Region Mean
            %the voxel intensities over the intersect
            tmp_REF=find(imgREF~=0 & ~isnan(imgREF) & ~isinf(imgREF));
            PET_REF =imgPET(tmp_REF);
            meanROIR=mean(PET_REF);           
            
 
            
            if ~isempty(meanROIR);
                 [pathstrtar,nametar,exttar] = fileparts(TR);
                 rowheader{1,j} = nametar;
                %calculate SUVR
                SUVR(i,j)=meanROIT/meanROIR;
                %tar_vx(i,j)=size(tmp_TR,1);
                %ref_vx(i,j)=size(tmp_REF,1);
            else
                disp('there is no voxel from this subject within  this ROI region');
                error('please check your data for this subject');
            end
        end
    end
    
    %%
    %write output
    [pathinp,namepet,extpet]=fileparts(controlpet);
    [pathstr,nameref,ext] = fileparts(REF);
    outputfilenameSUVR=[namepet nameref 'SUVR.txt'];
    %outputfilenametarvx=[namepet nameref 'tarvx.txt'];
    %outputfilenamerefvx=[namepet nameref 'refvx.txt'];
    SUVRT = cell2table(num2cell(SUVR),'VariableNames',rowheader,'RowNames',colheader);
    writetable(SUVRT,outputfilenameSUVR, 'WriteRowNames',true);
    %save(outputfilenameSUVR, 'SUVRH','-ascii');
    %save(outputfilenametarvx, 'tar_vx','-ascii');
    %save(outputfilenamerefvx, 'ref_vx','-ascii');
    disp(outputfilenameSUVR)
   % disp(outputfilenametarvx)
    %disp(outputfilenamerefvx)
    %clear SUVR
    %%
end
