% Drawing a rocket in 3d, center about zero. Currently a test
% close all;

% Properties (m)
radius = .05;
length = 1;
noseLength = 0.25;
cg = 0.5; % cg from base datum
n_fins = 4;
l_fins = 0.1;
s_fins = 0.1;
d_fins = 0.05; % distance from bottom
width_fins = 0.005;

% Setup plot
f = figure;
ax = axes('XLim',[-1 1],'YLim',[-1 1],'ZLim',[-1 1]);
xlabel('x');ylabel('y');zlabel('z');
axis equal
hold on
grid off
box off
view(3)

% Transform matricies for all parts. 1:body, 2:nose, 3+ fins
base_trfm = zeros(4,4,2+n_fins);
t_objs = zeros(2+n_fins,1);

% NEZ Frame
xl = xlim;
q = quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1;0;0],[0;1;0],[0;0;-1],...
    max(xl)*.75,'k','LineWidth',2);
set(gca,'Ydir','reverse')
set(gca,'Visible','off')
% Body
[X_cyl,Y_cyl,Z_cyl]=cylinder(ax, radius, 20);
h(1) = surf(X_cyl,Y_cyl,Z_cyl);
set(h(1), 'facec', [0 0 1]);          
% set(h(1), 'EdgeColor','none');

% Nose
a=-radius/1^2;
x=0:.01:1;
y=a.*x.^2+radius;
[X_nse,Y_nse,Z_nse]=cylinder(ax, y, 10);
h(2) = surf(X_nse,Y_nse,Z_nse);
set(h(2), 'facec', [0 0 1]);          
% set(h(2), 'EdgeColor','none');

% Transform body
t_objs(1) = hgtransform('Parent',ax);
set(h(1), 'Parent', t_objs(1))
body_scale = makehgtform('scale',[1,1,length]);
body_translate = makehgtform('translate',[0,0,-cg]);
base_trfm(:,:,1) = body_translate*body_scale;

% Transform nose
t_objs(2) = hgtransform('Parent',ax);
set(h(2),'Parent',t_objs(2))
nose_scale = makehgtform('scale',[1,1,noseLength]);
nose_translate = makehgtform('translate',[0,0,length-cg]);
base_trfm(:,:,2) = nose_translate*nose_scale;

% set(t_objs(1),'Matrix',base_trfm(:,:,1))
% set(t_objs(2),'Matrix',base_trfm(:,:,2))

% Create and transform fins
ang_fin = 2*pi/n_fins;
vert = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
fin_scale = makehgtform('scale',[width_fins,s_fins,l_fins]);
fin_trans = makehgtform('translate',[0,radius,-cg+d_fins]);

for ii = 0:1:n_fins-1

    h(3+ii) = patch('Vertices',vert,'Faces',fac,...
          'FaceVertexCData',hsv(6),'FaceColor','black');

    t_objs(3+ii) = hgtransform('Parent',ax);
    set(h(3+ii),'Parent',t_objs(3+ii));

    fin_rot = makehgtform('zrotate',ii*ang_fin);
    base_trfm(:,:,3+ii) = fin_rot*fin_trans*fin_scale;

    set(t_objs(3+ii),'Matrix',base_trfm(:,:,3+ii))

end

% Set base_trfm to starting position
yrot = makehgtform('yrotate',pi/2);
for ii = 1:1:2+n_fins
    base_trfm(:,:,ii) = yrot*base_trfm(:,:,ii);
end

% Display some motion
t = 0;
dt = 1/30;

yaw = degtorad(0);
roll = degtorad(0);
while true

t0 = tic;
tf = max(sim_tvec);
while toc(t0) < tf
    
    t_start = tic;
%     pitch = sin(toc(t0));
%     yaw = 0;
%     roll  = 0;

    [~,ndx] = min(abs(toc(t0)-sim_tvec));
    roll = sim_data.eblL(1,ndx);
    pitch = sim_data.eblL(2,ndx);
    yaw = sim_data.eblL(3,ndx);
    
    rot1 = makehgtform('xrotate',roll);
    rot3 = makehgtform('zrotate',yaw);
    rot2 = makehgtform('yrotate',-pitch);
    rot = rot3*rot2*rot1;
    
    for ii = 1:1:2+n_fins

        set(t_objs(ii),'Matrix',rot*base_trfm(:,:,ii))

    end
    t_pause = dt - toc(t_start);
    if t_pause > 0
        pause(dt - toc(t_start));
    end
    
    drawnow
end
end