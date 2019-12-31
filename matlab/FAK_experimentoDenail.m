%% FAK_experimento3.m
%
% Using Texas data to simulate with the kalman filter with error correction.
%
% Save the data and then thinking in the plotting problem

close all
clear all
pack
clc
tic
%% Load the Texas data for all the seasson, 5 min. 10 km grids

% De donde saca los datos
path_data = 'datachida/';

% Specification of the file to load
Zona     = 2;
Res      = 5;
Time_res = 60;
D        = 0;
Cov      = 2500;  %??????????????????????????????????????????????????
Nivel    = 1;
Ano      = 2009;

% Nombre del archivo
nombre = genera_nombre(Zona, Res, Time_res, D, Cov, Nivel, Ano);

% Fechas, de entrada todas.
fecha_0  = 'Nada';%[Ano, 05, 04, 20, 00, 0]; %('Nada' implica toda la temporada
fecha_T  = 'Nada';%[Ano, 11, 06, 06, 00, 0];


% La funci?n para cargar los datos
[P_obs, R,  R_eventos, V_time, MC] = carga_datos([path_data,nombre,'.tsv'], fecha_0, fecha_T, 'gauss');

%MC = ones(size(MC));
load cobertura_denial
% Generando las matrices de cobertura, MCV1 es la matriz de cobertura
% verdadera de Tucson

 MCV1 = max(0, min(1, MC));

% MCV2 es la matriz de cobertura falsa de Tucson i.e.
% decir que esta cubuerto donde no esta cubierti y viceversa.

%  MCV1 = 1-MC;

% MCV3 Cobertura real del KMAF, es decir todo cubierto
%  MCV1 = ones(size(MC)); 



lag = [0,0,0,0,1,0,0,0,0];
vecinos = 2;
mascaraCV1 = lluvia_convectiva_final( R , MCV1, lag, vecinos,0.5);
% Seassonal model
modelo = STI_model(P_obs, R, mascaraCV1, vecinos, lag );
P_est = STI_sim( modelo, R, vecinos, lag );

% %% Kalman filter 

Qk = 0.00001*eye(length(modelo));
MCred = MCV1(3:end-2, 3:end-2);
Rk = 1*eye(numel(MCred(MCred==1)));
Pk = 1000*eye(length(modelo));
alphak = 1;

[P_e1, modelos]  = STI_sim_kalman2( modelo, R, P_obs, vecinos, lag, MCV1, ones(size(mascaraCV1)), Qk, Rk, Pk, alphak );

[P_err1, modelos_temp]  = STI_sim_kalman_err( modelo, R, P_obs - P_est, vecinos, lag, MCV1, ones(size(mascaraCV1)), Qk, Rk, Pk, 10000000 );

P_ec1 = P_est + P_err1;



save FAK3datos_denialMCV1.mat
toc

