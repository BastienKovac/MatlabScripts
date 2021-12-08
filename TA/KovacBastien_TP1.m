close all;
clear;

i = double(rgb2gray(imread('lena_std.tif')));
[r, c] = size(i);

SNRdb = 20;

b = gaussian_noise(SNRdb, i(:));

ib = i(:) + b;
ib = reshape(ib, [r, c]);

figure,
subplot(3, 3, 1), imshow(uint8(i)), title('Original Image');

mse = mean_squared_error(ib, i);
psnr = peak_to_signal_ratio(ib, i);

subplot(3, 3, 2), imshow(uint8(ib)), title(sprintf('Noised image\nMSE = %d\nPSNR = %d', mse, psnr));

fixed = wiener(ib);
mse = mean_squared_error(fixed, i);
psnr = peak_to_signal_ratio(fixed, i);

subplot(3, 3, 4), imshow(uint8(fixed)), title(sprintf('Wiener filter\nMSE = %d\nPSNR = %d', mse, psnr));

N = 128;

fixed = wiener_blocks(ib, N);
mse = mean_squared_error(fixed, i);
psnr = peak_to_signal_ratio(fixed, i);

subplot(3, 3, 5), imshow(uint8(fixed)), title(sprintf('Block Wiener filter\nMSE = %d\nPSNR = %d\nN = %d', mse, psnr, N));




% Apply Wiener filter by blocks
% ib : Noisy image
% N : Size of blocks
function y = wiener_blocks(ib, N)    
    C = split_blocks(ib, N);
    
    for k = 1:numel(C)
        C{k} = wiener(C{k});
    end
    
    y = cell2mat(C);    
end

% Splits the given image in blocks of size NxN
% i : Input image
% N : Size of the blocks
% C : Array of blocks
function C = split_blocks(i, N)
    [r, c] = size(i);

    rows = floor(r / N);
    blockVectorR = [N * ones(1, rows), rem(r, N)];
    
    cols = floor(c / N);
    blockVectorC = [N * ones(1, cols), rem(c, N)];
    
    C = mat2cell(i, blockVectorR, blockVectorC);
end

% De-noise an image using a Wiener filter
% ib : Noisy image
% H : (Optional) Point Spread Function
function y = wiener(ib, H)
    SNR = 1 / std(ib(:))^2;
    
    if (nargin < 3)
        H = 1;
    end
    
    y = real(ifft2(fft2(ib) .* (conj(H) / (H.^2 + SNR^2))));
end

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

% Returns a gaussian noise computed from a signal x, with a Signal to Noise
% Ratio of SNRdb (in dB)
% SNRdb : The Signal to Noise Ratio (in dB)
% x : The input signal (vectorized)
function b = gaussian_noise(SNRdb, x)
    Px = sum(x.^2) / size(x, 1);
    sigma = sqrt(Px * 10 ^(-SNRdb / 10));
    
    b = randn(size(x)) .* sigma;
end