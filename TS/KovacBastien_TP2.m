% Spectral Analysis

% 1.

f1 = 0.15;
f2 = 0.18;
N = 512;
snr = 10;

y = ones(1, N);
for i = 0:N-1
   y(i + 1) = exp(-j * 2 * pi * f1 * i) + exp(-j * 2 * pi * f2 * i); 
end

b = gaussian_noise(snr, y);
y = y + b;

% 2.

Y = fft(y, N * 2);
f = -1/2 : 1/(N * 2) : 1/2 -0.0000001;

figure,
subplot(2,2,1), semilogy(f, abs(fftshift(Y))), title('DSP');

% 3.

M = 128;
dsp = pwelch(y, M, 1024);

subplot(2,2,2), semilogy(f, abs(fftshift(dsp))), title(sprintf('DSP - Welch (M = %d)', M));

M = 64;
dsp = pwelch(y, M, 1024);

subplot(2,2,3), semilogy(f, abs(fftshift(dsp))), title(sprintf('DSP - Welch (M = %d)', M));

M = 512;
dsp = pwelch(y, M, 1024);

subplot(2,2,4), semilogy(f, abs(fftshift(dsp))), title(sprintf('DSP - Welch (M = %d)', M));

% 4. Use lpc function

% Spectrogram

% 1.

% Returns the DPS of the given input signal, computed with Welch's method
% X - Input signal
% M - Size of the window
% nfft - Number of points for the discrete fft of windows
function dsp = pwelch(x, M, nfft)
    d = [];
    
    han = 0:M-1;
    han = 0.5 - 0.5 * cos (2 * pi * han / M - 1);
    
    s_han = norm(han, 2) ^ 2;
    
    for i = 1:M/2:size(x, 2)
        window = x(i:min(i+M, size(x, 2)) - 1);
        
        delta = size(window, 2) - size(han, 2);
        if delta ~= 0
            han = han(1:size(window, 2));
        end
        
        window = window .* han;
        
        window = abs(fft(window, nfft)) .^ 2 ./ s_han;
        
        d = [d ; window];
    end
    
    dsp = mean(d, 1);
    dsp = dsp ./ (2 * pi);
    
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