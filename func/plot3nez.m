function [  ] = plot3nez( n,e,z )
%PLOT3NEZ Plot a trajectory in NEZ coordinates.
%   Plots trajectory as well as a frame triad at the origin. Optional
%   drawing of projections of the trajectory on the box walls.

% n = [0 10 10 15 20 15 15 15];
% e = [0 5 5 6 6 5 4 5];
% z = -[0 100 250 400 600 650 400 300];

% Speed up display by not plotting every point
point_distance = 20;
n_plot = n(1:point_distance:end);
e_plot = e(1:point_distance:end);
z_plot = z(1:point_distance:end);

% Handle of the plot object
mainHdl = plot3(n_plot,e_plot,-z_plot);

% Cosmetic settings
box on
axis equal
grid off
axis([-500 500 -500 500 0 round(1.1*max(-z))])

% set(gca, 'DataAspectRatio', [diff(get(gca, 'XLim')) ...
%     diff(get(gca, 'XLim')) diff(get(gca, 'ZLim'))])
% zlim([0 max(-z)*1.1])

% Get limits
xl = xlim;
yl = ylim;
zl = zlim;

% set(gca,'xtick',xl(1):25:xl(2))
% set(gca,'xticklabel',[])
% set(gca,'ytick',linspace(yl(1),yl(2),5))
% set(gca,'yticklabel',[])
% set(gca,'ztick',[])
set(gca,'ztick',[0 max(-z)])
apgLbl = sprintf('Apogee: %d',round(max(-z)));
set(gca,'zticklabel',{'0', apgLbl})

% Reverse E axis direction and flip N axis location
axis ij
set(gca, 'XAxisLocation', 'bottom')

% Draw NEZ triad
hold on
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1;0;0],[0;1;0],[0;0;-1],...
    max(xl)*.75,'k','LineWidth',2)

% NZ Projection
hold on
plot3(n_plot,yl(1)*ones(length(n_plot)),-z_plot,'--c')

% NE Projection
hold on
plot3(n_plot,e_plot,zl(1)*ones(length(n_plot)),'--m')

% EZ Projection
hold on
plot3(xl(2)*ones(length(n_plot)),e_plot,-z_plot,'--g')

% Apogee Display
hold on
apg = max(-z);
xx = [xl(1) xl(1) xl(2) xl(2) xl(1)];
yy = [yl(1) yl(2) yl(2) yl(1) yl(1)];
zz = [apg apg apg apg apg];
plot3(xx,yy,zz,'r')
% Put main plot on top
uistack(mainHdl,'top')

hold off
end

