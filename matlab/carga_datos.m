function [P_obs, R, R_eventos, V_time, M_cobertura] = carga_datos(archivo, ...
                                                                  fecha_ini, ...
                                                                  fecha_end, ...
                                                                  cuentas_rayos)
% CARGA_DATOS
%
% [P_obs, R, R_eventos, V_time, M_cobertura] = carga_datos(archivo, fecha_ini, fecha_end, cuentas_rayos)
%
% Abre el archivo "archivo" en formato TSV (liga a definici?n del formato tsv), 
% desde la fecha inicial fecha_ini a la fecha final fecha_end 
%
% cuenta_rayos (por default 'gauss' es el tipo de rayos en grid utilizado
% donde 'gauss' significa gaussianos y 'discretos' es simplemente la cuenta
% de rayos en un grid por periodo de tiempo.
%
% fecha_ini y fecha_end son las fechas inicial y final en formato [a?o,
% mes, d?a, hora, minuto, segundo, decima de segundo], si es un string o no
% vienen, entonces se asume toda la temporada.
%
%Devuelve:
%
%           P_obs(latitudes, longitudes, fecha_ini_inc:fecha_end) la
%           precipitaci?n observada por grid y por instante de tiempo desde
%           la fecha inicial a la final (o a las mas cercanas si se salen
%           del periodo que comprende el archivo.
%
%           R(latitudes, longitudes, fecha_ini:fecha_end) el acumulado de
%           rayos en un periodo de tiempo de acuerdo al archivo de datos.
%           Si cuentas_rayos = 'gauss' devuelve el resultado con datos
%           gausianos, si cuentas_rayos='discretos' devuelve las sumas
%           discretas de los rayos por grid.
%
%           R_eventos arreglo de estructuras donde R_eventos[t].data es una
%           matriz de nt por 2, donde se encuentra la latitu y longitud de
%           cada rayo que ocurrio en el instante de tiempo t
%           correspondiente al peri?do entre V_time(t) y V_time(t+1).
%
%           V_time vector de periodos de tiempo desde max(fecha inicial del
%           archivo, fecha_ini) hasta min(fecha final del archivo,
%           fecha_end), con incrementos definidos por el incremento del
%           archivo.
%
%           M_cobertura(latitudes,longitudes) matriz con los niveles de
%           cobertura (0,1,2, etc), de acuerdo a la cobertura del radar y
%           de los pluviometros.
%

% Derechos reservados
% Julio Waissman Vilanova y Carlos Minjarez Sosa, 2011


load(archivo, '-mat'); 
if nargin < 4, cuentas_rayos = 'gauss', end;
if nargin < 2, fecha_ini = 'toda la temporada', end;

% Convierte las fechas en forma numerica
if ~ischar(fecha_ini)
    fn0 = datenum(fecha_ini);
    fnT = datenum(fecha_end);

    % Encuentra los indices iniciales y finales
    i0 = find(vt >= fn0,1);
    iT = find(vt <= fnT,1,'last');

    % Guarda el conjunto de datos de precipitaci?n
    P_obs = dtsPcTotal(i0:iT,:,:);

    % Guarda lo mismo pero de los rayos
    if strcmp(cuentas_rayos, 'gauss')
       R = DatosRayosEventos(i0:iT,:,:);
    elseif strcmp(cuentas_rayos,'discretos')
       R = RayosDiscretos(i0:iT,:,:);
    else
       error('Solo puede tomar los valores "gauss" o "discretos"');
    end
    
    V_time = vt(i0:iT);
    
else
    % Guarda el conjunto de datos de precipitaci?n
    P_obs = dtsPcTotal;
    
    i0 = 1;
    iT = size(dtsPcTotal,1);

    % Guarda lo mismo pero de los rayos
    if strcmp(cuentas_rayos, 'gauss')
       R = DatosRayosEventos;
    elseif strcmp(cuentas_rayos,'discretos')
       R = RayosDiscretos;
    else
       error('Solo puede tomar los valores "gauss" o "discretos"');
    end
    
    V_time = vt;
    
end

P_obs(isnan(P_obs)) = 0; % Eliminating Precipitation NaN's 
M_cobertura = MatrizCobertura;

% Genera una estructura que por cada instante de tiempo guarde el conjunto
% de rayos que cayeron colocando su posici?n en lat y long.
%vtrayos = datenum(MatrizRayos(:,1:6));
%rayos_todos = MatrizRayo(:,7:8)
vtrayos = MatrizRayos(:,1);
rayos_todos = MatrizRayos(:,2:3);

for i = i0:min(iT,length(vt)-1)
    inds = find(vtrayos>=vt(i) & vtrayos<vt(i+1));
    R_eventos(i-i0+1).data = rayos_todos(inds,:);
end
    


end

                          