function [character_list,character_candidates]=licence_plate(plate)
% A=croped_plates{1};
% figure,imshow(A);
% plate=croped_plates{1};
V=rgb2hsv(plate);
V=V(:,:,3);
%figure,imshow(V);
%%
thresh=adaptivethreshold(V,17,0.04); %0.0648
%figure,imshow(thresh);
% thresh=uint8((V<T).*255);
% figure,imshow(thresh);
%charSegments=segmentCharacters(croped_plates{3});
%%
plate=imresize(plate,[32 400]);
%figure,imshow(plate);
thresh=imresize(thresh,[32 400]);
%figure,imshow(thresh);

%%
%figure,imshow(plate);
character_candidates=logical(zeros(size(thresh)));
% hold on;
[labels,count]=bwlabel(thresh,8);
k=1;
for label=1:count
    labelmask=(logical(zeros(size(thresh))));
    labelmask(find(labels==label))=1;
    cnt = regionprops(labelmask);
    if(length(cnt)>0)
        boundary = cnt(1).BoundingBox;
        aspect_ratio=boundary(3)/boundary(4);
        solidity=cnt.Area/(boundary(3)*boundary(4));
        height_ratio=boundary(4)/size(plate,1);
 
        if (( aspect_ratio < 3) & (solidity > 0.15) & (height_ratio > 0.4 & height_ratio <0.95))
%             [B,L] = bwboundaries(labelmask,'noholes');
%             boundary=B{1};
%             plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
            character_candidates=character_candidates+labelmask;
            character_boundaries(k,:)=cnt(1).BoundingBox;
            k=k+1;
        end
        
    end
     
end

dens=length(find( character_candidates==1));

%%

if(dens>500)
[B,count] = bwlabel(character_candidates,8);

if(count>7)
    character_candidates=logical(zeros(size(thresh)));
    for i=1:size(character_boundaries,1)  
        dim(i)=character_boundaries(i,3)+character_boundaries(i,4);
    end
    for i=1:length(dim)  
        diffs(i)=sum(abs(dim-dim(i)));
    end
    [val,ind]=sort(diffs);
    for i=1:7
        bound=find(B==ind(i));
        character_candidates(bound)=1;
    end
end
%figure,imshow(plate);
%hold on
% [B,L] = bwboundaries(character_candidates,'noholes');
% 
% for i=1:length(B)
%     boundary=B{i};
%     plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
% end
%%
[B,count] = bwlabel(character_candidates,8);
for i=1:count
    
    [r,c]=find(B==i);
    mir=min(r);
    mar=max(r);
    mic=min(c);
    mac=max(c);
    character_list{i}=imcrop(character_candidates,[mic,mir,mac-mic,mar-mir]);
    %figure,imshow(character_list{i});
end

else
    
    character_list=[];
    character_candidates=[];
end
