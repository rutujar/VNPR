clc;
clear all;
close all;
%%
warning off;
[file ,path]=uigetfile('.jpg','Select the input Image');
imgData= imread([path file]);
figure(1),imshow(imgData);  
title('Input Image');
imgData_color=imgData;
%%
if(size(imgData,3)==3)
    imgData=rgb2gray(imgData);
end
%%
se1 = strel('rectangle',[5 13]);
img_close = imclose(imgData,se1);
img_blackhat=abs(img_close-imgData);
figure(2),imshow(img_blackhat);

%%
se2 = strel('rectangle',[3 3]);
img_light = imclose(imgData,se2);
img_light = im2bw(img_light,0.2);
figure(3),imshow(img_light);
%%
filt_para=fspecial('sobel');
gradx=filter2(filt_para',img_blackhat);
gradx=abs(gradx);
minval=min(min(gradx));
maxval=max(max(gradx));
gradx=255*((gradx-minval)/(maxval-minval));
figure(4),imshow(uint8(gradx));
gradx=uint8(gradx);
%%
filt_para=fspecial('gaussian',[5 5]);
gradx=filter2(filt_para,gradx);
img_gradx = uint8(imclose(gradx,se1));
level = graythresh(img_gradx);
thresh = im2bw(img_gradx,level);
figure(5),imshow((thresh));
%%
erode_thresh = bwmorph(thresh,'erode');
erode_thresh = bwmorph(erode_thresh,'erode');
dilate_thresh = bwmorph(erode_thresh,'dilate');
dilate_thresh = bwmorph(dilate_thresh,'dilate');
thresh=bitand(img_light,dilate_thresh);
dilate_thresh = bwmorph(thresh,'dilate');
dilate_thresh = bwmorph(dilate_thresh,'dilate');
thresh = bwmorph(dilate_thresh,'erode');
figure(6),imshow(thresh);

%%
B = regionprops(thresh);

i=1;
for k = 1:length(B)
    boundary = B(k).BoundingBox;
    aspect_ratio=boundary(3)/boundary(4);
    if((aspect_ratio > 3 & aspect_ratio < 6) & (boundary(4) > 15 & boundary(3) > 50))
       regions(i,:)=boundary;
       croped_plates{i}=imcrop(imgData_color,boundary);
       i=i+1;
    end
    
end

%%
figure(7),imshow(imgData_color);
hold on;
p=1;
load 'Train_mdl.mat';
for j=1:size(croped_plates,2)
plate=croped_plates{j};
[character_list,character_candidates]=licence_plate(plate);
%%
figure,imshow(character_candidates);

if(~isempty(character_list))
hold on;

boundary=regions(j,:);
figure(7),rectangle('Position',boundary,'EdgeColor','m','LineWidth',2);
k=1;
for i=1:length(character_list)
    temp=character_list{i};
     imwrite(temp,strcat(num2str(p),'.png'));
     p=p+1;
     
     stats = regionprops(temp,'all');
    
    stat_results=[stats.Area,stats.MajorAxisLength,stats.MinorAxisLength,stats.Eccentricity,stats.ConvexArea,stats.EquivDiameter,stats.Solidity,stats.Extent,stats.Perimeter];
    
    feature=blockbinary_pixelsum(temp);
    
    feature=[feature,stat_results];
    
    if(i<=3)
    [predict_label] = predict(mdl_svm_char,feature);
    else
    [predict_label] = predict(mdl_svm_digit,feature);   
    end
    if(i==4)
    recognized_chars(k)='-';
    k=k+1;
    end
    %predict_label
    recognized_chars(k)=char(predict_label);
    k=k+1;
end

figure(7),text(boundary(1),boundary(2)-40,recognized_chars,'fontsize',10,'FontWeight','bold','color','w','backgroundcolor','b','edgecolor','g')

end

end