function feature=blockbinary_pixelsum(target_image)

% target_image=character_list{3};
target_image=imresize(target_image,[69 60]);
%figure(1),imshow(target_image);
[row,col]=size(target_image);
feature=[];
block_size=3;
for i=1:row/block_size
    for j=1:col/block_size
        
        roi=target_image((i-1)*block_size+1:block_size*i,(j-1)*block_size+1:block_size*j);
        total=length(find(roi==1))/(size(roi,1)*size(roi,2));
        feature=[feature,total];
    end
end

end