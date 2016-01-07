
gamma = 2.5;

%%%%%%%%% Commented example %%%%%%%%%%%

%"Wk2.csv" is the early chondrite

%Read in the csv files and set up vectors for plotting
One = dlmread('Chon1.csv',',');
%dlmread reads the csv file into a matrix. The next commands take the
%columns of the matrix and moves them to plottable vectors
t1 = One(:,1);
d1 = One(:,2);
%Convert the depth to millimetres
d1 = d1*1000;
%Run the simulation with accurate conductivity and initial condition.
A = EXPERIMENT(300,5,gamma,0.0129);


%%%%%%% The rest of these do the same thing for different datafiles %%%%

%"Iron1.csv" is the short iron, often neglected
Two = dlmread('Iron1.csv',',');
t2 = Two(:,1);
d2 = Two(:,2);
d2 = d2*1000;
B = EXPERIMENT(300,30,gamma,0.0179);

%"Iron2.csv is the early reliable iron.
Tre = dlmread('Iron2.csv',',');
t3 = Tre(:,1);
d3 = Tre(:,2);
d3 = d3*1000;
C = EXPERIMENT(300,30,gamma,0.0147);

%"Chon2.csv" is the chondrite from the final week.
W = dlmread('Chon2.csv',',');
tc = W(:,1);
dc = W(:,2);
dc = dc*1000;
cra = EXPERIMENT(300,5,gamma,0.0242);


%This is the last dataset, the iron from the final week.
I = dlmread('Iron3.csv',',');
di = I(:,2);
di = di*1000;
ti = I(:,1);
fi = EXPERIMENT(300,30,gamma,0.0206);


%%%% Plotting Commands %%%%%

%Various plotting commands follow, some more useful than others.

%Plot with everything on it, except the short iron
%figure;plot(t1,d1,'--*',t3,d3,'--*',A.tam,A.dep,C.tam,C.dep,cra.tam,cra.dep,tc,dc,'--*',fi.tam,fi.dep,ti,di,'--*')
%xlim([0 300]);

%The following two commands plot the iron and chondrite sets side by side.

figure;
subplot(1,2,1);
plot(t1,d1,'k--o',A.tam,A.dep,'k',cra.tam,cra.dep,'k',tc,dc,'k--o','LineWidth',1.3,'MarkerSize',10);
xlim([0 180]);
ylim([10 30]);
xlabel('Time (minutes)');
ylabel('Depth (millimetres)');
title('Chondrite');
subplot(1,2,2);


%
%figure
plot(t3,d3,'k--*',B.tam,B.dep,'k',fi.tam,fi.dep,'k',ti,di,'k--*','LineWidth',1.3,'MarkerSize',10);
xlim([0 180]);
ylim([10 30]);
xlabel('Time (minutes)');
ylabel('Depth (millimetres)');
title('Iron');

%Insert this last line into line 75 (plot command) to include the short
%iron dataset
%t2,d2,'k--*',C.tam,C.dep,'k',
