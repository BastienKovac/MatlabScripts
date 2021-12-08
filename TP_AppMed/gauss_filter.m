% Returns the input image, filtered with a gaussian filter of standard
% deviation sigma and of kernel size N
% x : Input image
% sigma : Standard deviation of the gaussian filter
% N : The kernel size
function filtered = gauss_filter(x, sigma, N)
    ind = -floor(N / 2) : floor(N / 2);
    [X, Y] = meshgrid(ind, ind);
    
    % Create gaussian kernel
    h = exp(-(X.^2 + Y.^2) / (2 * sigma * sigma));
    h = h / sum(h(:));

    filtered = conv2(x, h, 'same');
end