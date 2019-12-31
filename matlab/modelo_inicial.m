
clear all
close all
clc

% Path to get the data
path_data = 'datachida/';

% Specification of the file to load
Zona     = 1;
Res      = 5;
Time_res = 5;
D        = 0;
Cov      = 1500;
Nivel    = 1;
Ano      = 2009;

% Name of the File
nombre = genera_nombre(Zona, Res, Time_res, D, Cov, Nivel, Ano);

% Fixing time imputs, in this case all the season.
fecha_0  = 'Nada';%[Ano, 05, 04, 20, 00, 0]; %('Nada' implica toda la temporada
fecha_T  = 'Nada';%[Ano, 11, 06, 06, 00, 0];


% Loading the data
[P_obs, R,  R_eventos, V_time, MC] = carga_datos([path_data,nombre,'.tsv'], fecha_0, fecha_T, 'gauss');


%Coverage matrix, we put ones in the covered grids and zero in the non
%covered grids
MC = min(1, MC);                

% In case that we do not care about sensor coverage (this case)
MC = ones(size(MC));

% We define the what we consider convective preciitation following some
% stablished crterium. If we want to modify this criterium we have to
% modify lluvia_convectiva function. The mask is a tridimentional matrix of
% the same size than R (lightning data), similar than coverage matrix, one
% means that we have convective precip at a given gris a a given time, and
% zero if the opposite.
mascara = lluvia_convectiva( R, MC );

% comment he line below tif we want to consider convective precipitation
% mascara = ones(size(mascara));



%% Obtaining a model for the data

% time lag. The time lag is the time steeps (past and firther) that will be 
% considered to get the model where t is the actual time. These lags have
% the form:
%
%  [t-4 t-3, t-2, t-1, t, t+1, t+2, t+3 t+4]
%

lag = [1,1,1,1,1,1,0,0,0];


% Stpatial neighbors: Similar to the lags criterium we have also spatial
% neighbors which is the number of grids around the actual gris (i,j) that
% will be considered for the model, in this case for one spatial neighbors,
% we expect to have 9 grids where the grid (i,j) is the one located in the
% center.

vecinos = 2;

% Modeling Function (Seasonal)
modelo = STI_model(P_obs, R, mascara, vecinos, lag );
