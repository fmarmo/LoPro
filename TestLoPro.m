% Test LoPro
% Example reported in 
% J.M. Becker, M. Bevis, 2004. Love's problem. Geoph. J. Int. 156:171-178.
clc
clear all
close all

% Polygon vertices
rlp=[-500,-1000;500,-1000;500,1000;-500,1000];

% Load value
plp=1000*100*9.82; 

% Young modulus
Elp=0.6e11; 

% Poisson ratio
vlp=0.25; 

% Evaluation of displacements
xx=-2000:50:2000;
np=length(xx);
UP1=zeros(3,np);
UP2=zeros(3,np);

for i=1:length(xx)
    
    xyz=[xx(i);0;0];
    UP1(1:3,i)=LoPro(xyz,rlp,plp,Elp,vlp);
    
    xyz=[0;xx(i);0];
    UP2(:,i)=LoPro(xyz,rlp,plp,Elp,vlp);
end

% Plot of displacements
figure('Color','white','Position',[300 100 400 600])

subplot(4,1,1)
plot(xx./1000,UP1(1,:)*1000)
grid on
hold on
plot(xx./1000,UP1(2,:)*1000)
ylabel('d_x, d_y [mm]')
xlabel('x [km]')
xlim([-2,2])
ylim([-4,4])

subplot(4,1,2)
plot(xx./1000,UP2(1,:)*1000)
grid on
hold on
plot(xx./1000,UP2(2,:)*1000)
ylabel('d_x, d_y [mm]')
xlabel('y [km]')
xlim([-2,2])
ylim([-4,4])

subplot(4,1,3)
plot(xx./1000,UP1(3,:)*1000)
grid on
ylabel('d_x, d_y [mm]')
xlabel('x [km]')
xlim([-2,2])
ylim([5,25])

subplot(4,1,4)
plot(xx./1000,UP2(3,:)*1000)
grid on
ylabel('d_x, d_y [mm]')
xlabel('x [km]')
xlim([-2,2])
ylim([5,25])
