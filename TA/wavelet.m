function imw = wavelet(img,ordre)

s=size(img);
imw=double(zeros(s));
imcopie=img;
largeur=s(1)/2;
i=1;
while (i <= ordre) & (largeur >= 1)
    for j=1:largeur
        for k=1:largeur
            a = double(imcopie((j-1)*2+1,(k-1)*2+1));
            b = double(imcopie(j*2,(k-1)*2+1));
            c = double(imcopie((j-1)*2+1,k*2));
            d = double(imcopie(j*2,k*2));
            imw(j,k)=(a+b+c+d)/4;
            imw(j+largeur,k)=((a+b)-(c+d))/4;
            imw(j,k+largeur)=((a+c)-(b+d))/4;
            imw(j+largeur,k+largeur)=((a-b)-(c-d))/4;
%             imw(j+largeur,k)=(-(a+b)+(c+d))/4;
%             imw(j,k+largeur)=(-(a+c)+(b+d))/4;
%             imw(j+largeur,k+largeur)=(-(b-a)+(d-c))/4;
        end
    end
    i=i+1;
    largeur=largeur/2;
    imcopie=imw;
end