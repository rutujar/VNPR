function bw=adaptivethreshold(IM,ws,C)

% IM=im1;
% ws=12;
% C=0.009;
%ADAPTIVETHRESHOLD An adaptive thresholding algorithm that seperates the
%foreground from the background with nonuniform illumination.
%  bw=adaptivethreshold(IM,ws,C) outputs a binary image bw with the local 
%   threshold mean-C or median-C to the image IM.
%  ws is the local window size.

%


if (nargin<2)
    error('You must provide the image IM, the window size ws, and C.');

end

IM=mat2gray(IM);%Convert matrix to grayscale image

%mIM=imfilter(IM,fspecial('gaussian',ws),'replicate');
% figure,imshow(IM);
mIM=medfilt2(IM,[ws ws]);

sIM=mIM-IM-C;
sIM=double(sIM);

%figure,imshow(uint8(sIM));
bw=im2bw(sIM,0);
%bw=imcomplement(bw);