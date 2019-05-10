clc;
clear all;
close all;
%%
Data_Path = [pwd,'\Train_Database\'];
folders = dir(Data_Path);
numFolders = numel(folders);
%%
img_number=1;
features_train=[];
k=1;
l=1;
for pp = 3:numFolders
    
    folderName=folders(pp).name; 
    
    imgFilepth = strcat(Data_Path, '\', folderName);  
    
    files = dir([imgFilepth '\' '*.png']);
    
    numFiles = numel(files);
    
for i= 1:numFiles                                  % here we need to place that one test image out of 100 images
    i
    
    fileName = files(i).name;
    
    imgFileName = strcat(imgFilepth, '\', fileName);
    
  
    
    imgData= imread(imgFileName);
    
    imgData=imgData>0;
    
    figure(1),imshow(imgData);
    
    feature=blockbinary_pixelsum(imgData);
    
    [L,count]=bwlabel(imgData,8);
    
    for j=1:count
        num=length(find(L==j));
        if(num<120)
             imgData(find(L==j))=0 ;
       end
        
    end
    
    stats = regionprops(imgData,'all');
    
    temp=[stats.Area,stats.MajorAxisLength,stats.MinorAxisLength,stats.Eccentricity,stats.ConvexArea,stats.EquivDiameter,stats.Solidity,stats.Extent,stats.Perimeter];
    
    if(uint8(folderName)<=57)
    
    features_train_digit(k,:)=[feature,temp];
    
    features_label_digit{k,1}=(folderName);
    
    k=k+1;
    
    else
        
    features_train_char(l,:)=[feature,temp];
    
    features_label_char{l,1}=(folderName);
    
    l=l+1;
    end
    
    
    
end

end
%%


% mdl_knn_digit = ClassificationKNN.fit(features_train_digit,features_label_digit,'NumNeighbors',1);
% mdl_knn_char = ClassificationKNN.fit(features_train_char,features_label_char,'NumNeighbors',1);
%save('Train_mdl.mat','mdl_knn_digit','mdl_knn_char','features_train_char','features_train_digit','features_label_digit','features_label_char');

mdl_svm_digit =fitcecoc(features_train_digit,features_label_digit);
mdl_svm_char=fitcecoc(features_train_char,features_label_char);
save('Train_mdl.mat','mdl_svm_digit','mdl_svm_char','features_train_char','features_train_digit','features_label_digit','features_label_char');


% mdl_nb = NaiveBayes.fit(features_train,feature_label);
% save('Train_mdl.mat','mdl_nb','features_train','features_label');

    