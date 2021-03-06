clear
close all

%% TP-1

m = double(zeros(256,256,3));
for i = 1:256
    for j = 1:256
        m(i,j,1) =  256-floor((i+j)/2);
        m(i,j,2) = i-1;
        m(i,j,3) = j-1;
    end
end

a = 1;
b = 1;
c = 1;
N = 2^(a+b+c);
for i = 1:N
    lut(i,3) = (round(255/2^c)*mod(floor(i-1),2^c))+round(255/2^(c+1));
    lut(i,2) = (round(255/2^b)*mod(floor((i-1)/(2^c)),2^b))+round(255/2^(b+1));
    lut(i,1) = (round(255/2^a)*mod(floor((i-1)/(2^(b+c))),2^a))+round(255/2^(a+1));
end

%% TP-2

%% TP-3

I1 = double(rgb2gray(imread('TP02I01.jpg')));
I2 = double(rgb2gray(imread('TP02I02.jpg')));

%do_dct(I1);
%do_dct(I2);

%do_compress(I1, 50);
%do_compress(I2, 50);

qfs = zeros(1, 100);
stats = zeros(1, 100);

for i = 1:100
    qfs(i) = i;
    
    I_c = compress(I1, qfs(i));
    stats(i) = mean_squared_error(I1, I_c);
end

figure,
plot(qfs, stats), xlabel('Qf'), ylabel('MSE'), title('Evolution of MSE depending on Qf');

function do_compress(I, Qf)
    I_c = compress(I, Qf);

    mse = mean_squared_error(I, I_c);

    figure,
    subplot(1,2,1), imshow(uint8(I)), title('Before');
    subplot(1,2,2), imshow(uint8(I_c)), title(sprintf('After\nQf = %d\nMSE = %d', Qf, mse));
end

function [I_c] = compress(I, Qf)
    [r, c] = size(I);
    Q = zeros(8, 8);
    
    for i = 0:7
        for j = 0:7
            Q(i + 1, j + 1) = 1 + (1 + i + j) * Qf;
        end
    end
    
    DCT = dct(I);
    
    for i = 0:8:r-1
        for j = 0:8:c-1
            for u = 0:7
                for v = 0:7
                    DCT(i + u + 1, j + v + 1) = DCT(i + u + 1, j + v + 1) / Q(u + 1, v + 1);
                end
            end
        end
    end
    
    DCT = round(DCT);
    I_c = idct(DCT, Q);
end

function do_dct(I)
    DCT = dct(I - 128);

    IDCT = idct(DCT);
    IDCT = IDCT + 128;

    figure,
    subplot(2,2,1), imagesc(log(abs(DCT) + 1)), title('DCT');
    subplot(2,2,3), imshow(uint8(I)), title('Before');
    subplot(2,2,4), imshow(uint8(IDCT)), title('After');
end


function [I] = idct(DCT, Q)
    [r, c] = size(DCT);
    I = zeros(size(DCT));
    
    for i = 0:8:r-1
        for j = 0:8:c-1
            for x = 0:7
                for y = 0:7

                    dct_sum = 0;
                    for u = 0:7
                        for v = 0:7
                            du = 1;
                            if u == 0
                                du = 1 / sqrt(2);
                            end

                            dv = 1;
                            if v == 0
                                dv = 1 / sqrt(2);
                            end

                            if nargin == 1
                                dct_sum = dct_sum + du * dv * cos(((2 * x + 1) * u * pi) / 16) * cos(((2 * y + 1) * v * pi) / 16) * DCT(i + u + 1, j + v + 1);
                            else
                                dct_sum = dct_sum + du * dv * cos(((2 * x + 1) * u * pi) / 16) * cos(((2 * y + 1) * v * pi) / 16) * DCT(i + u + 1, j + v + 1) * Q(u + 1, v + 1);
                            end
                        end
                    end

                    I(i + x + 1, j + y + 1) = (1 / 4) * dct_sum;
                end
            end
        end
    end
end

function [DCT] = dct(I)
    [r, c] = size(I);
    DCT = zeros(size(I));
    
    for i = 0:8:r-1
        for j = 0:8:c-1
            for u = 0:7
                for v = 0:7

                    dct_sum = 0;

                    cu = 1;
                    if u == 0
                        cu = 1 / sqrt(2);
                    end

                    cv = 1;
                    if v == 0
                        cv = 1 / sqrt(2);
                    end

                    for x = 0:7
                        for y = 0:7
                            dct_sum = dct_sum + cos(((2 * x + 1) * u * pi) / 16) * cos(((2 * y + 1) * v * pi) / 16) * I(i + x + 1, j + y + 1);
                        end
                    end

                    DCT(i + u + 1, j + v + 1) = ((cu * cv) / 4) * dct_sum;
                end
            end
        end
    end
    
end

% Computes the Mean Squared Error between two signals x and y.
% This assumes x and y have the same size
function mse = mean_squared_error(x, y)
    mse = sum((x(:) - y(:)).^2) / numel(x);
end


