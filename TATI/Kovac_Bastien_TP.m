% - 1

i = double(rgb2gray(imread('lena_std.tif')));
[w, h] = size(i);
i = i(:);

snr = 20;
b = gaussian_noise(20, i);

ib = i + b;

i = reshape(i, [w, h]);
ib = reshape(ib, [w, h]);

subplot(2, 2, 1), imshow(uint8(i)), title('Original');

mse = mean_squared_error(i, ib);
psnr = peak_to_signal_ratio(i, ib);

subplot(2, 2, 2), imshow(uint8(ib)), title(sprintf('Gaussian Noise (SNR = %d dB)\nMSE = %d\nPSNR = %d', snr, mse, psnr));

% - 2

% a
sigma = 0.75;
% Choose N so that it's 6 times the standard deviation, so that it tends
% towards 0 on the edges
N = ceil(sigma * 6);
ib_f1 = gauss_filter(ib, sigma, 10);

mse = mean_squared_error(i, ib_f1);
psnr = peak_to_signal_ratio(i, ib_f1);

subplot(2, 2, 3); imshow(uint8(ib_f1)), title(sprintf('Gaussian Filter (Sigma = %d, N = %d)\nMSE = %d\nPSNR = %d', sigma, N, mse, psnr));


% - 3
h = [1 4 7 ; 2 5 8 ; 3 6 9];
x = round(5 * rand(3, 3));

% a -
result = conv2(h, x, 'full');

% b -
result = conv2(fft2(h), fft2(x), 'full');

% Computes the Mean Squared Error between two signals x and y.
% This assumes x and y have the same size
function mse = mean_squared_error(x, y)
    mse = sum((x(:) - y(:)).^2) / numel(x);
end

% Computes the Peak to Signal Noise Ratio between two signals x and y.
% This assumes x and y have the same size
function psnr = peak_to_signal_ratio(x, y)
    psnr = 10 * log10( 255^2 / mean_squared_error(x, y));
end

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


% Returns a gaussian noise computed from a signal x, with a Signal to Noise
% Ratio of SNRdb (in dB)
% SNRdb : The Signal to Noise Ratio (in dB)
% x : The input signal (vectorized)
function b = gaussian_noise(SNRdb, x)
    Px = sum(x.^2) / size(x, 1);
    sigma = sqrt(Px * 10 ^(-SNRdb / 10));
    
    b = randn(size(x)) .* sigma;
end