function modelo = STI_model2(P_obs, R, mascara, vecinos, lag)
                                                                                                       
% Obtiene el numero de cuadros en latitud y longitud
I = size(P_obs,2);
J = size(P_obs,3);

%Obtiene el numero de vecinos que deben de ser
necesarios = (1+2*vecinos)^2;

% Realiza el modelado coordenada por coordenada de precipitacion
% solo si hay cobertura 
salida =  zeros(size(P_obs,1), 1); %Variable loca para mantener el formato

Y = [];
X = [];

M = squeeze(sum(mascara,1));
for i = 1:I           % latitudes
    for j = 1:J        % longitudes
        if M(i,j) > 0   % mascara de criterio para lluvia convectiva

            % Obtiene los rayos correspondientes a los vecinos
            entrada = selecciona_rayos(i, j, R, vecinos);
            if size(entrada,2) < necesarios
                continue
            end
            
            % Obtiene la precipitacion de la coordenada y elimina los NaNs
            salida(:,1) = P_obs(1:end,i,j);
            s = salida(5:end-4);
            
            % Se genera la matriz respecto al grado
            e = [];
            for k = 1:9
                if lag(k) > 0
                    e = [e, entrada(k:end-9+k,:)];
                end
            end

            % Se obtienen los indices deseados
            ind = find( mascara(5:end-4,i,j)>0 );

            % Y las matrices para ajuste
            if isempty(Y)                
                Y = s(ind);
                X = e(ind,:);
            else
                Y = [Y; s(ind)];
                X = [X; e(ind,:)];
            end    
        end
    end
end

X = [X, ones(size(X,1),1)];

% Y aqui cualquier metodo de ajuste lineal existente
modelo = pinv(X)*Y; %Moore-Penrose pseudoinverse of matrix (minimos cuadrados)




