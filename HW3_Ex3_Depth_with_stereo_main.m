% HW3 Ex. 3
 
% Load images and Gound-truths:
close all;
 
 
input_images{1}.left = imread('.\Depth with stereo data\input\test03_l.png');
input_images{1}.right = imread('.\Depth with stereo data\input\test03_r.png');
load('.\Depth with stereo data\groundtruth\test03.mat')
groundtruths{1} = groundtruth;
 
input_images{2}.left = imread('.\Depth with stereo data\input\test04_l.png');
input_images{2}.right = imread('.\Depth with stereo data\input\test04_r.png');
load('.\Depth with stereo data\groundtruth\test04.mat')
groundtruths{2} = groundtruth;
 
input_images{3}.left = imread('.\Depth with stereo data\input\test07_l.png');
input_images{3}.right = imread('.\Depth with stereo data\input\test07_r.png');
load('.\Depth with stereo data\groundtruth\test07.mat')
groundtruths{3} = groundtruth;
 
for ind = 1:3
    figure;
    f1 = subplot(1,2,1);
    imshow(input_images{ind}.left);
    title('Left image');
    f2 = subplot(1,2,2);
    imshow(input_images{ind}.right);
    title('Right image');
 
    linkaxes([f1 f2],'xy')
end
 
%% Calculate disparity map:
 
% Window size of left image:
W = 5;
 
% Search area margins on right image:
search_margin_x = 60;
search_margin_y = 0;
 
% Stride of corresponding pixel search (both for x and y coordinates):
stride = 2;
 
% Run on all 3 examples:
for ind = 1:3
    
    % Calculate the disparity map:
    disparity_map = CalcDisparityMap(input_images{ind},W,search_margin_x,search_margin_y,stride);
    
    % Calculate the RMSE relative to the ground truth, inside a defined
    % frame:
    RMSE_FrameSize = max(21,stride);
    RMSE = CalcDisparityMapError(disparity_map,groundtruths{ind},RMSE_FrameSize);
 
 
    figure; 
    f1 = subplot(2,1,1);
    imagesc(disparity_map);
    title('Disparity map');
    colormap jet;
    colorbar
    caxis([0 max(groundtruths{ind}(:))])
    linkaxes([f1 f2],'xy')
 
    f2 = subplot(2,1,2);
    imagesc(groundtruths{ind})
    title('Ground truth');
 
    colormap jet;
    colorbar
    caxis([0 max(groundtruths{ind}(:))])
    linkaxes([f1 f2],'xy')
 
    figure; 
    imagesc(disparity_map);
    title('Disparity map');
    colormap jet;
    colorbar
    caxis([0 max(groundtruths{ind}(:))])
end
 



