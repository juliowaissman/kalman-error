function entrada = selecciona_rayos(a, b, Rayos, vecinos)
% SELECCIONA_RAYOS
%
% entrada = selecciona_rayos(i, j, Rayos, vecinos)
%
% Requiere de una matriz tridimensional Rayos, tal que
% Rayos(i,j,:) es el vector de rayos ocurridos en el grid
% i,j desde el tiempo inicial al tiempo final. 
%
% devuelve una matris entrada([c1, c2, ..., cN], :) tal que c_k es una
% columna con todos los valores de un grid tal que este sea vecino del grid
% i,j. 
% 
% La cantidad de vecinos se determina con la variable vecinos. Si vecinos =
% -1, entonces se utilizan todos los datos completos. En caso que vecinos
% sea 0, solamente se toman los valores del grid i,j. En otro caso (vecinos
% = L% se toman todos los vecinos tal que la distancia de manhatan entre el
% vecino y el valor i,j sea menor a igual a L.

% Julio Waissman Vilanova y Carlos Minjarez Sosa, 2011

I = size(Rayos,2);
J = size(Rayos,3);

if vecinos == -1
    Ry = reshape(Rayos, [size(Rayos,1), I*J]);
    
elseif vecinos == 0
    Ray = Rayos(:,a,b);
    Ry = reshape(Ray, [size(Ray,1), 1]); 
    
else
    mx = max(1,a-vecinos);
    Mx = min(I,a+vecinos);
    my = max(1,b-vecinos);
    My = min(J,b+vecinos);
    Ray = Rayos(:, mx:Mx, my:My);
    Ry = reshape(Ray, [size(Ray,1), (Mx-mx+1)*(My-my+1)]); 
end

entrada = Ry(1:end,:);
