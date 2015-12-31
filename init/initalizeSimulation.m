%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initalize Simulation
%
% Allocate simulation parameters and initial conditions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulation variables
sim_dt = 0.01;          % Time step (s)
sim_ndx = 1;            % Index of simulation step
sim_t = 0;              % Sim time (s)
sim_N = 10000;          % Number of steps

% Gravity acceleration constant
g = 9.81;

% Allocate simulation data
sim_data.sblL   = zeros(3, sim_N);
sim_data.vblL   = zeros(3, sim_N);
sim_data.ablL   = zeros(3, sim_N);
sim_data.vblB   = zeros(3, sim_N);
sim_data.ablB   = zeros(3, sim_N);
sim_data.eblL   = zeros(3, sim_N);
sim_data.wblB   = zeros(3, sim_N);
sim_data.wdblB  = zeros(3, sim_N);
sim_data.qblL   = zeros(4, sim_N);
sim_data.qdblL  = zeros(4, sim_N);

sim_data.qbar   = zeros(1, sim_N);
sim_data.Cf     = zeros(3, sim_N);
sim_data.faB    = zeros(3, sim_N);
sim_data.fpB    = zeros(3, sim_N);
sim_data.mB     = zeros(3, sim_N);

% Fin angles (rad)
finAngles = degtorad(0:360/numFins:360);
finAngles = finAngles(1:end-1);

% Initial position.
sblL = [0; 0; 0];

% Initial attitude on launch pad wrt local level (NEZ) frame. Modify
% third term to set launch azimuth. [roll, pitch, yaw]
eblL = degtorad([initRollAngle; initPitchAngle; initYawAngle]);        

% Initial direction cosine matrix. Note: need to use transpose to
% transform B to L
Tbl = angle2dcm(eblL(3), eblL(2), eblL(1)); 

% Initial attitude quaternion.
qblL = dcm2quat(Tbl);

% Wind (m/s)
vwlL = [northWind; eastWind; 0];                  

% Initial body velocity (u, v, w).
vblB = [0; 0; 0];

% Body velocity in L cords.
vblL = [0; 0; 0];                   

% Initial body angular velociy (p, q, r) set to zero.
wblB = [0; 0; 0];

% Unit quaternion for zero rotation rate
qdblL = [1; 0; 0; 0];               

% Dynamic pressure (N/m2)
qbar = 0;
