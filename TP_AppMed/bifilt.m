function B = bifilt(A,w,sigma_d,sigma_r)
% Pre-compute Gaussian distance weights.
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));


% Apply bilateral filter.
dim = size(A);
B = zeros(dim);
for i = 1:dim(1)
   for j = 1:dim(2)
      
         % Extraire la region de l'image à filtrer.
         iMin = max(i - w, 1);
         iMax = min(i + w, dim(1));
         jMin = max(j - w, 1);
         jMax = min(j + w, dim(2));
         I = A(iMin:iMax,jMin:jMax);
      
         % Calculer les poids gaussiens en fonction de l'intensité des pixels de la region par rapport au pixel considéré.
         H = exp(-double(I - A(i, j)).^2 / (2 * sigma_r));
      
         % Calcul de la réponse du filtre bilatéral
         F = H.*G((iMin:iMax) - i + w + 1, (jMin:jMax) - j + w + 1);
             
         % Application du filtre normalisé 
         B(i,j) = sum(F(:).*I(:))/sum(F(:));
               
   end
end