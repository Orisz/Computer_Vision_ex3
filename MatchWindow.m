function [SSD,Corresponding_x,Corresponding_y] = MatchWindow(Template,ImageToMatch,x_min,x_max,y_min,y_max)
 
% The function MatchWindow(...) calculate correspondance between a template
% to an image, using minimum squre-of-sum-of-differences (SSD) measure. 
% The search is preformed only on a region of the image.
 
% Inputs:
% Template - the template to be searched on the image;
% ImageToMatch - The image on which we search the template
 
% [x_min, x_max], [y_min, y_max] - Defines the search area on the image.
 
% Outputs:
 
% SSD - The minimal SSD found for the best correspondance;
% Corresponding_x - The optimal correspondance x coordinate on the image
% Corresponding_y - The optimal correspondance y coordinate on the image
 
SSD_Calc_stride_x = 1;
SSD_Calc_stride_y = 1;
 
W = size(Template,1);
 
SSD_size_x = x_max - x_min + 1;
SSD_size_y = y_max - y_min + 1;
SSD  = zeros(SSD_size_y,SSD_size_x,'single');
 
min_SSD = inf;
 
W_half = ceil(W/2);
 
for Image_x_ind = x_min:SSD_Calc_stride_x:x_max
    for Image_y_ind = y_min:SSD_Calc_stride_y:y_max
        SSD_x_ind = Image_x_ind - x_min + 1;
        SSD_y_ind = Image_y_ind - y_min + 1;
        temp_image = ImageToMatch(Image_y_ind:(Image_y_ind+W-1),Image_x_ind:(Image_x_ind+W-1),:);
        difference_all = temp_image(:) - Template(:);
        
        SSD(SSD_y_ind,SSD_x_ind) = sum(difference_all.*difference_all);
        
        if SSD(SSD_y_ind,SSD_x_ind) < min_SSD
            min_SSD = SSD(SSD_y_ind,SSD_x_ind);
            Corresponding_x = Image_x_ind;
            Corresponding_y = Image_y_ind;
        end
    end
end
 


