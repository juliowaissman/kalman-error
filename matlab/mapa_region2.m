function [fig, hp1, hp2, hr1, hr2]  = mapa_region(Po, Pe, R, MC, titulo, rangoP, resolucion)


if nargin < 5, rangoP = [0,60]; end
if nargin < 4, titulo = 'Precipitacion'; end
if nargin < 3, MC = []; end
if nargin < 2, R = []; end

if length(rangoP) == 1, rangoP = [0, rangoP]; end

%% Carga informaci?n geoespacial y prepara los grids para graficar

% Direccion de la informaci?n geoespacial
% rutadted = '/Users/juliowaissman/Documents/06 Proyectos/2010 proyecto lluvia convectiva/SAERP/SAERP/Anexos/NIMA';  %ruta de la carpeta NIMA
rutadted = 'C:\Users\Owner\Desktop\Desktop\Melina\Utilerias\NIMA';
% rutadted = 'C:\Users\cminjarez\Desktop\NIMA';
%Tamano de grid de archivos fuente.
DeltaOriginal = 0.01*resolucion;

% Limites de latitud y longitus a sacar el mapa topogr?fico
LimitesLatitud = [31 + 2*DeltaOriginal, 32.47 - 2*DeltaOriginal];
LimitesLongitud = [-103 + 2*DeltaOriginal, -102 - 2*DeltaOriginal];%[-111.46 -110.46];

% Obtiene el mapa topografico en un formato para poderlo graficar
[Z, VectorRef] = dted( rutadted, 1, LimitesLatitud, LimitesLongitud); %Definimos contorno de mapa.
[ lat, lon ] = meshgrat( Z, VectorRef );

%Obtiene un mapa de colores personalizado 
% load '/Users/juliowaissman/Documents/06 Proyectos/2010 proyecto lluvia convectiva/Melina/Utilerias/PaletaColorPrecipitacion2.mat' 
load 'C:\Users\Owner\Desktop\Desktop\Melina\Utilerias\PaletaColorPrecipitacion2.mat'
% load 'C:\Users\cminjarez\Desktop\Melina\Utilerias\PaletaColorPrecipitacion2.mat'
% load PaletaColorPrecipitacion.mat
[ x, y ] = meshgrid( LimitesLongitud(1): DeltaOriginal : LimitesLongitud(2) + DeltaOriginal, ...
                     LimitesLatitud(1) : DeltaOriginal : LimitesLatitud(2) + DeltaOriginal );
x = x( 1 : end - 1, 1 : end - 1 );
y = y( 1 : end - 1, 1 : end - 1 );

%% Prepara la grafica al gusto

fig = figure( 'Position', [0 0 1000 600], ...
              'Color', 'w', ...
              'Name', 'Precipitation Map', ...
              'NumberTitle', 'off',...
              'Toolbar', 'none', ...
              'Visible', 'on',...
              'Resize', 'on' );
          
%% Grafica la precipitacion

subplot(1,2,1)
Po(Po<0) = 0; % Elimina los que se marcan como no estimados         
hp1 = pcolor( x, y, Po );
title('Observed Precipitation (mm)','Fontsize',14)
colormap( PaletaColorPrecipitacion );
colorbar;
shading flat
axis equal tight
grid off

set(gca,'CLim',rangoP);

% title(titulo, 'Fontsize',16);

hold on


subplot(1,2,2)
Pe(Pe<0) = 0; % Elimina los que se marcan como no estimados  
hp2 = pcolor( x, y, Pe );
title('Estimated Precipitation (mm)','Fontsize',14)
colormap( PaletaColorPrecipitacion );
colorbar;
shading flat
axis equal tight
grid off

set(gca,'CLim',rangoP);



hold on


%% Grafica la cobertura

subplot(1,2,1)
if ~isempty(MC)
    size(MC)
    for i = 1:size(MC,2)-1
        for j = 1:size(MC,1)-1
            if MC(j,i) == 0
                line([x(1,i),x(1,i+1)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i+1),x(1,i)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i),x(1,i)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i+1),x(1,i+1)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i),x(1,i+1)],[y(j,1),y(j,1)],'linewidth', 0.5);
                line([x(1,i),x(1,i+1)],[y(j+1,1),y(j+1,1)],'linewidth', 0.5);
                %fill([x(1,i),x(1,i),x(1,i+1),x(1,i+1)],...
                %     [y(j,1),y(j+1,1),y(j+1,1),y(j,1)],[0.5,0.5,0.5]);
            end
        end
    end
end



subplot(1,2,2)
if ~isempty(MC)
    size(MC)
    for i = 1:size(MC,2)-1
        for j = 1:size(MC,1)-1
            if MC(j,i) == 0
                line([x(1,i),x(1,i+1)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i+1),x(1,i)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i),x(1,i)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i+1),x(1,i+1)],[y(j,1),y(j+1,1)],'linewidth', 0.5);
                line([x(1,i),x(1,i+1)],[y(j,1),y(j,1)],'linewidth', 0.5);
                line([x(1,i),x(1,i+1)],[y(j+1,1),y(j+1,1)],'linewidth', 0.5);
                %fill([x(1,i),x(1,i),x(1,i+1),x(1,i+1)],...
                %     [y(j,1),y(j+1,1),y(j+1,1),y(j,1)],[0.5,0.5,0.5]);
            end
        end
    end
end


%% Grafica la topograf?a

subplot(1,2,1)
contour( lon, lat, Z, 'Color',[0.5,0.5,0.5] )

subplot(1,2,2)
contour( lon, lat, Z, 'Color',[0.5,0.5,0.5] )

%% contorno para poner la linea divisor?a en Arizona y Sonora
% -------------------------------------------------------------
%alabamahi = shaperead('usastatehi.shp', 'UseGeoCoords', true, 'Selector',{@( name ) strcmpi( name, 'Arizona' ), 'Name'});
%lonF = extractfield( alabamahi, 'Lon' )'; 
%latF = extractfield( alabamahi, 'Lat' )';
%plot( lonF, latF, '-k','linewidth', 3)
   

%% Grafica los eventos de rayos ocurridos en un periodo de tiempo

if R
    subplot(1,2,1)
    hr1 = plot(R(:,2),R(:,1),'.k');
    subplot(1,2,2)
    hr2 = plot(R(:,2),R(:,1),'.k');
else
    subplot(1,2,1)
    hr1 = plot(LimitesLongitud,LimitesLatitud,'.k');
    set(hr1,'XData',[], 'YData', []);
    drawnow;
    subplot(1,2,2)
    hr2 = plot(LimitesLongitud,LimitesLatitud,'.k');
    set(hr1,'XData',[], 'YData', []);
    drawnow;
end



