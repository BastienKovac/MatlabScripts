function img=invwavelet(imw,ordre)
s=size(imw);
img=imw;
imcopie=imw;
largeur=s(1)/(2^ordre);
i=1;
while (i <= ordre)
    for j=1:largeur
        for k=1:largeur
            a=imcopie(j,k);
            b=imcopie(j+largeur,k);
            c=imcopie(j,k+largeur);
            d=imcopie(j+largeur,k+largeur);
            img((j-1)*2+1,(k-1)*2+1)=(a+b+c+d);
            img(j*2,(k-1)*2+1)=((a+b)-(c+d));
            img((j-1)*2+1,k*2)=((a+c)-(b+d));
            img(j*2,k*2)=((a-b)-(c-d));
        end
    end
    i=i+1;
    largeur=largeur*2;
    imcopie=img;
end