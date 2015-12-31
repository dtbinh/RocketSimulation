%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kinematic Equations
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Body angular rates
p = wblB(1);
q = wblB(2);
r = wblB(3);

% Matrix to solve for quaternion rate.
T = [0, -p, -q, -r;
     p,  0,  r, -q;
     q, -r,  0,  p;
     r,  q,  -p, 0];

qdblL = 0.5 .* T * qblL';

% Update attitude quaternion
qblL = qblL + qdblL' * sim_dt;

q0 = qblL(1);
q1 = qblL(2);
q2 = qblL(3);
q3 = qblL(4);

% Get Euler angles from quaternion
[psi, theta, phi] = quat2angle(qblL);

% Update Euler angle vector
eblL = [phi; theta; psi];

% Log
sim_data.qblL(:, sim_ndx) = qblL';
sim_data.qdblL(:, sim_ndx) = qdblL';
sim_data.eblL(:, sim_ndx) = eblL;

% Build direction cosine matrix (Transform from local level to body)
Tbl(1, 1) = q0 ^ 2 + q1 ^ 2 - q2 ^ 2 - q3 ^ 2;
Tbl(1, 2) = 2 * (q1 * q2 + q0 * q3);
Tbl(1, 3) = 2 * (q1 * q3 - q0 * q2);
Tbl(2, 1) = 2 * (q1 * q2 - q0 * q3);
Tbl(2, 2) = q0 ^ 2 - q1 ^ 2 + q2 ^ 2 - q3 ^ 2;
Tbl(2, 3) = 2 * (q2 * q3 + q0 * q1);
Tbl(3, 1) = 2 * (q1 * q3 + q0 * q2);
Tbl(3, 2) = 2 * (q2 * q3 - q0 * q1);
Tbl(3, 3) = q0 ^ 2 - q1 ^ 2 - q2 ^ 2 + q3 ^ 2;

% Orthognalize DCM
Tbl = Tbl + 0.5 * (eye(3) - Tbl * Tbl') * Tbl;