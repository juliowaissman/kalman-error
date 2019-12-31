function mascara = lluvia_convectiva_final( rayos, MC, lag, vecinos, min_val)
% LLUVIA_CONVECTIVA_FINAL Encuentra una m'ascara para lluvia convectiva
%
% mascara = lluvia_convectiva( rayos, MC, lag, vecinos )
%
% mascara es una matriz tridimensional (T, N, M) de mismas dimensiones que
% la matriz rayos, donde mascara(t,i,j) = 1 si es un grid convectivo o
% mascara(y, i, j) = 0 si no lo es.

% Minjarez & Waissman, 2012


mascara = zeros(size(rayos));
MC = max(0, min(1, MC));
T = size(rayos,1);
X = size(rayos,2);
Y = size(rayos,3);

for t = 5:T-4
    for i = 1:X
        for j = 1:Y
            if (i - vecinos >= 1) && (i + vecinos <= X) && ...
               (j - vecinos >= 1) && (j + vecinos <= Y) && ...
               sum(sum(sum(rayos(t-4 : t+4,...
                                 i-vecinos : i+vecinos,... 
                                 j-vecinos : j+vecinos), 2), 3) .* lag') >= min_val
               mascara(t,i,j) = 1*MC(i,j);
            end
        end
    end
end

end









