%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rocket Launch Simulation
%
% Jack Ridderhof
% jhr@mailbox.org
%
% This program simulates the flight of a high powered rocket in six degrees
% of freedom (attitude and position). Wind is considered as a constant
% velocity body with no rotation. Aerodynamic forces are computed using
% thin aerofoil theory for the fins. See /docs for more information.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Terminology & Conventions:
%
% The standards used in this program are adapted from Zipfel's text:
%
%   Zipfel, P. H. (2007). Modeling and simulation of aerospace vehicle
%       dynamics (2nd ed.). Reston, Va.: American Institute of Aeronautics
%       and Astronautics.
%
% Vectors are described by a lower case letter. Matricies/ 2nd order
% tensors are described by an upper case letter. A vector or matrix is
% followed by two lower case letters indicating points or reference frames
% and should be read as the vector of <first lower case> with respect to
% <second lower case> in the <upper case> coordinate system. Lower case 'd'
% signifies a time derative.
%
% Vectors:
%
%   s:  Position
%   v:  Velocity
%   e:  Euler angles (theta, phi, psi) w/ 3-2-1 rotation sequence
%   w:  Angular velocity
%   q:  Quaternion
%   f:  Force
%   m:  Moment
%   
% Reference frames/ Coordinate systems:
%
%   The following frames are used with unit vector references listed:
%
%   B:  Rocket body fixed frame
%           1 - Vector from the cg to the nose
%           2 - Vector from the cg to the right side (Arbitrarily defined)
%   L:  Local level frame (NEZ - North, East, down)
%           1 - Ground level pointing North
%           2 - Ground level pointing East
%           3 - Ground level pointing down
%   F:  Fin frame
%           Same as the body frame, except attached to the fin so so that
%           the 2 direction (y) is from the root to the tip. Origin of
%           system is at the aerodynamic center of the fin.
%
% Transform Matricies:
%
%   Transform matricies are given T<frame transorming to><frame
%   transforming from> with the frame designations given in lower case.
%
% Examples:
%
%   sddblL -> The second time derivative of position (acceleration) of the
%   body, b, with respect to the local level, l, expressed in local level
%   coordinates L.
%
%   wdblB -> The first time derivative of the angular velocity
%   vector w (wd) of the body frame, b, with respect to the local level
%   frame, l, expressed in body coordinates, B.
%
%   sfbB -> Position of a fin seen by an observer fixed to the body frame
%   and expressed in the body coordinate system.
%
%   vblL -> Velocity of the body seen by an observer fixed to the local
%   level frame and expressed in the local level coordinate system.
%
%   Tbl -> Transform matrix taking a vector from local level coordinates to
%   body coordinates.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear workspace and add resource paths
clear;clc;close all;
addpath(genpath('init'));
addpath(genpath('modules'));
addpath(genpath('func'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start Setup

% Airframe parameters
run 'init/airframe.m'

% Environment parameters (including the setup of the rocket on the pad)
run 'init/environment.m'

% Allocate data structures and create proper initial condition variables.
run 'init/initalizeSimulation.m'

% End setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start simulation

% Simulate dynamics until the rocket falls back to the ground. Note that
% this is while the Z position is negative because the positive Z direction
% is into the ground.
while (sblL(3) <= 0)

    % Aero & Propulsion
    run 'modules/aeroProp.m'

    % Euler & Newton
    run 'modules/eulerNewton.m'

    % Kinematic Equations
    run 'modules/kinematics.m'

    % Update time step
    sim_ndx = sim_ndx + 1;
    sim_t = sim_t + sim_dt;
end

% End simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start visualization

[apogee,sim_ndx_apogee] = max(-sim_data.sblL(3,:));
figure
hold on
tvec_to_apogee = 0:sim_dt:sim_dt*(sim_ndx_apogee-1);
for ii = 1:3
    
   plot(tvec_to_apogee,-sim_data.wblB(ii,1:sim_ndx_apogee))
 
end

figure
% Plot
%sim_ndx = floor(sim_ndx / 2);
x = sim_data.sblL(1,1:sim_ndx-1);
y = sim_data.sblL(2,1:sim_ndx-1);
z = sim_data.sblL(3,1:sim_ndx-1);
u = sim_data.vblL(1,1:sim_ndx-1);
v = sim_data.vblL(2,1:sim_ndx-1);
w = sim_data.vblL(3,1:sim_ndx-1);
roll = sim_data.eblL(1,1:sim_ndx-1);
pitch = sim_data.eblL(2,1:sim_ndx-1);
yaw = sim_data.eblL(3,1:sim_ndx-1);

% plot3(x,y,z)
% box on
%figure
%set(gcf,'name','sblL','numbertitle','off')
%plot3(x,y,-z)
%xlabel('N')
%ylabel('E')
%zlabel('Z')
%figure
stp = 10;
plot3nez(x(1:stp:end),y(1:stp:end),z(1:stp:end))
%trajectory3(x,y,z,pitch,roll,yaw,scale_factor,step,varargin)
hold on
% quiver3(x,y,-z,u,v,w,2)
dataplots = false;

if dataplots
   figure
   set(gcf,'name','mB','numbertitle','off')
   timeArr = 0:sim_dt:sim_t;
   for ii = 1:3
      subplot(3,1,ii)
      plot(timeArr, sim_data.mB(ii,1:sim_ndx-1))
      ylabel(ii)
      xlabel('t')
   end
end

if dataplots
   figure
   set(gcf,'name','wblB','numbertitle','off')
   timeArr = 0:sim_dt:sim_t;
   for ii = 1:3
      subplot(3,1,ii)
      plot(timeArr, sim_data.wblB(ii,1:sim_ndx-1))
      ylabel(ii)
      xlabel('t')
   end
end

if dataplots
   figure
   set(gcf,'name','vblB','numbertitle','off')
   timeArr = 0:sim_dt:sim_t;
   for ii = 1:3
      subplot(3,1,ii)
      plot(timeArr, sim_data.vblB(ii,1:sim_ndx-1))
      ylabel(ii)
      xlabel('t')
   end
end

% End visualization. Thanks for reading!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%