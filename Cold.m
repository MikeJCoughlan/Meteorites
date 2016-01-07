%% This function reads the number of years of the simulation, the conductivity of the meteorite,
%% the attenuation coefficient of blue ice and the size of the meteorite IN CENTIMETRES

%% The function outputs depth and velocity of the meteorite as a function of time.
function [OUT]= COLD(Years,Cond,gamma,size)

%%%%%% Read the altitudes file and store as a vector%%%%%%%%%

angles = dlmread('altitudes.csv',',');

%%%%%% Allocate array for all output vectors %%%%%%%%%%%%
m = 8760*Years;
A=zeros(m,8);

%%%%%%% Meteorite Conductivity %%%%%%%%%%%%%
k_d = Cond;

%%%%%%%% Meteorite Size (converting to cm) %%%%%%%%%%
w = size/100.;

%%%%%%%% Incoming Maximum Solar radiation %%%%%%%%%%%%
S_in = 340;

 delta = 0.001; % Attenuation coefficient for water %
      
 T_inf = -30.; % Temperature at bottom of glacier %

 z_inf = 10.; % Depth at bottom of glacier %
 
 k_w = 0.58; % Conductivity of water %
    
 k_i = 2.18; % Conductivity of ice %

 a1 = 0.56; % Blue ice albedo %
    
 a2 = 0.1; % Meteorite Albedo %
	
 bb = 0.98*5.667e-8; % coefficient for the T^4 law, \sigma \epsilon %
	
 rho = 916.2; % Density of ice %
    
 L_m = 3.34e5; % Latent heat of melting of ice %
 
 heave = 0.08/(365.0*24.0*3600.0); % rate of ice lift, metres per second
   
 wind = 11; % Wind speed %
   
 H = 1.29*1005*(0.1^2)/wind; % Heat transfer coefficient
 
 T_a_in = -30.; % Most extreme air temperature %
	
 h = H + bb*4*(273.^3.);	% Coefficient of air temperature T_a in SEB %
 
%//*********** LOOP START AND INITIAL CONDITIONS******************//
dt = 120.; t = 0; 
initial = 0.6;	a = initial;	b = initial;	a_i = initial;	b_i = initial;
%//*********** Initiation *******************************************/

%YEAR LOOP
    wait = waitbar(0,'Please wait...'); 
	 for n = 1:Years %Loops around whole process 30 times
		%//HOUR BY HOUR LOOP FOR EACH YEAR
		for i=1:8760 
			%//30 SECOND LOOP FOR EACH HOUR (IMPORTANT FOR PRECISION)
			for j=1:30
				water = b-a; % size of water layer
                
S = S_in*(1-a1)*(1-a2)*sin(angles(i)); % incoming radiation dependent on solar angle
S_net = S_in*(1-a1)*sin(angles(i)); % incoming radiation hitting meteorite dependent on solar angle and albedos
T_a = T_a_in*(1-sin(angles(i))); % air temperature dependent on solar angle
Q_long = 80 + 90*sin(angles(i)); % longwave radiation dependent on solar angle, with minimum accounting for clouds

Q = Q_long - bb*(273.^4.) + H*T_a +  S_net*(1-exp(-gamma*a - delta*water)) + S_net*a2*exp(-gamma*a - delta*water);
T_s = (a*Q)/(k_i + h*a); % Surface temperature
Phi = (T_inf - T_s) / (z_inf-b-w); % Temperature gradient in glacier

a_dot = (1./(rho*L_m))*(-(S*w*k_w*(exp(-gamma*a - delta*water))./(w*k_w + water*k_d)) - (k_i*Q./(k_i+h*a)));
b_dot = (1./(rho*L_m))*(((water*k_d*S*(exp(-gamma*a - delta*water)))./(w*k_w + water*k_d)) + (k_i*Phi));
a_dot_0 = (1/(rho*L_m))*(-S*(exp(-gamma*a - delta*water))  -k_i*Phi - (k_i*Q./(k_i+h*a))); % a_dot for when the meteorite can't sink

%case where meteorite can't sink, but water layer can develop

if (b_dot <= 0.0)
    b_i = b; 
    a_i = a + dt*a_dot_0;
end

%case where meteorite can sink, water layer already exists
if (b_dot >0.0) && (water > 0.0) 
    a_i = a + dt*a_dot - dt*heave; % water layer grows
    b_i = b + dt*b_dot - dt*heave; % meteorite sinks
    
end

%if the new water depth is negative or zero, meteorite and (ghost) water
%layer rise with ice. This accounts for the case where there isn't even
%enough energy to melt ice above the meteorite.

water = b_i-a_i;
if (water <= 0.0)
    a_i = a - dt*heave;
	b_i = b - dt*heave;
end

            t = t + dt; % increment counters
			a = a_i;	% reallocate calculated depths
			b = b_i;
              
            if (a_i <= 0.0) || (b_i <= 0.0) 
		%		a_i = 0.0; a = 0.0; Removing these lines makes the code cut
		%		out once the meteorites reach the surface.
         %       b_i = 0.0; b = 0.0;
                break;
            end
            
            end
                
            
			if (a_i <= 0.0) || (b_i <= 0.0) 
		%		a_i = 0.0; a = 0.0;
         %       b_i = 0.0; b = 0.0;
                break;
            end
           
			%WRITE TO ARRAY
			c = i+ (n-1)*8760;
            A(c,1) = t./(365*24*60*60); %time (years)
            A(c,2) = -b_i; % meteorite depth
            A(c,3) = water; % water layer size
            A(c,4) = b_dot; % meteorite velocity
            A(c,5) = T_s; % surface temperature
            A(c,6) = Q;% Surface energy balance (Temperature gradient in top ice)
            A(c,7) = S;
            A(c,8) = Q_long;
         %   A(c,7) = T_m;
         %   A(c,8) = T_i;
        end
        
    if (a_i <= 0.0)|| (b_i <= 0.0) 
		%a_i = 0.0; a = 0.0;
        %b_i = 0.0; b = 0.0;
        %break code and chop array if the meteorite reaches the surface
        A(c:m,:)=[];
        break
        
    end
    
        waitbar(n./Years,wait);
    end
        close(wait);


	%//************** Close up shop ********************/
    % output the columns of A to appropriate vetors
	OUT.time = A(:,1); %time (years)
    OUT.b = A(:,2); % meteorite depth
    OUT.water = A(:,3); % water layer size
    OUT.velocity = A(:,4); % meteorite velocity
    OUT.temp = A(:,5); % surface temperature
    OUT.Q = A(:,6); % Surface energy balance (Temperature gradient in top ice)
    OUT.S = A(:,7);
    OUT.L = A(:,8);
    %OUT.grad = A(:,7);
   % OUT.tm = A(:,8);
   % OUT.ti = A(:,9);

  
