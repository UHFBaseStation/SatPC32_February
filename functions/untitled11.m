clear a b
a = [satNamesAmateur; satNamesCubesat];
[satNamesAll,ia,ic] = unique(a,'stable');
b = [tle1Amateur;tle1Cubesat];
c = [tle2Amateur;tle2Cubesat];
for i = 1:120
  tle1All{i,:} = b{ia(i)};
  tle2All{i,:} = c{ia(i)};
end