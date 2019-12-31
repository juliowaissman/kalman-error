%% Script de ejemplo de uso de todos los programas juntos


%Limpiamos todo y cerramos todo
clear all
close all
clc

tic %a medir el tiempo que tarda en correo el programita

%% Especificando parametros para abrir el archivo y paras poder generar el modelo STI el modelo posteriormente 
Zona     = 2;
Res      = 5;
Time_res = 60;
D        = 0;
Cov      = 2500;
Nivel    = 1;
Ano      = 2009;


%Fecha de uno de los eventos
fecha_0  = 'Nada'; %[Ano, 09, 09, 16, 00, 0];%'Nada';%
fecha_T  = 'Nada'; %[Ano, 09, 10, 05, 00, 0];%'Nada';%

% definimos este n para poder graficar las series de tiempo como dia del
% a?o
if Ano == 2009
      n = datenum('1-Jan-2009', 'dd-mmm-yyyy')
elseif Ano == 2010
    n = datenum('1-Jan-2010', 'dd-mmm-yyyy')
end

vecinos = 1;
lag = [0,0,0,0,1,0,0,0,0];


path_data = 'datachida/'; % La Ruta para jalar el archivo


%% Matriz de cobertura

% Como no tengo grabada la matriz de cobertura para 5 Km lo que hice fue 
% simplemente cargar un archivo de tucson (KEMX, region 1)conresolucion espacial de 5Km
% para tomar su matriz de cobertura y usarla en el denial, despues borro
% las variables que que no me sirven, igual como no necesito todos los  
% tiempos escojo un periodo corto

load cobertura_denial

% Generando las matrices de cobertura, MCV1 es la matriz de cobertura
% verdadera de Tucson
MCV1 = max(0, min(1, MC));

% MCV2 es la matriz de cobertura falsa de Tucson i.e.
% decir que esta cubuerto donde no esta cubierti y viceversa.
MCV2 = 1-MCV1;

% MCV3 Cobertura real del KMAF, es decir todo cubierto
MCV3 = ones(size(MC)); 

% Limpiamos todos lo datos que ya no nos sirven.
clear temp*

%% Cargamos archivo de la serie de tiempo y definimos las matrices de cobertura
nombre = genera_nombre(Zona, Res, Time_res, D, Cov, Nivel, Ano);
%path_data1 = 'E:\KMAF2010TS\'; % ruta para jalar los datos de KMAF


% Obtiene los datos a partir del archivo 
[P_obs, R,  R_eventos, V_time, MC] = carga_datos([path_data, nombre,'.tsv'], fecha_0, fecha_T, 'gauss');

% Definimos las mascaras convectivas, es este caso,
% lluvia_convectiva_denial simplemente toma los rayos para el tiempo actual
% y no considera lags

mascaraCV1 = lluvia_convectiva_final( R , MCV1, lag, vecinos,0.5);
mascaraCV2 = lluvia_convectiva_final( R , MCV2, lag, vecinos,0.5);
mascaraCV3 = lluvia_convectiva_final( R , MCV3, lag, vecinos,0.5);


% Una vez defindos las m?scaras sacamos los modelos del evento con las
% diferente coberturas

modeloCV1 = STI_model(P_obs, R, mascaraCV1, vecinos, lag ); 

% Estimamos precipitacion con el modeloCV1  despues se usa la funcion
% suma_especial para calular la lluvia acumuada en todo el dominio
P_est_CV1 = STI_sim( modeloCV1, R, vecinos, lag );

P_alldomain_CV1 = suma_especial(P_est_CV1, mascaraCV3, P_est_CV1);


% Calculamos la precipitacion convectiva para todo el dominio y la se pone 
% P_obs (toda la precipitacion observada por cada grid a cada tiempo)
% mascaraCV# porque queremos que estime en todo el dominio sin importar la
% cobertura y P_est_CV1 que seria lo que nos daria el caracte de convectico
% ya que sumaria solamente en los grids donde hubo estimacion en P_est_CV1
Pconv_alldomain = suma_especial(P_obs, mascaraCV3, P_est_CV1);

% Ahora calculamos la precipitacion total, no habr?a necesidad porque
% simplemente se podr?a hacer sumando todo P_obs pero no quiero sumar los
% gris perifericos ya que en las estimaciones descartamos esos grids, por
% lo tanto, para efectos de comparacion entre lo estimado y lo observado
% tenemos que comparar exatamente los grids estimados y observados. Por eso
% tomamos una matriz de puros unos para la mascara y consieamos P_ons como
% primer parametro, el terer parametro nos lo pide la funcion pero creo que
% para este caso no se utiliza.
Pobs_alldomain  = suma_especial(P_obs, ones(size(mascaraCV3)), P_est_CV1);

% De la misma forma que para CV1 obtenemos el modeloCV2
modeloCV2 = STI_model(P_obs, R, mascaraCV2, vecinos, lag );

