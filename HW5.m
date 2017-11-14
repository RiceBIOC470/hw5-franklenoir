%HW5
%GB comments:
1a 100
1b 100
1c 100
1d 100
2yeast: 100
2worm: 95 resulting image could be better. While there are some speckled masks within the image, the major concern is the fact that there is a mask framing the image that will be treated equally to the worm masks. Bwareaopen could get ride of a lot of your random masks in the image. 
2bacteria: 85 Segmentation is…not good. In this scenario perhaps reattempting the segmentation in illastik could have been helpful or using watershed function in matlab. 
2phase: 100 this is really good. 
Overall: 98

% Note. You can use the code readIlastikFile.m provided in the repository to read the output from
% ilastik into MATLAB.

%% Problem 1. Starting with Ilastik

%Walter Frank Lenoir

% Part 1. Use Ilastik to perform a segmentation of the image stemcells.tif
% in this folder. Be conservative about what you call background - i.e.
% don't mark something as background unless you are sure it is background.
% Output your mask into your repository. What is the main problem with your segmentation?  

data = h5read('seg1_1.h5','/exported_data');
data = squeeze(data);
fig = figure;
imshow(data, []);
saveas(fig,'mask1_1.tif'); %output mask

%Many of the cells are getting blocked together in the mask. Half the mask looks
%diluted, whereas the other half has many connected cells. 

% Part 2. Read you segmentation mask from Part 1 into MATLAB and use
% whatever methods you can to try to improve it. 

mask = data;
mask = imopen(mask,strel('disk',10));
mask = imerode(mask,strel('disk',5));
mask=imfilter(mask,fspecial('gaussian',4,2));
imshow(mask, []);

%Watershed results looked a little sloppy

% Part 3. Redo part 1 but now be more aggresive in defining the background.
% Try your best to use ilastik to separate cells that are touching. Output
% the resulting mask into the repository. What is the problem now?

data = h5read('1_3.h5','/exported_data');
data = squeeze(data);
fig = figure;
imshow(data, []);
saveas(fig,'mask1_3.tif'); %output mask

%The cells look very eroded and incomplete. 

% Part 4. Read your mask from Part 3 into MATLAB and try to improve
% it as best you can.

mask = data;
mask = imopen(mask,strel('disk',1));
mask = edge(mask,'canny',[]);
mask = imdilate(mask,strel('disk',3));
mask = imfill(mask,'holes');
mask = imerode(mask,strel('disk',1));
imshow(mask,[]);


%% Problem 2. Segmentation problems.

%Walter Frank Lenoir

% The folder segmentationData has 4 very different images. Use
% whatever tools you like to try to segement the objects the best you can. Put your code and
% output masks in the repository. If you use Ilastik as an intermediate
% step put the output from ilastik in your repository as well as an .h5
% file. Put code here that will allow for viewing of each image together
% with your final segmentation. 

%Yeast
clear all;
yeast_img = imread('./segmentationData/yeast.tif');
yeast_mask1 = double(yeast_img > 45);

compliment = ones(size(yeast_mask1));
yeast_mask2 = (compliment - yeast_mask1);

yeast_mask1 = imfill(yeast_mask1,'holes');
compliment = ones(size(yeast_mask1));
yeast_mask1 = (compliment - yeast_mask1);

yeast_mask=imsubtract(yeast_mask1,yeast_mask2);

compliment = ones(size(yeast_mask));
yeast_mask = (compliment - yeast_mask);
yeast_mask = imfill(yeast_mask,'holes');

yeast_mask = imerode(yeast_mask,strel('disk',4));
yeast_mask = imdilate(yeast_mask,strel('disk',3));

fig = figure;
imshowpair(yeast_mask,yeast_img);
saveas(fig,'yeast1.tif');
hold off;

fig = figure;
subplot(1,2,1);
imshow(yeast_img);
title('Yeast');
subplot(1,2,2);
imshow(yeast_mask,[]);
title('Yeast Mask');
saveas(fig,'yeast2.tif');
hold off;

%Worms
clear all;

worms_img = imread('./segmentationData/worms.tif');

worms = edge(worms_img,'canny',[]);
worms_plate = imfill(worms,'holes');

compliment = ones(size(worms_plate));

worms_plate = (worms_plate - compliment);

worms_mask=imsubtract(worms_plate,double(worms));

compliment = ones(size(worms_plate));
worms_mask = (compliment - worms_mask);
worms_mask = imdilate(worms_mask,strel('disk',1));

worms_mask = worms_mask(90:500,145:560); % getting rough plate dimensions

worms_mask = imfill(worms_mask,'holes');
worms_mask = imerode(worms_mask,strel('disk',4));
worms_mask = imdilate(worms_mask,strel('disk',2));

worms_img = worms_img(90:500,145:560);

fig = figure;
imshowpair(worms_mask,worms_img);
saveas(fig,'worms1.tif');
hold off;

fig = figure;
subplot(1,2,1);
imshow(worms_img, []);
title('Worms');
subplot(1,2,2);
imshow(worms_mask,[]);
title('Worms Mask');
saveas(fig,'worms2.tif');
hold off;

%Bacteria
clear all;

bacteria_img = imread('./segmentationData/bacteria.tif');
data = h5read('bacteria.h5','/exported_data');
data = squeeze(data);

data = imopen(data,strel('disk',1));
data = imdilate(data,strel('disk',2));
data = edge(data,'canny',[]);
data = imdilate(data,strel('disk',2));
data = imfill(data,'holes');

imshow(data, []);

data = imrotate( data , -90 );
data = flipdim(data ,2);
fig = figure;
imshowpair(data,bacteria_img);
saveas(fig,'bacteria1.tif');
hold off;

fig = figure;
subplot(1,2,1);
imshow(bacteria_img, []);
title('Bacteria');
subplot(1,2,2);
imshow(data,[]);
title('Bacteria Mask');
saveas(fig,'bacteria2.tif');
hold off;


%cell phase contrast
clear all;
cellp_img = imread('./segmentationData/cellPhaseContrast.png');

mask = cellp_img > 150;

mask = imdilate(mask,strel('disk',4));

D = bwdist(~mask);
mask = watershed(D);

mask = mask > 5;

mask = imerode(mask,strel('disk',3));
mask = imdilate(mask,strel('disk',2));

imshow(mask,[]);
fig = figure;
imshowpair(mask,cellp_img);
saveas(fig,'cellphase1.tif');
hold off;

fig = figure;
subplot(1,2,1);
imshow(cellp_img, []);
title('Cell Phase');
subplot(1,2,2);
imshow(mask,[]);
title('Cell Phase Mask');
saveas(fig,'cellphase2.tif');
hold off;
