classdef TrajectoryGraphic
% Handle drawing of a 3D view of the rocket's trajectory in NEZ

    properties
        % Graphics properties
        h_anim          % Handle for animated line of trajectory
        h_rocket        % Handle for icon representing rocket
        h_st            % Handle for static trajectory
        
        % Trajectory properties
        apg             % Apogee
        apg_ndx         % Index in z of apogee value
        n               % Position North
        e               % Position East
        z               % Position down
        n_plot
        e_plot
        z_plot
        tvec_plot       % Tvec corresponding to position plot vectors
        t               % Current time represented by graphic
        t_ndx           % Index in tvec_plot of current time
    end
    
    methods
        % Initialize graphic of trajectory
        function obj = TrajectoryGraphic(ax, n, e, z, tvec)
            
            % Get apogee
            [obj.apg, obj.apg_ndx] = max(-z);

            % Speed up display by not plotting every point
            point_distance = 10;
            obj.n_plot = n(1:point_distance:end);
            obj.e_plot = e(1:point_distance:end);
            obj.z_plot = z(1:point_distance:end);
            obj.tvec_plot = tvec(1:point_distance:end);
            obj.t = 0;
            obj.t_ndx = 1;
            % Setup plot
            gca = ax;
            hold on;
            obj.h_st = plot3(obj.n_plot,obj.e_plot,-obj.z_plot,...
                'Color',[0 0 0]);
%             box on
%             grid off
            axis equal
            grid on
            % Set limits based on max downrange distance
            xylim = max(max(abs(obj.n_plot)),max(abs(obj.e_plot)));
            % Round to nearest 50
            xylim = 50*(ceil(xylim/50));
            axis([-xylim xylim -xylim xylim 0 round(1.1*max(-z))])
            view(-37,38)
            % Plot for current time
            obj.h_anim = plot3(0,0,0,'LineWidth',2);
            
            % Get limits
            xl = xlim;
            yl = ylim;
            zl = zlim;
            set(gca,'ztick',[0 max(-z)])
            apgLbl = sprintf('Apogee: %d m, %d ft',round(obj.apg),...
                round(obj.apg*3.28084));
            set(gca,'zticklabel',{'0', apgLbl})

            % Reverse E axis direction and flip N axis location
            axis ij
            set(gca, 'XAxisLocation', 'bottom')

            % Draw NEZ triad
            hold on
            quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1;0;0],[0;1;0],...
                [0;0;-1], max(xl)*.75,'k','LineWidth',2)

            % NZ Projection
            hold on
            plot3(obj.n_plot,yl(1)*ones(length(obj.n_plot)),-obj.z_plot,...
                '--','Color',[0 0 0]+0.5)

            % NE Projection
            hold on
            plot3(obj.n_plot,obj.e_plot,zl(1)*ones(length(obj.n_plot)),...
                '--', 'Color',[0 0 0]+0.5)

            % EZ Projection
            hold on
            plot3(xl(2)*ones(length(obj.n_plot)),obj.e_plot,-obj.z_plot,...
                '--','Color',[0 0 0]+0.5)

            % Apogee Display
            xx = [xl(1) xl(1) xl(2) xl(2) xl(1)];
            yy = [yl(1) yl(2) yl(2) yl(1) yl(1)];
            zz = [obj.apg obj.apg obj.apg obj.apg obj.apg];
            plot3(xx,yy,zz, 'Color',[0 0 0]+0.2)
            % Put main plot on top
            uistack(obj.h_st,'top')
            uistack(obj.h_anim,'top')
            
            xlabel('North - South (m)')
            ylabel('East - West (m)')
        end
        
        % Update graphic to reflect certain time of flight
        function update(obj, t_new)
            % Get index in time vector for t_new
            [~,new_ndx] = min(abs(t_new-obj.tvec_plot));
            if new_ndx > obj.t_ndx
                % New plot data
                n_cur = obj.n_plot(1:1:new_ndx);
                e_cur = obj.e_plot(1:1:new_ndx);
                z_cur = obj.z_plot(1:1:new_ndx);
            	% Progress in time
                set(obj.h_anim,'Xdata',n_cur);
                set(obj.h_anim,'Ydata',e_cur);
                set(obj.h_anim,'Zdata',-z_cur);
            else
                % Erase plot, restart
            end
        end
    end
    
end