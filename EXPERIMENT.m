%% This function reads in the time length of the experiment (in hours), the conductivity of the meteorite,
%% the attenuation coefficient of the ice and the initial depth of the meteorite (in metres)
%%
%% The function simulates the movement of the meteorite in experimental conditions and outputs the 
%% depths of the meteorite and water layer and the velocity of the meteorite as functions of time.

function [OUT]= EXPERIMENT(Hours,k_d,gamma,initial)

Time = Hours*3600.;
A = zeros(Time,7);

	%//*********** RADIATION ******************//
	
	S_in = 1440;
    
    delta = 0.1;
	
	%//*********** FAR FIELD CONDITION ******************//
	%//These are the parameters for the end of the ice block
	T_inf = -4;		z_inf = 0.05 ;

	
	%//*********** METEORITE CHARACTERISTICS ******************//
	
	 
     w = 0.015;
	
	%//*********** CONSTANTS OF NATURE ******************//
	
	 k_w = 0.58; k_i = 2.18; %conductivities of water and ice respectively
	 a1 = 0.56; % ice albedo
	 a2 = 0.1; % meteorite albedo
	 bb = 0.98*5.667e-8; % coefficient of bb T^4 law
	 rho = 916.2; L_m = 3.34e5; % density of ice, latent heat of melting of ice resp.
	
	%//*********** DECLARE THE ENERGY TRANSMITTED THROUGH THE SURFACE ******************//
	
	S_net = S_in*(1-a1);
	S = S_in*(1-a1)*(1-a2);
	
	%//*************** NEWTON COOLING ******************//
	T_a = -1.; 
	
	wind = 0.5;
	
    h_hat = 1.29*1005*(0.1^2)/wind;
	h = h_hat + bb*4*(273.^3);	
	%//****************************************************//	
	
	
	
	%//*********** LOOP START ******************//
	
	dt = 1.; t = 0; 	
	%initial = 0.01;
	
	%// SET INITIAL CONDITIONS FOR BOTH METEORITE AND WATER INTERFACE
	a = initial;	
	b = initial;
	a_i = initial;
	b_i = initial;
	

	%//*********** INITIAL HEATING OF METEORITE *******************************************/
	T_i = -1.0;
    count = 1;
	 	while T_i < 0.0
       
		%//CALCULATE TEMPERATURE GRADIENTS
		water = b-a;
		Q = bb*4*(273.^3)*T_a + h_hat*T_a + S_net*a2*(1-exp(-gamma*a - delta*water));
		T_s = (a*Q)/(k_i + h*a);
		Phi = T_inf/(z_inf - b);
		
		%//CALCULATE A_DOT AND REFERENCE TEMPERATURE GRADIENTS
		a_dot_0 = (1./(rho*L_m))*(-S*(exp(-gamma*a - delta*water)) - k_i*Phi - (k_i*Q/(k_i+h*a))); 
        T_m = -(w/k_w)*((Q/(k_i+h*a))+ a_dot_0*rho*L_m); 
		T_i = T_m + w*k_i*Phi/k_d;
		
		%//EVOLVE A BY EULER'S METHOD
		a_i = a + a_dot_0*dt;
		
		
		%//INCREMENT TIME AND REWRITE A
		t = t + dt;
		a = a_i;
        
        A(count,1) = t./60;
        A(count,2) = a;
        A(count,3) = b;
        A(count,4) = a_dot_0;
    
        A(count,6) = water./1000;
        A(count,7) = T_s;
  
		count = count+1;
    
		%//LOOP CONDITION IS WHEN BOTTOM OF METEORITE REACHES ZERO DEGREES
        end
	
    out.checka = a
    out.checkb = b
	%//*********** MELTING AND SINKING ******************************************/
	b_dot = 1;
	
	  while (water >= 0.0) && (t <= Time)
	
		Q = bb*4*(273^3)*T_a + h_hat*T_a + S_net*a2*(1-exp(-gamma*a - delta*water));
		water = b-a;
		Phi = T_inf/(z_inf - b);
		
		%//CALCULATE THE VELCITIES
		a_dot =  (1/(rho*L_m))*(((-w*k_w*S*(exp(-gamma*a - delta*water)))/(w*k_w + water*k_d)) - (k_i*Q/(k_i+h*a)));
		b_dot = (1/(rho*L_m))*(((water*k_d*S*(exp(-gamma*a - delta*water)))/(w*k_w + water*k_d)) + (k_i*Phi));
		a_dot_0 = (1./(rho*L_m))*(-S*(exp(-gamma*a - delta*water)) - k_i*Phi - (k_i*Q/(k_i+h*a))); 
		
		%//CONDITIONS FOR MOVEMENT - B_DOT IS STRICTLY POSITIVE
		if (b_dot < 0.0) 
			a_i = a +dt*a_dot_0;
			b_i = b;
			b_dot = 0.0;
        end
		
		if (b_dot > 0.0) 
			a_i = a + dt*a_dot;	b_i = b + dt*b_dot;
        end
		
		
		%//INCREMENT TIME AND REWRITE A AND B
		t = t + dt;
		a = a_i;
		b = b_i;
        A(count,1) = t./60;
        A(count,2) = a;
        A(count,3) = b;
        A(count,4) = a_dot;
        A(count,5) = b_dot;
        A(count,6) = water./1000;
        A(count,7) = T_s;
		count = count+1;
		%//LOOP CONDITION IS A NON-ZERO WATER LAYER
  
      end
     %    close(wait1);
    A(count:Time,:)=[];
	OUT.time = A(:,1);
    OUT.a = A(:,2);
    OUT.b = A(:,3);
    OUT.a_dot = A(:,4);
    OUT.b_dot = A(:,5);
    OUT.water = A(:,6);
    OUT.temp = A(:,7);
    
    %%%% These last few lines  are for plotting %%%%%
    
    %figure; plot(OUT.time,OUT.a,OUT.time,OUT.b);
   % figure;
    plot(OUT.time,OUT.b);xlim([0 250]);
	%//OUTPUT A FLAG
	%cout << "Stop sinking" << "\t" << a_dot << "\t" << t/3600. << endl;
	
	%//************** CLOSE UP SHOP ********************/
