clear all
close all
clc


load FAK3datos_denialMCV1.mat
clear Ano Cov D MC MCV1 MCred Nivel Pk Qk R R_envetos Res Rk Time_res ...
      V-time Zona alphak fecha_0 fecha_T lag mascaraCV1 modelo modelos ...
      nombre path_data vecinos 

P_e1_CV1  = P_e1; clear P_e1  
P_ec1_CV1 = P_ec1; clear P_ec1
P_est_CV1 = P_est; clear P_est


load FAK3datos_denialMCV2.mat
clear Ano Cov D MC MCV1 MCred Nivel Pk Qk R R_envetos Res Rk Time_res ...
      V-time Zona alphak fecha_0 fecha_T lag mascaraCV1 modelo modelos ...
      nombre path_data vecinos 

P_e1_CV2  = P_e1; clear P_e1  
P_ec1_CV2 = P_ec1; clear P_ec1
P_est_CV2 = P_est; clear P_est  
  
load FAK3datos_denialMCV3.mat

P_e1_CV3  = P_e1;  clear P_e1  
P_ec1_CV3 = P_ec1; clear P_ec1
P_est_CV3 = P_est; clear P_est


POacc = suma_especial(P_obs, ones(size(mascaraCV1)), P_est_CV3);
PEacc_kalman_CV1 = suma_especial(P_e1_CV1, ones(size(mascaraCV1)), P_est_CV3);
PEacc_kalman_CV3 = suma_especial(P_e1_CV3, ones(size(mascaraCV1)), P_est_CV3);
P_STI_est_CV3 = suma_especial(P_est_CV3,mascaraCV1,P_est_CV3);
PEL = suma_especial(P_obs,mascaraCV1,P_est_CV3)

PEacc_kalman_EC_CV1 = suma_especial(P_ec1_CV1, ones(size(mascaraCV1)), P_est_CV3);
PEacc_kalman_EC_CV3 = suma_especial(P_ec1_CV3, mascaraCV1, P_est_CV3);

tiempo = V_time - datenum(2009,1,1);
% Racc = suma_especial(R, mascara, P_est);
% 
% POtot = suma_especial(P_obs, ones(size(mascara)), P_est);
% PEtot = suma_especial(P_est, ones(size(mascara)), P_est);
% PKtot = suma_especial(Pe0, ones(size(mascara)), P_est);
% Rtot = suma_especial(R, ones(size(mascara)), ones(size(P_est)));


 figure()
% subplot(2,1,1)
plot(tiempo, cumsum(POacc),'r', tiempo, cumsum(PEL),'b',...
    tiempo, cumsum(PEacc_kalman_CV3),'c',tiempo,cumsum(P_STI_est_CV3),'m')
title({['KMAF ',num2str(Ano),'Denial Kalman Evaluation'];['5 Km, 60 Min. 2 spatial NB']},'FontSize',...
       14,'FontName','arial');
xlabel('D a y   o f   Y e a r (2009)','FontSize',...
       14,'FontName','arial');
ylabel('Accumulated Precip.','FontSize',...
       14,'FontName','arial');
legend('Observed','PEL','Kalman CV3','STI');
break

figure()
% subplot(2,1,1)
plot(tiempo, cumsum(POacc),'r', tiempo, cumsum(PEacc_kalman_EC_CV1),'b', tiempo, cumsum(PEacc_kalman_EC_CV3),'m')
title({['KMAF ',num2str(Ano),'Denial Kalman Evaluation'];['5 Km, 60 Min. 2 spatial NB']},'FontSize',...
       14,'FontName','arial');
xlabel('D a y   o f   Y e a r (2009)','FontSize',...
       14,'FontName','arial');
ylabel('Accumulated Precip.','FontSize',...
       14,'FontName','arial');
legend('Observed','Kalman CV1','Kalman CV3');

% break
% figure()
% plot(tiempo, cumsum(POacc),'r', tiempo, cumsum(PEacc_kalman_CV1),'b', tiempo, cumsum(PEacc_kalman_EC_CV1),'m')
% title(['Denial Kalman Evaluation']);
% xlabel('DOY (2009)');
% ylabel('accumulated precip. (mm)');
% legend('Observed','Kalman CV1','Kalman CV3');

Pe1_CV1  = suma_especial_matriz(P_e1_CV1, ones(size(mascaraCV1)), P_est_CV1);
Pec1_CV1 = suma_especial_matriz(P_ec1_CV1, ones(size(mascaraCV1)), P_est_CV1);
Pe1_CV3  = suma_especial_matriz(P_e1_CV3, ones(size(mascaraCV1)), P_est_CV3);
Pec1_CV3 = suma_especial_matriz(P_ec1_CV3, ones(size(mascaraCV1)), P_est_CV3);
P_obs_totmtx = suma_especial_matriz(P_obs, ones(size(mascaraCV1)), P_est_CV3);
R_totmtx = suma_especial_matriz(R,ones(size(mascaraCV1)),P_est_CV3)

maxP = 1.1*max([max(max(Pe1_CV1)),max(max(Pec1_CV1)),max(max(Pec1_CV3))])%,max(max(P_obs_totmtx))]);
minP = 0.9*min([min(min(Pe1_CV1)),min(min(Pec1_CV1)),min(min(Pec1_CV3)),min(min(P_obs_totmtx))]);
% rangoP = [minP, maxP];
rangoP = [200, 600];


titulo = 'KMAF2009 Total Seasonal Gaussian Lightning';
% [f, hp1, hp2, hr1, hr2] = mapa_region(squeeze(Po(i0,3:end-2,3:end-2)), ...
%                                 squeeze(Pe(i0,3:end-2,3:end-2)), ...
%                                 R(i0).data, MC, titulo, maxP, resolucion);
mapa_region(R_totmtx(3:end-2,3:end-2),[], MC(3:end-2,3:end-2), titulo, rangoP, Res);

titulo = 'KMAF2009 Total Seasonal Precipitation Kalman CV1 (No Err Correction)';
% [f, hp1, hp2, hr1, hr2] = mapa_region(squeeze(Po(i0,3:end-2,3:end-2)), ...
%                                 squeeze(Pe(i0,3:end-2,3:end-2)), ...
%                                 R(i0).data, MC, titulo, maxP, resolucion);
mapa_region(Pec1_CV1(3:end-2,3:end-2),[], MC(3:end-2,3:end-2), titulo, rangoP, Res);

titulo = 'KMAF2009 Total Seasonal Precipitation Kalman CV1 (w. Err Correction)'
mapa_region(Pec1_CV1(3:end-2,3:end-2), [], MC(3:end-2,3:end-2), titulo, rangoP, Res);

titulo = 'KMAF2009 Total Seasonal Precipitation Kalman CV3 (No Err Correction)';
mapa_region(Pe1_CV3(3:end-2,3:end-2), [], MC(3:end-2,3:end-2), titulo, rangoP, Res);

titulo = 'KMAF2009 Total Seasonal Precipitation Kalman CV3 (w. Err Correction)';
mapa_region(Pec1_CV3(3:end-2,3:end-2), [], MC(3:end-2,3:end-2), titulo, rangoP, Res);

titulo = 'KMAF2009 Total Observed Seasonal Precipitation';
mapa_region(P_obs_totmtx(3:end-2,3:end-2), [], MC(3:end-2,3:end-2), titulo, rangoP, Res);

normdiff = (P_convec - P3)./P_convec
titulo = 'Error Map (Pconv - PCV3)/Pconv';
mapa_region(normdiff(3:end-2,3:end-2), [], MC(3:end-2,3:end-2), titulo, [0 0.5], Res);
close all