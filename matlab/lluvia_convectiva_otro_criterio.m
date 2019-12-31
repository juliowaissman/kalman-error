function mascara = lluvia_convectiva_otro_criterio( rayos, MC )
% LLUVIA_CONVECTIVA Encuentra una m?scara para lluvia convectiva
%
% mascara = lluvia_convectiva( rayos )
%
% mascara es una matriz tridimensional (T, N, M) de mismas dimensiones que
% la matriz rayos, donde mascara(t,i,j) = 1 si es un grid convectivo o
% mascara(y, i, j) = 0 si no lo es.

% Mijarez & Waissman, 2012

if nargin<2
    MC = ones(size(rayos,2), size(rayos,3));
end

mascara = zeros(size(rayos));
MC = max(1, min(0, MC));
T = size(rayos,1);

for t = 1:T
    for i = 1:size(mascara,2)
        for j = 1:size(mascara,3)
            if ( rayos(t, i, j) >= 1 || ...
                 rayos(max(1,t-1), i, j) >= 1 || ...
                 rayos(max(1,t-2), i, j) >= 1 || ...
                 rayos(max(1,t-3), i, j) >= 1 || ...
                 rayos(min(T,t+1), i, j) >= 1 || ...
                 rayos(min(T,t+2), i, j) >= 1 || ...
                 rayos(min(T,t+3), i, j) >= 1)
                
                mascara(t,i,j) = 1*MC(i,j);
            end
        end
    end
end

