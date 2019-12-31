%% Inicializa el script


%% Obtiene los datos para ser usados por el modelado
tic

% Sirve para especificar cual archivo sacar
Zona     = 1;
Res      = 5;
Time_res = 5;
D        = 0;
Cov      = 1500;
Nivel    = 1;
Ano      = 2009;

% Nombre del archivo
nombre = genera_nombre(Zona, Res, Time_res, D, Cov, Nivel, Ano);


% Vecinos temporales
lag =   [0,0,0,0,1,0,0,0,0;...
         0,0,0,1,1,1,0,0,0;...
         0,0,1,1,1,1,1,0,0;...
         0,1,1,1,1,1,1,1,0;...
         1,1,1,1,1,1,1,1,1;...
         0,0,0,1,1,0,0,0,0;...
         0,0,1,1,1,0,0,0,0;...
         0,1,1,1,1,0,0,0,0;...
         1,1,1,1,1,0,0,0,0;...
         1,1,1,1,1,1,0,0,0;...
         ];

% Vecinos espaciales
vecinos = [0,1,2,3];

Verr_rms = zeros(size(lag,1),length(vecinos));
Vcorr = zeros(size(lag,1),length(vecinos));
Vperc = zeros(size(lag,1),length(vecinos));

for i = 1:size(lag,1)
     for j = 1:length(vecinos)


         nm = ['resultados/resultadosSTI',nombre,'_',int2str(vecinos(j)),'vecinos_',...
                strrep(int2str(lag(i,:)),' ',''),'lag'];
         load(nm);
         Verr_rms(i,j) = e1(1);
         Vcorr(i,j) = e1(2) + 0.1;
         Vperc(i,j) = e1(3);

     end
end

[m nada]= size(lag);
n = length(vecinos);

figure(1)
[x y] = meshgrid(1:n,1:m);
hold on

figure(2)



plot3(x,y,Vcorr,'*-'); grid on
hold on

set(gca,'XTick',[1,2,3,4])
set(gca,'XTickLabel',{0,1,2,3})
set(gca,'YTickLabel',{'000010000','000111000','001111100','011111110','111111111','000110000','001110000',...
                      '0111100000','111110000','111111000'})
                  
title('KEMX 2009: RMS Error, 5Km 5 Min, Ltg before case')
xlabel('Spatial Neighbors')
ylabel('Time lags situation')