% Specify meteorite conductivities

k_iron = 30.;
k_chon = 3.;

% Specify different gammas to be used
gamma_a = 3.;
gamma_b = 9.;
gamma_c = 15.;

% Specify how long to run the code
years = 30;

%FUNCTION CALLS FOR THE ANTARCTIC SIMULATION

% Simulations comparing iron and chondrites for various gammas
ca = ANTARCTICA(years,k_chon,gamma_a,2); % chondrite, low gamma
ia = ANTARCTICA(years,k_iron,gamma_a,2); % iron, low gamma
ib = ANTARCTICA(years,k_iron,gamma_b,2); % iron, medium gamma 
cb = ANTARCTICA(years,k_chon,gamma_b,2); % chondrite, medium gamma
ic = ANTARCTICA(years,k_iron,gamma_c,2); % iron, high gamma 
cc = ANTARCTICA(years,k_chon,gamma_c,2); % chondrite, low gamma

% Simulation comparing iron meteorites of different sizes
two = ANTARCTICA(years,k_iron,gamma_a,2); % 2cm
four = ANTARCTICA(years,k_iron,gamma_a,4); % 4cm
ate = ANTARCTICA(years,k_iron,gamma_a,8); % 8 cm
sixt = ANTARCTICA(years,k_iron,gamma_a,16); %16 cm

z = zeros(years);surface = linspace(1,years,years); % Specify a vector to represent the ice surface
w = 1.5;
%first figure for meteorite sizes 
figure;
plot(two.time,two.b,'-k',four.time,four.b,'-k',ate.time,ate.b,'-k',sixt.time,sixt.b,'-k',surface,z,'--k','LineWidth',w);
title('Trajectories for iron meteorites of various sizes');
xlabel('Time (years)'); ylabel('Depth (metres)');
ylim([-1.5 0.1]);
annotation('textarrow',[0.1,0.15],[0.9,0.85],'String','Surface');
annotation('textarrow',[0.3,0.35],[0.7,0.65],'String','16 cm');
annotation('textarrow',[0.4,0.45],[0.6,0.55],'String','8 cm');
annotation('textarrow',[0.5,0.55],[0.5,0.45],'String','4 cm');
annotation('textarrow',[0.7,0.75],[0.3,0.25],'String','2 cm');


%figure for case "A" - low gamma

figure;
plot(ca.time,ca.b,'-k',ia.time,ia.b,'-k',surface,z,'--k','LineWidth',w);
title(['Trajectories for iron and chondrite meteorites, \gamma of ',num2str(gamma_a)]);
xlabel('Time (years)'); ylabel('Depth (metres)');
ylim([-1.5 0.1]);
annotation('textarrow',[0.1,0.15],[0.9,0.85],'String','Surface');
annotation('textarrow',[0.3,0.35],[0.7,0.65],'String','Chondrite');
annotation('textarrow',[0.4,0.45],[0.6,0.55],'String','Iron');

%figure for case "B" - medium gamma
figure;
plot(cb.time,cb.b,'-k',ib.time,ib.b,'-k',surface,z,'--k','LineWidth',w);
title(['Trajectories for iron and chondrite meteorites, \gamma of ',num2str(gamma_b)]);
xlabel('Time (years)'); ylabel('Depth (metres)');
ylim([-1.5 0.1]);
annotation('textarrow',[0.1,0.15],[0.9,0.85],'String','Surface');
annotation('textarrow',[0.3,0.35],[0.7,0.65],'String','Chondrite');
annotation('textarrow',[0.4,0.45],[0.6,0.55],'String','Iron');

%figure for case "C" - high gamma
figure;
plot(cc.time,cc.b,'-k',ic.time,ic.b,'-k',surface,z,'--k','LineWidth',w);
title(['Trajectories for iron and chondrite meteorites, \gamma of ',num2str(gamma_c)]);
xlabel('Time (years)'); ylabel('Depth (metres)');
ylim([-1.5 0.1]);
annotation('textarrow',[0.1,0.15],[0.9,0.85],'String','Surface');
annotation('textarrow',[0.3,0.35],[0.7,0.65],'String','Chondrite');
annotation('textarrow',[0.4,0.45],[0.6,0.55],'String','Iron');


