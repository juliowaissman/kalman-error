function [fig, hp, hr]  = mapa_region(P, R, MC, titulo, rangoP, resolucion)


if nargin < 5, rangoP = [0,60]; end
if nargin < 4, titulo = 'Precipitacion'; end
if nargin < 3, MC = []; end
if nargin < 2, R = []; end

if length(rangoP) == 1, rangoP = [0, rangoP]; end

% C:\Users\Owner\Desktop\Desktop\Melina\Utilerias
%   rutadted = 'C:\Users\Owner\Desktop\Desktop\Melina\Utilerias\NIMA';%para

% laptop
%  rutadted = 'C:\Users\cminjarez\Desktop\NIMA';  %ruta de la carpeta NIMA para servidor
rutadted = '/Users/juliowaissman/Documents/06 Proyectos/2010 proyecto lluvia convectiva/SAERP/SAERP/Anexos/NIMA';  %ruta de la carpeta NIMA


%Tamano de grid de archivos fuente.
DeltaOriginal = 0.01*resolucion;

LimitesLatitud = [31 + 2*DeltaOriginal, 32.47 - 2*DeltaOriginal];
LimitesLongitud = [-103 + 2*DeltaOriginal, -102 - 2*DeltaOriginal];%[-111.46 -110.46];

[Z, VectorRef] = dted( rutadted, 1, LimitesLatitud, LimitesLongitud); %Definimos contorno de mapa.
[ lat, lon ] = meshgrat( Z, VectorRef );

% %Latitud de archivos fuente.
% LatitudAOriginal = LimitesLatitud(1); 
% LatitudBOriginal = LimitesLatitud(2);
% 
% %Longitud de archivos fuente.
% LongitudAOriginal = LimitesLongitud(1); 
% LongitudBOriginal = LimitesLongitud(2);

[ x, y ] = meshgrid( LimitesLongitud(1): DeltaOriginal : LimitesLongitud(2) + DeltaOriginal, ...
                     LimitesLatitud(1) : DeltaOriginal : LimitesLatitud(2) + DeltaOriginal );
x = x( 1 : end, 1 : end );
y = y( 1 : end, 1 : end );

% [ x, y ] = meshgrid( LongitudAOriginal: DeltaOriginal : LongitudBOriginal + DeltaOriginal, ...
%                      LatitudAOriginal : DeltaOriginal : LatitudBOriginal + DeltaOriginal );
% x = x( 1 : end - 1, 1 : end - 1 );
% y = y( 1 : end - 1, 1 : end - 1 );

%contorno
alabamahi = shaperead('usastatehi.shp', 'UseGeoCoords', true, 'Selector',{@( name ) strcmpi( name, 'Arizona' ), 'Name'});
lonF = extractfield( alabamahi, 'Lon' )'; 
latF = extractfield( alabamahi, 'Lat' )';

%Mapa de colores ajustado 
%  load 'C:\Users\Owner\Desktop\Desktop\Melina\Utilerias\PaletaColorPrecipitacion2.mat'
load '/Users/juliowaissman/Documents/06 Proyectos/2010 proyecto lluvia convectiva/Melina/Utilerias/PaletaColorPrecipitacion2.mat' 
%Mapa de colores ajustado para el server
% load 'C:\Users\cminjarez\Desktop\Melina\Utilerias\PaletaColorPrecipitacion2.mat'


fig = figure( 'Position', [0 0 1000 1000], ...
              'Color', 'w', ...
              'Name', 'Precipitation Map', ...
              'NumberTitle', 'off',...
              'Toolbar', 'none', ...
              'Visible', 'on',...
              'Resize', 'on' );

          
          
P(P<0) = 0;
size(P)
P = [P, zeros(size(P,1),1)];
size(P)
P = [P; zeros(1, size(P,2))];
size(P)
size(x)
size(y)
hp = pcolor( x, y, P );
colormap( PaletaColorPrecipitacion );
colorbar;
shading flat
axis equal tight
grid off

set(gca,'CLim',rangoP);
                    
hold on

if ~isempty(MC)
    size(MC)
    for i = 1:size(MC,2)
        for j = 1:size(MC,1)
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

contour( lon, lat, Z, 'Color',[0.5,0.5,0.5] )
plot( lonF, latF, '-k','linewidth', 3)
          
if R
    hr = plot(R(:,2),R(:,1),'.k');
else
    hr = plot(LimitesLongitud,LimitesLatitud,'.k');
    set(hr,'XData',[], 'YData', []);
    drawnow;
end

title(titulo);
