%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Airframe Settings
%
% This file contains settings pertaining to the rocket's airframe. Values
% should be constant for a given airframe configuration.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dry mass (kg)
m       = 5;

% Mass moment of inertia matrix. Defined in the body frame. (kg-m2)
MOI     = [0.5 0 0; 0 5 0; 0 0 5];

% Fin position relative to the rocket center of mass:
% Axial distance (m)
l       = 0.5;
% Radial distance (m)
r       = 0.15;

% Fin area (m2) and aspect ratio
S       = 0.05;
AR      = 2;

% Number of fins
numFins = 4;