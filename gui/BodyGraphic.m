classdef BodyGraphic
% Handle drawing of a 3D model of a rocket on an axis object

    properties(SetAccess = public)
        n_fins                  % Number of fins
        base_trfm               % Base transforms to arrive at rocket
        t_objs                  % Handles for transform objects
    end
    
    methods
        % Initialize graphic of the rocket body
        function obj = BodyGraphic(ax)
            % Properties of rocket (m)
            radius = .05;
            length = 1;
            noseLength = 0.25;
            cg = 0.5;               % cg from base datum
            obj.n_fins = 4;
            l_fins = 0.1;
            s_fins = 0.1;
            d_fins = 0.05;          % distance from bottom
            width_fins = 0.005;

            % Setup plot
            gca = ax;
            xlim(ax, [-1 1]);
            ylim(ax, [-1 1]);
            zlim(ax, [-1 1]);
            zoom(ax, 2)
            xlabel('x');ylabel('y');zlabel('z');
            axis equal
            hold on
            view(3)
            set(ax,...              % From autogen code
            'Visible','off','YDir','reverse',...
            'PlotBoxAspectRatio',[1.5 1 2],...
            'DataAspectRatio',[1 1 1],...
            'CameraViewAngle',4.75,...
            'CameraUpVector',[0 0 1],...
            'CameraTarget',[0.098 0 -0.15],...
            'CameraPosition',[-7 9.25 6.58]);
            
            % Transform matricies for all parts. 1:body, 2:nose, 3+ fins
            obj.base_trfm = zeros(4,4,2+obj.n_fins);
            obj.t_objs = zeros(2+obj.n_fins,1);

            % Draw NEZ frame triad
            xl = xlim;
            quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1;0;0],...
                [0;1;0],[0;0;-1],max(xl)*.75,'k','LineWidth',2);
            
            % Draw body
            [X_cyl,Y_cyl,Z_cyl]=cylinder(ax, radius, 20);
            h(1) = surf(X_cyl,Y_cyl,Z_cyl);
            set(h(1), 'facec', [0 0 1]);          
            % set(h(1), 'EdgeColor','none');

            % Draw nose
            a=-radius/1^2;
            x=0:.01:1;
            y=a.*x.^2+radius;
            [X_nse,Y_nse,Z_nse]=cylinder(ax, y, 10);
            h(2) = surf(X_nse,Y_nse,Z_nse);
            set(h(2), 'facec', [0 0 1]);          
            % set(h(2), 'EdgeColor','none');

            % Transform body
            obj.t_objs(1) = hgtransform('Parent',ax);
            set(h(1), 'Parent', obj.t_objs(1))
            body_scale = makehgtform('scale',[1,1,length]);
            body_translate = makehgtform('translate',[0,0,-cg]);
            obj.base_trfm(:,:,1) = body_translate*body_scale;

            % Transform nose
            obj.t_objs(2) = hgtransform('Parent',ax);
            set(h(2),'Parent',obj.t_objs(2))
            nose_scale = makehgtform('scale',[1,1,noseLength]);
            nose_translate = makehgtform('translate',[0,0,length-cg]);
            obj.base_trfm(:,:,2) = nose_translate*nose_scale;
            
            % Create and transform fins
            ang_fin = 2*pi/obj.n_fins;
            vert = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
            fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
            fin_scale = makehgtform('scale',[width_fins,s_fins,l_fins]);
            fin_trans = makehgtform('translate',[0,radius,-cg+d_fins]);

            % For each fin, rotate into position and save transform
            for ii = 0:1:obj.n_fins-1

                h(3+ii) = patch('Vertices',vert,'Faces',fac,...
                      'FaceVertexCData',hsv(6),'FaceColor','black');

                obj.t_objs(3+ii) = hgtransform('Parent',ax);
                set(h(3+ii),'Parent',obj.t_objs(3+ii));

                fin_rot = makehgtform('zrotate',ii*ang_fin);
                obj.base_trfm(:,:,3+ii) = fin_rot*fin_trans*fin_scale;

                set(obj.t_objs(3+ii),'Matrix',obj.base_trfm(:,:,3+ii))
            end

            % Set obj.base_trfm to starting position
            yrot = makehgtform('yrotate',pi/2);
            for ii = 1:1:2+obj.n_fins
                obj.base_trfm(:,:,ii) = yrot*obj.base_trfm(:,:,ii);
            end
            
            % Display
            for ii = 1:1:2+obj.n_fins
                set(obj.t_objs(ii),'Matrix',obj.base_trfm(:,:,ii))
            end
        end

        % Update the transforms per the input rotation matrix
        function update(obj, eblB)
            roll  = eblB(1);
            pitch = eblB(2);
            yaw   = eblB(3);
            rot1 = makehgtform('xrotate',roll);
            rot3 = makehgtform('zrotate',yaw);
            rot2 = makehgtform('yrotate',-pitch);
            rot = rot3*rot2*rot1;

            for ii = 1:1:2+obj.n_fins
                set(obj.t_objs(ii),'Matrix',rot*obj.base_trfm(:,:,ii))
            end
        end
    end
end