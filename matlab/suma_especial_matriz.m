function y = suma_especial_matriz(x, mascara, p)
% SUMA_ESPECIAL Suma adaptada al problema de estimacion de la precipitacion
%
%   y = suma_especial(x, mascara, p)
%
% x, mascara y p son matrices de dimension (T, I, J), donde x es la
% variable que se suma, mascara es la mascara que indica lluvia convectiva
% y p es la precipitacion estimada, para evitar sumar donde no hubo
% estimacion (valor negativo).
%
% Devuelve y de dimension [T, 1] donde y(i) es la suma de los valores de
% x(i,:,:) tal que p(i,a,b) sea mayor que 0 y mascara(i,a,b) sea 1.

y = zeros(size(x,2),size(x,3));
for i = 1:size(x,2)
    for j = 1:size(x,3)
        temp = squeeze(x(:,i,j) .* mascara(:,i,j));
        precip = squeeze(p(:,i,j));
        y(i,j) = sum(temp(precip>=0));
    end
end

    