%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Environmental Settings
%
% This file contains settings pertaining to the launch that are not
% dependent on the airframe, i.e. wind.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wind speed (knts) and direction from (deg) where 0 deg is North.
wind_speed      = 30;
wind_direction  = 240;

% Launch rod (m)
rod_len         = 2;

% Initial position (m)
initX           = 0;
initY           = 0;
initZ           = 0;

% Attitude on launch pad in Euler angles (deg). Note that the initial roll
% angle depends on how the angles of the fins are defined, otherwise the
% roll of the body has no consequence. The yaw angle at launch is analogous
% to launch azimuth.
initRollAngle   = 0;
initPitchAngle  = 85;
initYawAngle    = 0;

% Molecular Viscosity of air, from Anderson 5e example problem (N / ms).
% Used for flat plate drag per Blasius boundary layer theory.
mol_visc = 1.794e-5;

% End user declerations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of inputs to simulation parameters

% Change from wind direction to components. Odd geometry is because the
% wind direction is defined in the convention of giving the azimuth of
% where the wind is flowing from.
northWind       = wind_speed * sind(wind_direction - 90);
eastWind        = wind_speed * cosd(wind_direction + 90);