% Se estima la precipitacion para el modeloCV2 
P_est_CV2 = STI_sim( modeloCV2, R, vecinos, lag );
P_alldomain_CV2 = suma_especial(P_est_CV2, mascaraCV3, P_est_CV2);

% Igual para el modeloCV3, no tengo que decir mucho mas al respecto
modeloCV3 = STI_model(P_obs, R, mascaraCV3, vecinos, lag ); 
P_est_CV3 = STI_sim( modeloCV3, R, vecinos, lag );
P_alldomain_CV3 = suma_especial(P_est_CV3, mascaraCV3, P_est_CV3);

Rayos = [suma_especial(R, mascaraCV1, P_est_CV1),...
         suma_especial(R, mascaraCV3, P_est_CV1)];

%% Graficado De variables
% las ponemos todas en una sola matriz nomas para minimizar codigo
precip = [ Pobs_alldomain, ...
           Pconv_alldomain, ...
           P_alldomain_CV1, ...
           P_alldomain_CV2, ...
           P_alldomain_CV3];

% NOMAS VOY A PLANTEAR EL PROBLEMA CON UNA DE LAS GR?FICAS Y UNO DE LOS
% MAPAS, PARA LOS DEM?S SER?A LO MISMO.
% En la figura primera hago una suma cucumulada de cada una de las
% variables de precipitacion, obtenidas arriba y que est?n puestas en la
% matriz precip, se entiende que, dada una variable, por ejemplo,
% P_alldomain_CV1 el valor final de la suma acumulada de esta ser{ia la
% precipitaci?n total de todo el dominio de toda la temporada. Hata aqui
% todo esta bien. ahora nos pasamos a la linea 180 donde se grafican los
% mapas.
%%
% figure()
% plot((V_time-n),Pconv_alldomain,'.b-')
% xlabel(' D a y    o f    Y e a r ','FontSize',...
%        14,'FontName','arial')
% ylabel('Total Accumulated Precipitation (mm)','FontSize',...
%        14,'FontName','arial')
%    title({['KMAF ',num2str(Ano),'1.0 Ltg Thrs'];['5 Km, 60 Min. 2 spatial NB']},'FontSize',...
%        14,'FontName','arial')
% 
% figure()
% plot((V_time-n),Rayos(:,2),'r.-')
% xlabel(' D a y    o f    Y e a r ','FontSize',...
%        14,'FontName','arial')
% ylabel('Total Accumulated Gaussian Counts','FontSize',...
%        14,'FontName','arial')
%    title({['KMAF ',num2str(Ano),'1.0 Ltg Thrs'];['5 Km, 60 Min. 2 spatial NB']},'FontSize',...
%        14,'FontName','arial')

%%
% figure()
% imagesc(reshape(modeloCV1(1:25),5,5))
% figure()
% imagesc(reshape(modeloCV2(1:25),5,5))
% figure()
% imagesc(reshape(modeloCV3(1:25),5,5))

%% Figuras de series de tiempo.
figure()
plot((V_time-n),cumsum(precip),'.-')
legend('P_{obs}','P_{obs-conv}','P_{est} CV1 cov', 'P_{est} CV2 cov','P_{est} CV3 cov' )
title({['KMAF ',num2str(Ano),' Time Series Comparison'];['5 Km, 60 Min. 2 spatial NB']},'FontSize',...
       14,'FontName','arial')
% title({['KMAF ',num2str(Ano),' Time Series Comparison'];['5 Km, 60 Min. 2 spatial NB'];...
%     ['Isolated Storms Case']},'FontSize',...
%        14,'FontName','arial')

xlabel(' D a y    o f    Y e a r ','FontSize',...
       14,'FontName','arial')
ylabel('Total Accumulated Precipitation (mm)','FontSize',...
       14,'FontName','arial')

figure()
plot((V_time-n),precip,'o-')
legend('P_{obs}','P_{obs-conv}','P_{est} CV1 cov', 'P_{est} CV2 cov','P_{est} CV3 cov' )
title({['KMAF ',num2str(Ano),' Time Series Comparison'];['5 Km, 60 Min. 2 spatial NB']},'FontSize',...
       14,'FontName','arial')
% title({['KMAF ',num2str(Ano),' Time Series Comparison'];['5 Km, 60 Min. 2 spatial NB'];...
%        ['Isolated Storms Case']},'FontSize',...
%        14,'FontName','arial')
xlabel('D a y    o f    Y e a r ','FontSize', 14,'FontName','arial')
ylabel('Total Accumulated Precipitation (mm)','FontSize',14,'FontName','arial')
   


figure()
plot((V_time-n),cumsum(Rayos),'*-')
legend('CG Gauss in Tus Cov. Domain','Total CG Gauss')
% % title({['KMAF ',num2str(Ano),' Time Series Comparison'];...
% %     ['5 Km, 60 Min. 2 spatial NB']},'FontSize',14,'FontName','arial')
% title({['KMAF ',num2str(Ano),' Time Series Comparison'];...
%        ['5 Km, 60 Min. 2 spatial NB'];...
%        ['Isolated Storms Case']},'FontSize',14,'FontName','arial')
xlabel('D a y    o f    Y e a r','FontSize',14,'FontName','arial')
ylabel('Total Accumulated Gaussian Counts','FontSize',14,'FontName','arial')

figure()
plot((V_time-n),Rayos,'+-')
legend('CG Gauss in Tus Cov. Domain','Total CG Gauss')
title({['KMAF ',num2str(Ano),' Time Series Comparison'];...
    ['5 Km, 60 Min. 2 spatial NB']},'FontSize',14,'FontName','arial')
% title({['KMAF ',num2str(Ano),' Time Series Comparison'];...
%        ['5 Km, 60 Min. 2 spatial NB'];...
%        ['Isolated Storms Case']},'FontSize',14,'FontName','arial')
xlabel('D a y    o f    Y e a r','FontSize',14,'FontName','arial')
ylabel('Total Gaussian Counts','FontSize',14,'FontName','arial')


%% MAPAS
% Para la misma variable que planteabamos arriba, sumamos la precipitaci?n
% estimada por toda la temporada por cada grid. Nosotros suponemos que si
% hicieramos triple suma de P_est_CV1 esta nos tendr?a que dar exactamente
% el ?ltimo valor de la suma acumulada de P_alldomain_CV1 es decir
% (sum(P_alldomain_CV1) ), sin embargo en el caso del mapa esta suma sale
% mucho mayor. Es aqu? donde digo que creo que creo que para el caso de los
% mapas, estoy sumando mas grids de lo que debo.

P1 = suma_especial_matriz(P_est_CV1, ones(size(mascaraCV1)), P_est_CV1);
P2 = suma_especial_matriz(P_est_CV2, ones(size(mascaraCV1)), P_est_CV2);
P3 = suma_especial_matriz(P_est_CV3, ones(size(mascaraCV1)), P_est_CV3);
P_convec = suma_especial_matriz(P_obs,ones(size(mascaraCV3)), P_est_CV1);
P_obs_totmtx = suma_especial_matriz(P_obs, ones(size(mascaraCV1)), P_est_CV3);

maxP = 1.1*max([max(max(P1)),max(max(P2)),max(max(P3)),max(max(P_convec))]);
minP = 0.9*min([min(min(P1)),min(min(P2)),min(min(P3)),min(min(P_convec))]);
rangoP = [minP, maxP];
rangoP = [200, 600];
titulo = 'Total Seasonal Precipitation CV1';
mapa_region(P1(3:end-2,3:end-2), [], MCV1, titulo, rangoP, Res);

titulo = 'Total Seasonal Precipitation CV2';
mapa_region(P2, [], MCV1, titulo, rangoP, Res);

titulo = 'Total Seasonal Precipitation CV3';
mapa_region(P3, [], MCV1, titulo, rangoP, Res);

titulo = 'Total Seasonal Convective Precipitation';
mapa_region(P_convec, [], MCV1, titulo, rangoP, Res);

normdiff = (P_convec - P3)./P_convec
titulo = 'Error Map (Pconv - PCV3)/Pconv';
mapa_region(normdiff, [], MCV1, titulo, [0 0.5], Res);
close all

errores_CV1 = criterio_nuevo(P_obs, P_est_CV1,mascaraCV3);
errores_CV2 = criterio_nuevo(P_obs, P_est_CV2,mascaraCV3);
errores_CV3 = criterio_nuevo(P_obs, P_est_CV3,mascaraCV3);

RR= corr(reshape(P_convec,30*21,1),reshape(P3,30*21,1));

diffCV1 = (P_convec-P1);
diffCV2 = (P_convec-P2);
diffCV3 = (P_convec-P3);
errores_1p0 = [errores_CV1 errores_CV2 errores_CV3; RR RR RR]

diffs_1p0 = [diffCV1(:) diffCV2(:) diffCV3(:)];
diffs_1p0 = [diffCV1(32:end-31)' diffCV2(32:end-31)' diffCV3(32:end-31)'];
% save('parametros_1p0','diffs_1p0','errores_1p0')
% figure()
% boxplot(diffCV1(31:end-31))
% title('Box Plot for P_convective PCV1')


% disp(sum(P_alldomain_CV1))
% disp(sum(sum(P1)))
% disp(sum(P_alldomain_CV2))
% disp(sum(sum(P2)))
% disp(sum(P_alldomain_CV3))
% disp(sum(sum(P3)))
% disp(sum(sum(P_convec)))
toc


