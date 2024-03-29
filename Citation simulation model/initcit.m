% INITCITATION.M
%
%
%-----------------------------------------------------------------------------
%
% Author : Clark Borst
%
% September 2004
%
% Control and Simulation Division
% Faculty of Aerospace Engineering
% Delft University of Technology
%
%-----------------------------------------------------------------------------
%
% Version : EXPORT (for Analysis), no gear, no wind.

% Load general and Citation data
load ac_genrl;
load citdata;
load jt15data;

% Define variables in models

% logarithmic wind model
Vw915 = 0;
winddir = 45*(pi/180);

% Define Runway Altitude hrunway
%
% Used by 
% * Aerodynamic Ground Effect Model
% * Landing Gear Model

%hrunway=2.5;

trimdatafile = 'citast.tri';

if not(isempty(trimdatafile))
load(trimdatafile,'-mat');
disp(' ');
disp('**********************************');
disp('*    Citation Library            *');
disp('*                                *');
disp('* Delft University of Technology *');
disp('* Clark Borst, 2004              *');
disp('**********************************');
disp(' ');
disp(['Trim condition  : ' trimdatafile]);
disp(['Aircraft weight : ' num2str(massinit(1)) ' kg']);
disp(['Altitude        : ' num2str(x0(10)) ' m']);
disp(['Speed Vtas      : ' num2str(x0(4)) ' m/s']);
disp(['Gamma           : ' num2str(round((x0(8)-x0(5))/pi*180)) ' deg']);
disp(['Power Lever     : ' num2str(ut0(1)) ]);
disp(' ');
end

gear_params;

sample_size=50;

%% Build MMI matrix 
I=[massinit(5),0, -massinit(8);0, massinit(6),0;-massinit(8),0, massinit(7)]; %[Ixx 0 -Ixz; 
                                                                              %  0  Iyy  0;
dp_ini=4046; %initial dynamic pressure                                        % -Ixz 0   Izz ] 

%% read in aerodynamic model from earlier run and take the average from 33-100% of the run
aci=load('coefval.mat');
coefname={};
coefvalue={};
for id=1:(aci.data.numElements()-1)
    name=aci.data{id}.Values.Name;
    coefname=[coefname,name];
    measures=reshape(aci.data{id}.Values.Data,length(aci.data{1}.Values.Data),1);
    avg=mean(measures(floor(length(measures)/3):end));
    coefvalue{1,id}=avg;
end
inicoef = containers.Map(coefname,coefvalue);

aeroinit=[dp_ini;inicoef('CX0');inicoef('CXa');inicoef('CXa2');inicoef('CXq')... %initial aerodata for memory block
    ;inicoef('CXde');inicoef('CY0');inicoef('CYB');inicoef('CYp');inicoef('CYr')...
    ;inicoef('CYda');inicoef('CYdr');inicoef('CZ0');inicoef('CZa');inicoef('CZq')...
    ;inicoef('CZde');inicoef('Cl0');inicoef('ClB');inicoef('Clp');inicoef('Clr')...
    ;inicoef('Clda');inicoef('Cldr');inicoef('Cm0');inicoef('Cma');inicoef('Cmq')...
    ;inicoef('Cmde');inicoef('Cn0');inicoef('CnB');inicoef('Cnp');inicoef('Cnr')...
    ;inicoef('Cnda');inicoef('Cndr')];


%% Initial values for LSQ aerodynamic parameter estimation
%Symmetric 
Pcov_X=10000*eye(5); %inital covariance matrix for CX estimation
p_X=[inicoef('CX0');inicoef('CXa');inicoef('CXa2');inicoef('CXq')...
    ;inicoef('CXde')].*ones(5,sample_size);
% p_X=0.1*ones(5,sample_size);
y_X=zeros(1,sample_size);
y_X_est_old=zeros(size(y_X));
h_X_old=zeros(5,sample_size);


Pcov_Z=10000*eye(4); %inital covariance matrix for CZ estimation
p_Z=[inicoef('CZ0');inicoef('CZa');inicoef('CZq')...
    ;inicoef('CZde')].*ones(4,sample_size);
% p_Z=0.2*ones(4,sample_size);
y_Z=zeros(1,sample_size);
y_Z_est_old=zeros(size(y_Z));
h_Z_old=zeros(4,sample_size);


Pcov_m=10000*eye(4); %inital covariance matrix for Cm estimation
p_m=[inicoef('Cm0');inicoef('Cma');inicoef('Cmq')...
    ;inicoef('Cmde')].*ones(4,sample_size);
% p_m=0.3*ones(4,sample_size);
y_m=zeros(1,sample_size);
y_m_est_old=zeros(size(y_m));
h_m_old=zeros(4,sample_size);

%Assymetric
Pcov_Y=10000*eye(6);
p_Y=[inicoef('CY0');inicoef('CYB');inicoef('CYp');inicoef('CYr')...
    ;inicoef('CYda');inicoef('CYdr')].*ones(6,sample_size);
% p_Y=0.5*ones(6,sample_size);
y_Y=zeros(1,sample_size);
y_Y_est_old=zeros(size(y_Y));
h_Y_old=zeros(6,sample_size);

Pcov_l=10000*eye(6);
p_l=[inicoef('Cl0');inicoef('ClB');inicoef('Clp');inicoef('Clr')...
    ;inicoef('Clda');inicoef('Cldr')].*ones(6,sample_size);
% p_l=0.6*ones(6,sample_size);
y_l=zeros(1,sample_size);
y_l_est_old=zeros(size(y_l));
h_l_old=zeros(6,sample_size);

Pcov_n=10000*eye(6);
p_n=[inicoef('Cn0');inicoef('CnB');inicoef('Cnp');inicoef('Cnr')...
    ;inicoef('Cnda');inicoef('Cndr')].*ones(6,sample_size);
p_n=0.71*ones(6,sample_size);
y_n=zeros(1,sample_size);
y_n_est_old=zeros(size(y_n));
h_n_old=zeros(6,sample_size);


%% Failure monitor
Clda_thresh=3.410e-2/2;
deaf_window=300;

%% Load signal data
inputsim=load('simulation runs/Cl_RLS_run02.mat');
timeend=inputsim.data{1}.Values.Time(end);
replay=0; %set this to one to enable replay of inputs