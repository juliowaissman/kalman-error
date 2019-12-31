function [P_est, modelos] = STI_sim_kalman_err( modelo, R, P_obs, vecinos, lag, MC,  mascara, Qk, Rk, Pk, alphak )

% Obtiene el numero de cuadros en latitud y longitud
T = size(R,1);
I = size(R,2);
J = size(R,3);

% Prueba de inicializacion de Pk
Pk_ini = Pk;

%modelo_ini = modelo;
modelos = zeros(length(modelo), T);
modelos(:,1) = modelo(:);

%Obtiene el numero de vecinos que deben de ser
necesarios = (1+2*vecinos)^2;
                      
% Genrra una matriz de precipitacion estimada
P_est = -1*ones( size( R ) );


% Matriz H de coberturas
MC_red = MC(3:end-2,3:end-2);
H = diag(MC_red(:));
H = H(sum(H,2)>0,:);

% La identidad del tamanyo de Pk, solo por facilitar la lectura
UNO = eye(size(Pk));

tau = 0;

for t = 5:T-4

    Lt = ones((I-4)*(J-4), necesarios*sum(lag) + 1);
    casilla = 1;    
    for j = 3:J-2
        for i = 3:I-2

            % Obtiene los rayos correspondientes a los vecinos
            entrada = selecciona_rayos(i, j, R(t-4:t+4,:,:), vecinos);
            
            % Se genera la matriz respecto al grado
            e = zeros(1,sum(lag)*necesarios);
            acc = 0;
            for k = 1:9
                if lag(k) > 0
                    e(acc*necesarios+1:(acc+1)*necesarios) =  entrada(k,:);
                    acc = acc + 1;
                end
            end
            Lt(casilla,:) = [e, 1];
            casilla = casilla + 1;
        end
    end
    
    
    if sum(sum(sum(mascara(t-3:t+1, :, :)))) == 0
        modelo = modelo * (exp(-tau*alphak));
        tau = tau + 1;
        if tau == 4
            Pk = Pk_ini;
        end
    else  
        tau = 0;
        
        % Calcula la salida
        Y_est = Lt * modelo; %max(0, Lt * modelo);

        % Aqui empiezan las ecuaciones del Kalman propiamente
        Pk = Pk + Qk;
        C = H*Lt;
        K = (Pk*C')/(C*Pk*C' + Rk);
        Pk = (UNO - K*C)*Pk;

        % Esta parte del error hacemos unas modificaciones macabronas
        Y = squeeze(P_obs(t,3:end-2,3:end-2));
        E = Y(:) - Y_est;
        E = H*E;

        % Actualiza el valor del modelo
        modelo = modelo + K*E;

    end
    
    modelos(:,t) = modelo(:);
    
    % Calcula la salida con el modelo corregido
    Y_est = Lt * modelo; %max(0, Lt * modelo);
    
    % Lo guarda
    P_est(t,3:end-2,3:end-2) = reshape(Y_est,I-4,J-4);
    P_est(t,:,:) = P_est(t,:,:);
end
