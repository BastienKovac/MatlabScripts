Im = double(imread('cameraman.tif'));

im(Im);
[I, J] = select1(Im, 90, 20);
plotpoints(I, J, size(I));
title('Select 1');

figure,
im(Im);
[I, J] = select2(Im, 20);
plotpoints(I, J, size(I));
title('Select 2');

figure,
im(Im);

SigmaDerivation = 1;
SigmaIntegration = 2;
Method = 'Harris-Plessey';
WindowSize = 7;
Percent = 1;

R = response(Im, SigmaDerivation, SigmaIntegration, Method);
[I, J] = select1(R, Percent, WindowSize);
plotpoints(I, J, size(I));
title('Harris-Plessey method');


% Returns the response from the Harris and variants methods
% Im - Greyscale image
% SigmaDerivation - Sigma used to compute first derivatives of the image
% SigmaIntegration - Sigma used when computing the structure tensor
% Method - 'Harris-Plessey' or 'Shi-Thomasi' or 'Noble'
% R - Response matrix
function [R] = response(Im, SigmaDerivation, SigmaIntegration, Method)
    [~, Di, Dj, Dii, Djj, Dij] = gaussmask2(SigmaDerivation);
    
    I = conv2(Im, Di, 'same');
    J = conv2(Im, Dj, 'same');
    
    S = gaussmask2(SigmaIntegration);
   
    A = conv2(I .^ 2, S, 'same');
    C = conv2(J .^ 2, S, 'same');
    B = conv2(I .* J, S, 'same');
    
    if strcmp(Method, 'Harris-Plessey')
        D = A .* C -B.^2 - 0.04 * (A + C) .^ 2;
    elseif strcmp(Method, 'Noble')
        D = 2 * (A .* C - B.^2) ./ (A + C + 1e-15);
    elseif strcmp(Method, 'Shi-Tomasi')
        UniformSmooth = ones(size(S) / numel(S));
        Asmooth = conv2(Dii, UniformSmooth, 'same');
        Bsmooth = conv2(Djj, UniformSmooth, 'same');
        Csmooth = conv2(Dij, UniformSmooth, 'same');
        
        D = (Asmooth + Csmooth - sqrt((Asmooth - Csmooth) .^ 2 + 4 * Bsmooth .^ 2)) / 2;
    end
    
    R = D;
end

% Select nbPoints interest points 
% R : The input matrix
% nbPoints : The number of points
% I = The row indices of selected points
% J = The col indices of selected points
function [I, J] = select2(R, nbPoints)
    A = nonmax(R, 5);
    
    [~, Idx] = sort(A(:), 'descend');
    
    Idx = Idx(1:nbPoints);
    
    I = zeros(nbPoints, 1);
    J = zeros(nbPoints, 1);
    
    for i = 1:nbPoints
       [row, col] = ind2sub(size(R), Idx(i));
       
       I(i) = row;
       J(i) = col;
    end
end

% Select interest points 
% R : The input matrix
% percent : The percentage of points
% I = The row indices of selected points
% J = The col indices of selected points
% WindowSize = The window size
function [I, J] = select1(R, percent, WindowSize)
    R2 = nonmax(R, WindowSize);
    maxValue = max(max(R2(:)));
    
    [I, J] = find(R2 > (percent / 100) * maxValue);
end

% Deletes the non-local maxima in R1
% R1 : The input matrix
% windowSize : The size of computed local window
% R2 : The output matrix
function [R2] = nonmax(R1, windowSize)
    R2 = zeros(size(R1));
    N = max(1, floor(windowSize / 2));
    
    for i = 1:size(R1, 1)
        for j = 1:size(R1, 2)
            window = R1(max(1, i - N) : min(size(R1, 1), i + N), max(1, j - N) : min(size(R1, 2), j + N));
            
            if max(window(:)) == R1(i, j)
                R2(i, j) = R1(i, j);
            end
        end
    end
end
