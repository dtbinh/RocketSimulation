%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Euler & Newton
%
% Apply Euler's and Newton's laws in the body frame. Transform results to
% local level frame. This module also manages effects of the launch rod.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Euler's Equation in the body frame

% Body rates
p = wblB(1);
q = wblB(2);
r = wblB(3);

% Change in body rates, only when in free flight
if -sblL(3) > rod_len % Local level Z axis is into ground
    pd = ((MOI(2, 2) - MOI(3, 3)) * q * r + mB(1)) / MOI(1, 1);
    qd = ((MOI(3, 3) - MOI(1, 1)) * p * r + mB(2)) / MOI(2, 2);
    rd = ((MOI(1, 1) - MOI(2, 2)) * p * q + mB(3)) / MOI(3, 3);

    % Back into a vector
    wdblB = [pd; qd; rd];
    
% If the rocket is still on the launch rod the attitude is fixed
else
    wdblB = zeros(3,1);
end

% Update body angular rates
wblB = wblB + wdblB * sim_dt;

% Log angular velocity and acceleration
sim_data.wdblB(:, sim_ndx) = wdblB;
sim_data.wblB(:, sim_ndx) = wblB;

% Body velocity components
u = vblB(1);
v = vblB(2);
w = vblB(3);

% Total force on the body in the body frame
fB = fB + Tbl * [0 0 g]';

% Newton's Equation in the body frame
ud = r * v - q * w + fB(1) / m;
vd = p * w - r * u + fB(2) / m;
wd = q * u - p * v + fB(3) / m;

% Acceleration vector
ablB = [ud; vd; wd];

% Update body velocity
vblB = vblB + ablB * sim_dt;

% Transform vel., acel., to L cords.
ablL = Tbl' * ablB;
vblL = Tbl' * vblB;

% Update body position
sblL = sblL + vblL * sim_dt;

% Log position, velocity, and acceleration
sim_data.vblB(:, sim_ndx) = vblB;
sim_data.ablB(:, sim_ndx) = ablB;
sim_data.sblL(:, sim_ndx) = sblL;
sim_data.vblL(:, sim_ndx) = vblL;
sim_data.ablL(:, sim_ndx) = ablL;
