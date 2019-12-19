%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function name: CreateOpticFlowVid
%inputs: 'frames' - total number of frames
%        'gifImageDouble' - the sliced video images after pre-processing
%        'imSize' - two dim tensor containing the images sizes(rows,cols)
%        'numOfPatches' - helper variable, the total number of patches in
%        the image
%        'a' - X grid variable(product of 'meshgrid')
%        'b' - Y grid variable(product of 'meshgrid')
%        'vidName' - user input : the desirded name of the output video
%        'patchDim' - each patch is of size NXN this variable holding the
%        size 'N'
%        'thresh' - algorithm thresh hold: we only calc current patch optic
%outputs: NULL
%descriptions: given the preprocesed data create the original video with
%the optic flow arrows drawn on top of it. the video will be located at the
% 'code' folder.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = CreateOpticFlowVid(frames, gifImageDouble, imSize, numOfPatches, a, b, vidName, patchDim, thresh)
    N = patchDim;
    t = thresh;
    for j = 1:(frames - 1)%iterate images
        imT1 = gifImageDouble(:,:,j);
        imT2 = gifImageDouble(:,:,j+1);
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
        imshow(imT1,[]);
        % please note: according to matlab docomantation 'hold all' is
        % deprecated: "This syntax will be removed in a future release.
        % Use hold on instead."
        hold on;
        quiver(x, y, CurSpeedGrid_u, CurSpeedGrid_v, 20, 'r','filled');
        hold off;
        F(j) = getframe(gcf);
    end

    all_valid = true;
    flen = length(F);
    for K = 1 : flen
        if isempty(F(K).cdata)
            all_valid = false;
            fprint('Empty frame occurred at frame #%d of %d\n', K, flen);
        end
    end
    if ~all_valid
        error('Did not write movie because of empty frames')
    end

    % create the video writer with 1 fps
    name = [vidName, '.avi'];
    writerObj = VideoWriter(name);
    writerObj.FrameRate = 10;
    % set the seconds per image
    % open the video writer
    open(writerObj);
    % write the frames to the video
    for i=1:length(F)
        % convert the image to a frame
        frame = F(i) ;    
        writeVideo(writerObj, frame);
    end
    % close the writer object
    close(writerObj);
end
