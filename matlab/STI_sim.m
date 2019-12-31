function P_est = STI_sim( modelo, R, vecinos, lag )

% Obtiene el numero de cuadros en latitud y longitud
I = size(R,2);
J = size(R,3);

%Obtiene el numero de vecinos que deben de ser
necesarios = (1+2*vecinos)^2;
                      
% Genrra una matriz de precipitacion estimada
P_est = -1*ones( size( R ) );

for i = 1:I
    for j = 1:J
        % Obtiene los rayos correspondientes a los vecinos
        entrada = selecciona_rayos(i, j, R, vecinos);
        if size( entrada, 2 ) < necesarios
            continue
        end

        % Se genera la matriz respecto al grado
        e = [];
        for k = 1:9
            if lag(k) > 0
                e = [e, entrada(k:end-9+k,:)];
            end
        end
        e = [e, ones(size(e,1),1)];

        Y_est = max( 0, e * modelo );
        P_est( 5:end-4, i, j ) = Y_est;
    end
end



