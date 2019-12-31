function nombre = genera_nombre(
                      zona, ...
                      resolucion,...
                      periodo,...
                      desplazamiento,...
                      cobertura,...
                      nivel_cobertura,...
                      ano)
% GENERA_NOMBRE genera el nombre del archivo a abrir
%
% nombre = genera_nombre(zona, res, time , D, cob, ncob, ano)
%
% Genera el nombre del archivo tsv  en el que se encuentran los datos necesarios
% para encontrar el modelo.
%
% Esta funci'on se utiliza siempre en conjunto con la funci'on carga_datos Por
% ejemplo, para cargar los datos de toda la temporada se puede hacer:
%
% [Pobs, R, R_ev, VT, MC] = carga_datos([path, genera_nombre(zona, ...
% resolucion,... periodo,... desplazamiento,... cobertura,...
% nivel_cobertura,... ano)]);
%

% Julio Waissman Vilanova y Carlos Minjarez Sosa, 2011

if zona == 1
    nn = 'KEMX_';
elseif zona==2
    nn = 'KMAF_';

else
    error('Todavia no definimos otra zona');
end

sr = int2str(resolucion);

nombre = [nn, sr,'KM_',...
          int2str(periodo),'M_',int2str(desplazamiento),'D_',...
          int2str(cobertura),'Cov_',int2str(nivel_cobertura),'Nivel_',...
          int2str(ano)];
end
