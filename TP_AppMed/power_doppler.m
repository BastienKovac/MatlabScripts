function [h,logPWTD,PWTD1]=Dopplerplot(X) 
   
    [Nz,Nx,Nt] = size(X);   
    espace_xx=1:Nx;
    espace_zz=1:Nz;
   
    figure(); 
    set(gcf,'Color',[1,1,1]);
    colormap hot                                                    ;      Amp = 35                                                        ;    PW = 1/Nt*sum(abs(X).^2,3)                                ;
    PWTD = PW/max(max(PW))                                          ;    PWTD1=max(PWTD,10^(-Amp/10));
    logPWTD = 10*log10(max(PWTD,10^(-Amp/10)))                      ;  
        h = imagesc(logPWTD(:,:),[-Amp,0])      ;
        xlabel('N_X [nb]')                                  ; 
        ylabel('N_Z [nb]')                                  ; 
        set(gca,'XTick', 1:40:espace_xx(end));
        set(gca,'YTick', 1:100:espace_zz(end));       
 
    set(gca, 'FontSize', 18, 'fontName','Arial','LineWidth',1.5)    ;    
   
        colorbar                                                      ;        caxis([-Amp 0]);
    drawnow              ;


end
