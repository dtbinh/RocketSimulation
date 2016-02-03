% Control different plots
close all;


%% Gather data
n = sim_data.sblL(1,1:sim_ndx-1);
e = sim_data.sblL(2,1:sim_ndx-1);
z = sim_data.sblL(3,1:sim_ndx-1);

v = sim_data.vblL(1,1:sim_ndx-1);
h = -z;

%% Setup plots
% Main window
f_main = figure;

h_traj = subplot(2,2,[1 3]);
trajectoryGraphic = TrajectoryGraphic(h_traj,n,e,z,sim_tvec);

h_data = subplot(2,2,2);
dataGraphic = DataGraphic(h_data, v, 'Velocity (m/s)', h, 'Altitude (m)'...
    ,sim_tvec);

h_body = subplot(2,2,4);
bodyGraphic = BodyGraphic(h_body);

% Data readout

%% Animate
% Loop
tf = max(sim_tvec);
dt = 1/30;
while true
    t0 = tic;
    while toc(t0) < tf
        t_start = tic;
        t_cur = toc(t0);

        % Grab index for this update cycle
        [~,ndx] = min(abs(t_cur-sim_tvec));

        % Call update methods
        bodyGraphic.update(sim_data.eblL(:,ndx));
        trajectoryGraphic.update(t_cur);
        dataGraphic.update(t_cur);
        
        t_pause = dt - toc(t_start);
        if t_pause > 0
            pause(dt - toc(t_start));
        end

        drawnow
    end
end