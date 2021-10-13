% Least-Sqaure

% - 1

u = transpose(linspace(0, 128, 128));
U = [u u .^ 2 u.^3];
e = randn(1, 128) .* 0.01;

y = transpose(U * [1 ; 1.5 ; -0.7]);

% - 6

theta = (U' * U) \ (U' * transpose(y));

% Image Compression
i = double(rgb2gray(imread('lena_std.tif')));

[U, S, V] = svd(i);
figure, plot(diag(S)), title('Singular values');

figure, 
subplot(2, 2, 1), imshow(uint8(i)), title('Original');
subplot(2, 2, 2), imshow(uint8(compressImage(i, 1))), title('Compressed (1%)');
subplot(2, 2, 3), imshow(uint8(compressImage(i, 3))), title('Compressed (3%)');
subplot(2, 2, 4), imshow(uint8(compressImage(i, 10))), title('Compressed (10%)');

% Deterministic signals
figure, 

[f, y] = getSignal(200, 2000, 0.05);
Y = fft(y);
subplot(3, 2, 1), plot(f, y), title(sprintf('Signal\nfe = 2 kHz, duration = 50 ms'));
subplot(3, 2, 2), plot(f, abs(Y)), title('Fourier Transform');

[f, y] = getSignal(200, 2000, 0.5);
Y = fft(y);
subplot(3, 2, 3), plot(f, y), title(sprintf('Signal\nfe = 2 kHz, duration = 500 ms'));
subplot(3, 2, 4), plot(f, abs(Y)), title('Fourier Transform');

[f, y] = getSignal(200, 250, 0.05);
Y = fft(y);
subplot(3, 2, 5), plot(f, y), title(sprintf('Signal\nfe = 250Hz, duration = 50 ms'));
subplot(3, 2, 6), plot(f, abs(Y)), title('Fourier Transform');

% Returns the image, compressed by percent%
% i : Base image
% percent : compression percentage (ex : 1%)
function i_compressed = compressImage(i, percent)
    [U, S, V] = svd(i);
    S(max(diag(S)) * (percent / 100) > S(:)) = 0;
    i_compressed = U * S * V';
end

% Creates and return a sinusoidal with normalized frequency
% f0 sinusoid frequency
% fe sample frequency
% Duration in seconds
function [f, y] = getSignal(f0, fs, duration)
    f = ((0:fs:duration) / fs) - 0.5;
    y = sin(2 * pi * f0 * f);
end
