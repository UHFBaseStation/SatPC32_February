function getTLE(varargin)
if nargin < 1
    satelliteNorad = '39444U';
end
urlwrite('http://www.celestrak.com/NORAD/elements/amateur.txt',['tle/amateur.txt']);
filename = './tle/ourTLE.txt';
fileID = fopen(filename,'r');
formatSpec = '%s%[^\n\r]';
amateur = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
amateur = [amateur{1:end-1}];
index = strfind(amateur,satelliteNorad);
index = find(~cellfun(@isempty,index));
fclose(fileID);
%%
longstr1 = amateur{index,:};
longstr2 = amateur{index+1,:};
% % non mod
% whichconst = 84;
% typerun = 'm';
% typeinput = 'e';
% [satrec] = twoline2rv(whichconst, longstr1,longstr2,typerun,typeinput);
%% mod
for i = 1:5
    % [satrec] = twoline2rvMOD(longstr1,longstr2);
    whichconst = 84;
    typerun = 'c';
    typeinput = 'e';
    [satrec] = twoline2rv(whichconst, longstr1,longstr2,typerun,typeinput);
    %%
    
    jdNow = jday;
    tsince = (jdNow-satrec.jdsatepoch)*24*60;
    %%
    [satrec, r, v] = sgp4(satrec,tsince);
    [satrec, xsat_ecf, vsat_ecf, gst]=spg4_ecf(satrec,tsince);
    
    %%
    R_sc    = xsat_ecf';
    H       = 0.500;
    lat     = 59.3326;
    lst     = 18.1;
    % lst = radtodeg(siderealtime);
    
    Re      = 6378.137;     % Equatorial Earh's radius [km]
    Rp      = 6356.7523;    % Polar Earh's radius [km]
    f       = (Re - Rp)/Re; % Oblateness or flattening
    C1   = (Re/(1 - (2*f - f^2)*sind(lat)^2)^0.5 + H)*cosd(lat);
    C2   = (Re*(1 - f)^2/(1 - (2*f - f^2)*sind(lat)^2)^0.5 + H)*sind(lat);
    % Position vector of the observer,GEF
    
    R_ob = [C1*cosd(lst), C1*sind(lst),C2];
    % Position vector of the spacecraft relative to the observer
    R_rel = R_sc - R_ob';
    
    % GE_TH is direction cosine matrix to transform position vector components
    % from geocentric equatorial frame into the topocentric horizon fream
    
    GE_TH = [-sind(lst)          cosd(lst)              0;
        -sind(lat)*cosd(lst) -sind(lat)*sind(lst)  cosd(lat);
        cosd(lat)*cosd(lst)  cosd(lat)*sind(lst)   sind(lat)
        ];
    R_rel_TH = GE_TH*R_rel;
    rv = R_rel_TH/norm(R_rel_TH);
    Elev = asin(rv(3))*180/pi;      % Elevation angle
    Az  =atan2(rv(1),rv(2))*180/pi; % Azimuth angle
    if Az < 0
        Az = Az + 360;
    end
    disp(sprintf('El: %5.2f\tAz: %5.2f',Elev,Az));
    pause(1);
end
end
