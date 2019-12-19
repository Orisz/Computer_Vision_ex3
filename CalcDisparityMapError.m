function RMSE = CalcDisparityMapError(disparity_map,groundtruth,RMSE_FrameSize)
 
% The function CalcDisparityMapError(...) calculate the Root-Mean-Square
% Error of the disparity map relative to a ground truth.
 
% Inputs:
 
% disparity_map - The disparity map.
% groundtruth - The ground truth.
% RMSE_FrameSize - Only calculate the RMSE inside a frame, where the data is valid 
 
% Outputs:
% RMSE - The RMSE between the disparity map and the ground-truth
 
SizeLeftY = size(disparity_map,1);
SizeLeftX = size(disparity_map,2);
 
RMSE = 0;
NumPixels = 0;
 
 
for y_ind = (RMSE_FrameSize+1):(SizeLeftY-(RMSE_FrameSize))
    for x_ind = (RMSE_FrameSize+1):(SizeLeftX-(RMSE_FrameSize))
        RMSE = RMSE + (disparity_map(y_ind,x_ind) - groundtruth(y_ind,x_ind)).^2;    
        NumPixels = NumPixels + 1;
    end
end
 
RMSE = sqrt(RMSE ./ NumPixels);
 
disp(['RMSE = ',num2str(RMSE)]);




