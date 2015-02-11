clear;clc;
% cd('./datasets');
file = dir('datasets/ISS*.csv');
elevationRequirement = 10;

%
for i = 1:length(file)
  fileID = fopen(file(i).name,'r');
  formatSpec = '%s%s%s%s%s%s%s%s%[^\n\r]';
  tleDataH = textscan(fileID, formatSpec, 1,'Delimiter', ',', 'WhiteSpace', '');
  formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
  tleDataD = textscan(fileID, formatSpec, 'Delimiter', ',', 'WhiteSpace', '');
  
  tleDataD = [tleDataD{1:end-1}];
  tleDataH = [tleDataH{1:end-1}];
  tleDataD = tleDataD(tleDataD(:,2)>elevationRequirement,:);
  tleDataS{i} = {file(i).name,dataset({tleDataD,tleDataH{:}})};
end
%%
deltaMinute = 5;
deltaDay = deltaMinute/(60*24);
whichconst          = 84;
typerun             = 'c';
typeinput           = 'e';
longstr1  = '1 25544U 98067A   14239.91664816  .00023399  00000-0  41609-3 0  9786';
longstr2 = '2 25544  51.6475 104.0505 0003570  55.4709  68.6766 15.50042569902456';
H                   = 0.500;
mylat               = 59.3326;
mylst               = 18.0649;
Re                  = 6378.137;     % Equatorial Earh's radius [km]
Rp                  = 6356.7523;    % Polar Earh's radius [km]
f                   = (Re - Rp)/Re; % Oblateness or flattening
minutesVector = 0:1/60:2*deltaMinute;
%
[satrec] = twoline2rv(whichconst, longstr1,longstr2,typerun,typeinput);
jdNow = tleDataS{1,1}{1,2}.Jday(1)-deltaDay;
tsince = (jdNow-satrec.jdsatepoch)*24*60 + (minutesVector);
futureJDay = tsince/(24*60)+(satrec.jdsatepoch);
for i = 1:length(tsince)
  [satrec, xsat_ecf, vsat_ecf, gst]=spg4_ecf(satrec,tsince(i));
  R_sc    = xsat_ecf';
  C1   = (Re/(1 - (2*f - f^2)*sind(mylat)^2)^0.5 + H)*cosd(mylat);
  C2   = (Re*(1 - f)^2/(1 - (2*f - f^2)*sind(mylat)^2)^0.5 + H)*sind(mylat);
  % Position vector of the observer,GEF
  R_ob = [C1*cosd(mylst), C1*sind(mylst),C2];
  % Position vector of the spacecraft relative to the observer
  R_rel = R_sc - R_ob';
  llhh = ecf2llhT(R_sc'*1e3);
  llh(i,1) = radtodeg(llhh(1));
  llh(i,2) = radtodeg(llhh(2));
  % GE_TH is direction cosine matrix to transform position vector components
  % from geocentric equatorial frame into the topocentric horizon fream
  
  GE_TH = [-sind(mylst)          cosd(mylst)              0;
    -sind(mylat)*cosd(mylst) -sind(mylat)*sind(mylst)  cosd(mylat);
    cosd(mylat)*cosd(mylst)  cosd(mylat)*sind(mylst)   sind(mylat)
    ];
  R_rel_TH = GE_TH*R_rel;
  rv = R_rel_TH/norm(R_rel_TH);
  futureEl(i) = asin(rv(3))*180/pi;      % Elevation angle
  futureAz(i)  =atan2(rv(1),rv(2))*180/pi; % Azimuth angle
  if futureAz(i) < 0
    futureAz(i) = futureAz(i) + 360;
  end
end
for j = 1:length(futureJDay)
  [yearg mong dayg hourg ming secg] = invjday(futureJDay(j));
  timeTable2(j,:) = [hourg ming secg futureJDay(j)];
end
timetable1 = [futureAz' futureEl' llh(:,1) llh(:,2)];
timeTable = [timetable1 timeTable2];
header = {'Azimuth', 'Elevation', 'Latitude', 'Longitude', 'Hour', 'Min', 'Sec', 'Jday'};
%       filename = ['./datasets/' satPopUpList{i}, '.csv'];
dt = dataset({timeTable,header{:}});
export(dt,'File',['./datasets/' file.name],'Delimiter',',')
%%
for i = 1:length(file)
  if isempty(tleDataS{1,i}{1,2})
  else
    disp(sprintf([tleDataS{1,i}{1,1} 'WORKS']));
    tleDataW{1,i}{:,:} = tleDataS{1,i}
    
  end
end
%
% cd('..');