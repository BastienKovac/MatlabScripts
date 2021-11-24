%% Exercice 1

% 1.
t = linspace(0, 5, 501);
Y = 1 + exp(-t);
e = gaussian_noise(8, Y);
Y = Y + e;

% 2.

% U will be of size 501x2
U = [ones(501, 1) exp(-t)'];
E = e';

% 3.
A = (U' * U) \ (U' * transpose(Y));

figure,
p1 = plot(t, Y, 'b'); hold on;
p2 = plot(t, U * A + E, 'r'); hold off;

legend([p1(1), p2(1)], 'Measures', 'Estimation');

%% Exercice 2

% 1.
fs = 1000;
d = 0.15;

[~, s1] = getSignal(110, fs, d);
[t, s2] = getSignal(210, fs, d);
s = s1 + s2;

% 2.
S = fft(s);
f = fs * (1:(length(t))) / length(t);

figure,
subplot(1, 2, 1), plot(f, abs(S)), 
title('Fourier Transform of s');
xlabel('f (Hz)'),
ylabel('|S|');

% On the non-normalized plot, we can observe peaks around
% the frequencies of the two sine components of s (one
% around 110 Hz and one around 210 Hz).
% Note that they are mirrored around the mid-point of 500 Hz

subplot(1, 2, 2), plot((f / fs) - 0.5, abs(S)),
title('Fourier Transform of s with normalized frequencies');
xlabel('f (Hz)'),
ylabel('|S|');

% 3.
% Only use first half of the signal
[pks, locs] = findpeaks(abs(S(1:ceil(length(S) / 2))), 'SORTSTR', 'descend');

% We can find the main frequencies of the signal by taking the localization
% of each peak in the frequency vector, as followed :
main_f = f(locs);

% As we can see, the results are close to what would be expected
% (218,5430 and 119.2053 instead of 210 and 110).

% 4.
% We can increase the sample frequency (fs) to increase the number
% of samples, which would make the result more precise

% 5.
% Similarly to last question, we can increase the number of points
% of the fourier transform to increase the result precision


%% Exercice 3

% 1.
fs = 10e6;
t = 0:1 / fs:1e-3;
f0 = 2e6;

e = cos(2 * pi * f0 * t);

figure,
subplot(2, 2, 1), plot(t, e), 
title('Signal e(t)'),
xlabel('t (s)'),
ylabel('e(t)');

E = fft(e);
f = fs * (1:(length(t))) / length(t);

subplot(2, 2, 2), plot(f, abs(E)), 
title('E(f)'),
xlabel('f (Hz)'),
ylabel('|E(f)|');

% The signal is hard to read due to the high number of samples
% Its fourier transformation is way more readable and shows
% two peaks around 2 and 8 MHz respectively

fd = 5e3;
s = cos(2 * pi * (f0 + fd) * t);

subplot(2, 2, 3), plot(t, s), 
title('Signal s(t)'),
xlabel('t (s)'),
ylabel('s(t)');

S = fft(s);

subplot(2, 2, 4), plot(f, abs(S)), 
title('S(f)'),
xlabel('f (Hz)'),
ylabel('|S(f)|');

% If we zoom around each peak of S(f), we can observe the impact
% of the Doppler frequency fd, as there is a smaller peaker located
% around f0 + fd (on the first half of the FT)

% 3.
sd = s .* e;

% a)
SD = fft(sd);

figure,
plot(f, abs(SD)),
title('SD(f)'),
xlabel('f (Hz)'),
ylabel('|SD(f)|');

% We can observe on SD(f) a peak around 6000 Hz, which
% matches the Doppler frequency fd

% b)

fc = 10e3;
wt = (1 / fs) / fc;
lowpass = filter(1, [1 -fc], sd);

figure,
plot(abs(fft(lowpass))),
title('SD(f)'),
xlabel('f (Hz)'),
ylabel('|SD(f)|');


% Creates and return a sinusoidal with normalized frequency
% f0 sinusoid frequency
% fe sample frequency
% Duration in seconds
% t : Time
% y : Signal
function [t, y] = getSignal(f0, fs, duration)
    dt = 1 / fs;
    t = 0:dt:duration;
    
    y = sin(2 * pi * f0 * t);
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