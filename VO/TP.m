Im = double(imread('cameraman.tif'));

im(Im);
[I, J] = select1(Im, 90);
plotpoints(I, J, size(I));
title('Select 1');

figure,
im(Im);
[I, J] = select2(Im, 20);
plotpoints(I, J, size(I));
title('Select 2');

% Returns the response from the Harris and variants methods
% Im - Greyscale image
% SigmaDerivation - Sigma used to compute first derivatives of the image
% SigmaIntegration - Sigma used when computing the structure tensor
% Method - 'Harris-Plessey' or 'Shi-Thomasi' or 'Noble'
% R - Response matrix
function [R] = response(Im, SigmaDerivation, SigmaIntegration, Method)
    
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
function [I, J] = select1(R, percent)
    R2 = nonmax(R, 20);
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
