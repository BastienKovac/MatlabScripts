function diff_im = anisodiff2D(im, num_iter, lambda, k, option)
%ANISODIFF2D Conventional anisotropic diffusion
% DIFF_IM = ANISODIFF2D(IM, NUM_ITER, LAMBDA, K, OPTION) perfoms
% conventional anisotropic diffusion (Perona & Malik) upon a gray scale
% image. 
%
% ARGUMENT DESCRIPTION:
% IM - gray scale image (MxN).
% NUM_ITER - number of iterations.
% LAMBDA - integration constant.
% K - gradient modulus threshold that controls the conduction.
% OPTION - conduction coefficient functions proposed by Perona & Malik:
% 1 - c(x,y,t) = exp(-(nablaI/k).^2),
% privileges high-contrast edges over low-contrast ones.
% 2 - c(x,y,t) = 1./(1 + (nablaI/k).^2),
% privileges wide regions over smaller ones.
%
% OUTPUT DESCRIPTION:
% DIFF_IM - (diffused) image with the largest scale-space parameter.
%
% Example
% -------------
% s = phantom(512) + randn(512);
% num_iter = 15;
% lambda = 1/7;
% k = 30;
% option = 2;
% ad = anisodiff2D(s,num_iter,lambda,k,option);

% References:
% P. Perona and J. Malik.
% Scale-Space and Edge Detection Using Anisotropic Diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence,
% 12(7):629-639, July 1990.
%
% G. Grieg, O. Kubler, R. Kikinis, and F. A. Jolesz.
% Nonlinear Anisotropic Filtering of MRI Data.
% IEEE Transactions on Medical Imaging,
% 11(2):221-232, June 1992.
%
% MATLAB implementation based on Peter Kovesi's anisodiff(.):
% P. D. Kovesi. MATLAB and Octave Functions for Computer Vision and Image Processing.
% School of Computer Science & Software Engineering,
% The University of Western Australia.
%
% Credits:
% Daniel Simoes Lopes
% ICIST
% Instituto Superior Tecnico - Universidade Tecnica de Lisboa
% danlopes (at) civil ist utl pt
% http://www.civil.ist.utl.pt/~danlopes
%
% May 2007 original version.

% Convert input image to double.
im = double(im);

% Condition initiale
diff_im = im;

% Masques pour le calcul des gradients.
hN = [0 1 0; 0 -1 0; 0 0 0];
hS = [0 0 0; 0 -1 0; 0 1 0];
hE = ...
hW = ...

% Anisotropic diffusion.
for t = 1:num_iter

% Calcul des gradients par convolution, utilisr conv2 avec l'option 'conv'.
nablaN = ...
nablaS = ...
nablaW = ...
nablaE = ...

% Expression du coefficient de diffusion.
if option == 1
cN = exp(-(nablaN/k).^2);
cS = exp(-(nablaS/k).^2);
cW = exp(-(nablaW/k).^2);
cE = exp(-(nablaE/k).^2);

elseif option == 2
cN = 1./(1 + (nablaN/k).^2);
cS = 1./(1 + (nablaS/k).^2);
cW = 1./(1 + (nablaW/k).^2);
cE = 1./(1 + (nablaE/k).^2);

% Mise à jour de la solution itérative
diff_im = ...

end

end