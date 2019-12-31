function e = criterios_analisis(p_obs, p_est, mascara, minPest, minPobs)
% CRITERIOS_ANALISIS Criterios de error sobre precipitaci'on
%
% e = criterios_analisis(p_obs, p_est, mascara, minPest, minPobs)
%
% calcula el criterio de error entre p_obs y p_est 'unicamente donde 
% mascara(t,i,j) = 1 y existe al menos minPest de precipitaci'on estimada
% en cada grid y cada tiempo y minPobs de precipitacion observada en cada
% grid y en cada tiempo. Por default la mascara tiene puros 1.
%
% minPest es el m'inimo que se considera para precipitaci'on estimada, por
% default 4.67
%
% minPobs es el m'inimo valor considerado como precipitaci'on observada,
% por default se considera 10.20. 
%
% e es un vector en donde:
%        e[1]: Raiz cuadrada de la suma de los cuadrados del error entre
%              el n?mero de elementos considerados convectivos.
%        e[2]: Correlaci?n entre p_obs y p_est en los valores considerados 
%              convectivos sin importar si hay lluvia o no. 
%        e[3]: Percentil 90 de el absoluto de los errores entre p_est y p_obs 
%              en los grids convectivos.
%        e[4]: Porcentaje de lluvia explicada, para esto solo se consideran
%              los grids donde la mascara es 1 y existe precipitaci?n estimada.
%

%
% Julio Waissman y Carlos Minjarez 2013

e = zeros(4,1);

po0 = p_obs(mascara == 1 & p_est >= 0);
po = p_obs( p_est >= 4.67 & p_obs > 10.20);
pe = p_est( p_est >= 4.67 & p_obs > 10.20);

e(1) = sqrt(sum((po - pe).^2))/numel(po);
[e(2), dummy] = corr( po, pe );
e(3) = prctile( abs(po - pe) ,90);
e(4) = sum(po0)/sum(p_obs(p_est >= 0));


