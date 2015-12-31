function [  ] = plot3nez( n,e,z )
%PLOT3NEZ Summary of this function goes here
%   Detailed explanation goes here
%clear;clc;close all;

% n = [0 10 10 15 20 15 15 15];
% e = [0 5 5 6 6 5 4 5];
% z = -[0 100 250 400 600 650 400 300];

mainHdl = plot3(n,e,-z);

% Cosmetic settings
box on
axis equal
% set(gca, 'DataAspectRatio', [diff(get(gca, 'XLim')) ...
%     diff(get(gca, 'XLim')) diff(get(gca, 'ZLim'))])
zlim([0 max(-z)*1.1])

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
grid on
% Reverse E axis direction and flip N axis location
axis ij
set(gca, 'XAxisLocation', 'bottom')

% Draw NEZ triad
hold on
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1;0;0],[0;1;0],[0;0;-1],...
    max(n)*.25,'k','LineWidth',2)

% NZ Projection
hold on
plot3(n,yl(1)*ones(length(n)),-z,'--c')

% NE Projection
hold on
plot3(n,e,zl(1)*ones(length(n)),'--m')

% EZ Projection
hold on
plot3(xl(2)*ones(length(n)),e,-z,'--g')

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

