%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function name: CalcPatchOpticFlow
%inputs: 'imageT1' - the images we are going to calc the optic flow on
%        'imageT2' - the next image after 'imageT1', needed for the 'time'
%        derivative.
%        'patchStartRow' - top left 'row' coordinate of current patch
%        'patchStartCol' - top left 'column' coordinate of current patch
%        the image
%        'patchDim' - each patch is of size NXN this variable holding the
%        size 'N'
%        'thresh' - algorithm thresh hold: we only calc current patch optic
%        flow if and only if the smallest eign val of the data matrix is
%        bigger then 'thresh'
%outputs: 'u' - the out put of the optic flow: speed in the horizontal
%           direction
%         'v' - the out put of the optic flow: speed in the vertical
%           direction
%descriptions: calcs the optic flow on a patch of size
%'patchDim'X'patchDim' starting at the [patchStartRow, patchStartCol]
%           'imageT1' coordinate.         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u , v] = CalcPatchOpticFlow(imageT1, imageT2, patchStartRow, patchStartCol, patchDim, thresh)
    %derivative along the second dim i.e. x axis
    Ix = diff(imageT1(patchStartRow : (patchStartRow + patchDim - 1) ,...
        patchStartCol : (patchStartCol + patchDim - 1)), 1 , 2);
    Ix = [Ix zeros(patchDim,1)];
    %derivative along the firt dim i.e. y axis
    Iy = diff(imageT1(patchStartRow : (patchStartRow + patchDim - 1) ,...
        patchStartCol : (patchStartCol + patchDim - 1)), 1, 1);
    Iy = [Iy ; zeros(1,patchDim)];
    %derivative along the time dim i.e. image t+1 - image t
    It = imageT2(patchStartRow : (patchStartRow + patchDim - 1) ,...
        patchStartCol : (patchStartCol + patchDim - 1)) - ...
        imageT1(patchStartRow : (patchStartRow + patchDim - 1) ,...
        patchStartCol : (patchStartCol + patchDim - 1));
    A = [Ix(:) , Iy(:)];
    AA = A'*A;
    b = -It(:);
    eigAA = eig(AA);
    if min(eigAA) < thresh
        u = 0;
        v = 0;
        return 
    end
    vec_u_v = pinv(A)*b;
    u = vec_u_v(1);
    v = vec_u_v(2);
end