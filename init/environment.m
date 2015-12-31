%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Environmental Settings
%
% This file contains settings pertaining to the launch that are not
% dependent on the airframe, i.e. wind.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wind speed (knts) and direction from (deg) where 0 deg is North.
wind_speed      = 20;
wind_direction  = 240;

% Launch rod (m)
rod_len         = 2;

% Initial position (m)
initX           = 0;
initY           = 0;
initZ           = 0;

% Attitude on launch pad in Euler angles (deg)
initRollAngle   = 0;
initPitchAngle  = 85;
initYawAngle    = 0;

% Molecular Viscosity of air, from Anderson 5e example problem (N / ms)
mol_visc = 1.794e-5;

% End user declerations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of inputs to simulation parameters

% Change from wind direction to components
northWind       = wind_speed * sind(wind_direction - 90);
eastWind        = wind_speed * cosd(wind_direction + 90);