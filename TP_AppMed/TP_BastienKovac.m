clear all;
close all;

%% I

% 1.

data = load('us.mat');
img = data.im;

figure,
colormap('gray'), imagesc(img), title('Original image');

% Une colonne = une ligne radio-fréquence
% Taille = profondeur d'exploration (en pixels)
x = img(:,5);

figure,
plot(x), title('Column 5 of the original image');

% 2.

% = Enveloppe du signal
y = abs(hilbert(x));

figure,
plot(x, 'b'), hold, plot(y, 'r'), title('Radio-frequency line and its bound') ;

% 3.

y = abs(hilbert(img));

figure,
subplot(1,2,1), colormap('gray'), imagesc(y);
subplot(1,2,2), plot(hist(y(:), 64));

y_compressed = log10(y);
figure,
subplot(1,2,1), colormap('gray'), imagesc(y_compressed);
subplot(1,2,2), plot(hist(y_compressed(:), 64));

y_contrast = log10(50 * y + 50);
figure,
subplot(1,2,1), colormap('gray'), imagesc(y_contrast);
subplot(1,2,2), plot(hist(y_contrast(:), 64));

%% II

% Gaussian
filtered = gauss_filter(img, 1, 9);
b_mode = log10(abs(hilbert(filtered)) * 50 + 50);

figure,
hold on
subplot(1,2,1), colormap('gray'), imagesc(b_mode), title('B-Mode of filtered image');

b_mode = log10(abs(hilbert(img)) * 50 + 50);
b_mode = gauss_filter(b_mode, 1, 9);

subplot(1,2,2), colormap('gray'), imagesc(b_mode), title('Filtered B-Mode');

S = axes('visible', 'off', 'title', 'Gaussian Filter' );
hold off

% Bilateral
filtered = bifilt(img, 9, 1, 1);
b_mode = log10(abs(hilbert(filtered)) * 50 + 50);

figure,
hold on
subplot(1,2,1), colormap('gray'), imagesc(b_mode), title('B-Mode of filtered image');

b_mode = log10(abs(hilbert(img)) * 50 + 50);
b_mode = gauss_filter(b_mode, 1, 9);

subplot(1,2,2), colormap('gray'), imagesc(b_mode), title('Filtered B-Mode');

S = axes('visible', 'off', 'title', 'Bilateral Filter' );
hold off

% NL Means
filtered = NLmeansfilter(img, 1, 1, 1);
b_mode = log10(abs(hilbert(filtered)) * 50 + 50);

figure,
hold on
subplot(1,2,1), colormap('gray'), imagesc(b_mode), title('B-Mode of filtered image');

b_mode = log10(abs(hilbert(img)) * 50 + 50);
b_mode = gauss_filter(b_mode, 1, 9);

subplot(1,2,2), colormap('gray'), imagesc(b_mode), title('Filtered B-Mode');

S = axes('visible', 'off', 'title', 'NL-Means Filter' );
hold off

% Anisotrope
filtered = anisodiff2D(img, 5, 1, 1, 1);
b_mode = log10(abs(hilbert(filtered)) * 50 + 50);

figure,
hold on
subplot(1,2,1), colormap('gray'), imagesc(b_mode), title('B-Mode of filtered image');

b_mode = log10(abs(hilbert(img)) * 50 + 50);
b_mode = gauss_filter(b_mode, 1, 9);

subplot(1,2,2), colormap('gray'), imagesc(b_mode), title('Filtered B-Mode');

S = axes('visible', 'off', 'title', 'Anisotrope Filter' );
hold off
