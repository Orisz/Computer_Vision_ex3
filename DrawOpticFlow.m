%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function name: CreateOpticFlowVid
%inputs: 'framesToDraw' - chosen frames  to draw
%        'gifImageDouble' - the sliced video images after pre-processing
%        'imSize' - two dim tensor containing the images sizes(rows,cols)
%        'numOfPatches' - helper variable, the total number of patches in
%        the image
%        'a' - X grid variable(product of 'meshgrid')
%        'b' - Y grid variable(product of 'meshgrid')
%        'patchDim' - each patch is of size NXN this variable holding the
%        size 'N'
%        'thresh' - algorithm thresh hold: we only calc current patch optic
%outputs: NULL
%descriptions: given the preprocesed data draw the optic flow arrows on the
%users chosen image frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = DrawOpticFlow(framesToDraw, gifImageDouble, imSize, numOfPatches, a, b, patchDim, thresh)
    N = patchDim;
    t = thresh;
    for j = 1:length(framesToDraw)%iterate images
        imT1 = gifImageDouble(:,:,framesToDraw(j));
        imT2 = gifImageDouble(:,:,framesToDraw(j) + 1);
        CurSpeedGrid_u = zeros(imSize);
        CurSpeedGrid_v = zeros(imSize);
        for i = 1:numOfPatches
            patchTopLeftRowNum = a(i);
            patchTopLeftColNum = b(i);
            [u, v] = CalcPatchOpticFlow(imT1, imT2, patchTopLeftRowNum, patchTopLeftColNum, N, t);
            CurSpeedGrid_u((patchTopLeftRowNum + patchTopLeftRowNum + N)/2 ,...
                (patchTopLeftColNum + patchTopLeftColNum + N)/2) = u;
            CurSpeedGrid_v((patchTopLeftRowNum + patchTopLeftRowNum + N)/2 ,...
                (patchTopLeftColNum + patchTopLeftColNum + N)/2) = v;
            [x, y] = meshgrid(1:imSize(2), 1:imSize(1));
        end
        subplot(2,2,j);
        imshow(imT1,[]);
        % please note: according to matlab docomantation 'hold all' is
        % deprecated: "This syntax will be removed in a future release.
        % Use hold on instead."
        hold on;
        quiver(x, y, CurSpeedGrid_u, CurSpeedGrid_v, 20, 'r','filled');
        title(['OpticFlow - frame: ' , num2str(framesToDraw(j))]);
        hold off;
    end
end

