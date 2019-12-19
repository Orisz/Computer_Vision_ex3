%% main script of the optic flow question
% Ori Sztyglic & Yossi Magriso
%% clean up:
clc;close all;clear all;
%% read the .Gif file and slice it into images then convert to double:

%path
fullFileName = 'seq.gif';

%read the gif
[gifImage, ~] = imread(fullFileName, 'Frames', 'all');

%pre process
gifImage = squeeze(gifImage);%lose the chanles dim since its gray lvl gif
[imSize(1), imSize(2), frames] = size(gifImage);
gifImageDouble = zeros(size(gifImage));
for i = 1:frames
    gifImageDouble(:,:,i) = im2double(gifImage(:,:,i));
end

%sanity check display image
im = gifImageDouble(:,:,1);
hfig1 = figure(1);
imshow(im,[]);
title('sanity check - first image from sliced vid');
%% set user input
% N: each patch will be of size NxN
% t: the threshold for the eign values. we will estimate vector [u v] for 
%  the currnet patch iff the smallest eign value of A'A is bigger then 't'.
N = 16;
t = 1;
numOfPatchesInRow = floor(imSize(1) / N);
numOfPatches = (numOfPatchesInRow)^2;
[a , b] = meshgrid(1:N:imSize(1), 1:N:imSize(1));
%% section 1 - see fnction implemintation CalcPatchOpticFlow bellow
% section 2 choose 3 random frames and draw the optic flow for them
framesToDraw = [5, 10, 30, 40];
hfig2 = figure(2);
DrawOpticFlow(framesToDraw, gifImageDouble, imSize, numOfPatches, a, b, N, t);

%% create the optice flow video!
%this function calc the optic flow for each image and then wraps it up
% into a full video containg the optic flow 'arrows' drawn on it.
vidName = 'OpticFlowMyVid2';
close(hfig1);
close(hfig2);
CreateOpticFlowVid(frames, gifImageDouble, imSize, numOfPatches, a, b, vidName, N, t);

%% section 3 repeat for t = 0.1
N = 16;
t = 0.1;
numOfPatchesInRow = floor(imSize(1) / N);
numOfPatches = (numOfPatchesInRow)^2;
[a , b] = meshgrid(1:N:imSize(1), 1:N:imSize(1));
DrawOpticFlow(framesToDraw, gifImageDouble, imSize, numOfPatches, a, b, N, t);

%% section 4.1 repeat for N = 8 and t = 1
N = 8;
t = 1;
numOfPatchesInRow = floor(imSize(1) / N);
numOfPatches = (numOfPatchesInRow)^2;
[a , b] = meshgrid(1:N:imSize(1), 1:N:imSize(1));
DrawOpticFlow(framesToDraw, gifImageDouble, imSize, numOfPatches, a, b, N, t);
%% section 4.2 repeat for N = 8 and t = 0.1
N = 8;
t = 0.1;
numOfPatchesInRow = floor(imSize(1) / N);
numOfPatches = (numOfPatchesInRow)^2;
[a , b] = meshgrid(1:N:imSize(1), 1:N:imSize(1));
DrawOpticFlow(framesToDraw, gifImageDouble, imSize, numOfPatches, a, b, N, t);






