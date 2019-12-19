function disparity_map = CalcDisparityMap(input_image,W,search_margin_x,search_margin_y,stride)
 
% The function CalcDisparityMap(...) calculates the disparity map.
 
% Inputs:
 
% input_image - A structure containing both left and right stereo images
% input_image.left  - Left stereo image
% input_image.right - Right stereo image
 
% W - Search window size of template from left image on right image
 
% search_margin_x - Search margin of left template on right image. The search will be conducted
%                   on each pixel (x_c,y_c), between the margins [x_c, x_c + search_margin_x] 
% search_margin_y - Search margin of left template on right image. The search will be conducted
%                   on each pixel (x_c,y_c), between the margins [y_c - search_margin_y, y_c + search_margin_y] 
 
% stride - Stride of corresponding pixel search (both for x and y coordinates):
 
 
% Output:
 
% disparity_map - the disparity map.
 
%%
floor_W_div_2 = floor(W/2);
 
SizeLeftX = size(input_image.left,2);
SizeLeftY = size(input_image.left,1);
SizeRightX = size(input_image.right,2);
SizeRightY = size(input_image.right,1);
 
CorrespondanceX = zeros(SizeLeftY,SizeLeftX);
 
waitbar_f = waitbar(0,'Calculating disparity map...');
for LeftImg_x_ind = 1: stride: (SizeLeftX - W + 1)
    waitbar((LeftImg_x_ind - 1)/(SizeLeftX - W + 1),waitbar_f,'Calculating disparity map...');
    for LeftImg_y_ind = 1:stride : (SizeLeftY - W + 1)
        
        % Calculate margins of search:
        x_min = max(1,LeftImg_x_ind - search_margin_x);
        x_max = min(SizeRightX - W + 1 ,LeftImg_x_ind);
        y_min = max(1,LeftImg_y_ind - search_margin_y);
        y_max = min(SizeRightY - W + 1,LeftImg_y_ind + search_margin_y);
        
        % Calculate the template of the left image for SSD search on the right image:
        template_left = single(input_image.left(LeftImg_y_ind:(LeftImg_y_ind+W-1),LeftImg_x_ind:(LeftImg_x_ind+W-1),:));
               
        % Calculate correspondance map:
        [~,Corresponding_x,~] = MatchWindow(template_left,single(input_image.right),x_min,x_max,y_min,y_max);
        
        % Shift the correspondance map to the center on the template window:
        CorrespondanceX(LeftImg_y_ind+floor_W_div_2,LeftImg_x_ind+floor_W_div_2) = Corresponding_x+floor_W_div_2;
    end
end
 
close(waitbar_f);
%%
% Interpolate correspondance if stride is greater than 1:
 
if stride == 1
    interp_CorrespondanceX = CorrespondanceX;
else
    TempCorrespondance_X = CorrespondanceX((floor_W_div_2+1):stride:end,(floor_W_div_2+1):stride:end);
 
    x_vec = ((1:size(CorrespondanceX,2))-(floor_W_div_2+1))./stride+1;
    y_vec = ((1:size(CorrespondanceX,1))-(floor_W_div_2+1))./stride+1;
    [Xq,Yq] = meshgrid(x_vec,y_vec);
 
    interp_CorrespondanceX = interp2(TempCorrespondance_X,Xq,Yq,'linear');
 
end
 
% Calculate the disparity map:
% disparity_map = (ones(SizeRightY,SizeRightX).*(1:SizeRightX) - interp_CorrespondanceX);

disparity_map = (repmat((1:SizeRightX),SizeRightY,1) - interp_CorrespondanceX);
 

