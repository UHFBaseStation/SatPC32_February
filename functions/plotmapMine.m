function plotmapMine(otherlat, otherlong)
mylat  = 59;
mylong = 18;
mapfigure = figure(3);
ax = worldmap([-30 80],[-100+mylong 100+mylong]);
% setm(ax, 'Origin', [0 180 0])
load geoid
% geoshow(geoid, geoidrefvec, 'DisplayType', 'texturemap');
load coast
geoshow(lat, long)
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land, 'FaceColor', [0.5 0.7 0.5])
plotm(mylat,mylong,'r*')
end
% %%
% close all force
% clear;clc;
% ax = worldmap('world');
% setm(ax, 'Origin', [0 180 0])
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(ax, land, 'FaceColor', [0.5 0.7 0.5])
% lakes = shaperead('worldlakes', 'UseGeoCoords', true);
% geoshow(lakes, 'FaceColor', 'blue')
% rivers = shaperead('worldrivers', 'UseGeoCoords', true);
% geoshow(rivers, 'Color', 'blue')
% cities = shaperead('worldcities', 'UseGeoCoords', true);
% geoshow(cities, 'Marker', '.', 'Color', 'red')
% %%
% worldmap('europe')
% %%
% europe = shaperead('landareas', 'UseGeoCoords', true,...
%   'Selector',{@(name) strcmp(name,'Europe'), 'Name'});
% patchm(europe.Lat, europe.Lon, [0.5 1 0.5])