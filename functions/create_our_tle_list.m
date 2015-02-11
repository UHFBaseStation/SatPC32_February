function create_our_tle_list(varargin)
filename3 = ['./tle/ourTLE.txt'];
satelliteList = {...
    'ISS (ZARYA)',...
    'FUNCUBE-1 (AO-73)',...
    'OSCAR 7 (AO-7)',...
    'PCSAT (NO-44)'};
satelliteList2 = {'UKUBE-1'};
filename = [cd '/tle/amateur.txt'];
filename2 = [cd '/tle/cubesat.txt'];
urlwrite('http://www.celestrak.com/NORAD/elements/amateur.txt',filename);
urlwrite('http://www.celestrak.com/NORAD/elements/cubesat.txt',filename2);
%% Format string for each line of text:
%   column1: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');
fileID2 = fopen(filename2,'r');
%% Read columns of data according to format string.
% This call is based on the structure of the file used to
% generate this code. If an error occurs for a different file,
% try regenerating the code from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
dataArray2 = textscan(fileID2, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
fclose(fileID2);
%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so
% no post processing code is included. To generate code which
% works for unimportable data, select unimportable cells in a
% file and regenerate the script.

%% Create output variable
amateur = [dataArray{1:end-1}];
cubesat = [dataArray2{1:end-1}];
%% List of Satellites we want to watch

n1 = 1:3:3*length(satelliteList);
for i = 1:length(satelliteList)
    index = strfind(amateur,satelliteList{i});
    index2(i) = find(~cellfun(@isempty,index));
    newlist{i,:} = amateur{index2(i)};
    longstr1{i,:} = amateur{index2(i)+1};
    longstr2{i,:} = amateur{index2(i)+2};
    textfileList{n1(i),:} = newlist{i,:};
    textfileList{n1(i)+1,:} = longstr1{i,:};
    textfileList{n1(i)+2,:} = longstr2{i,:};
end
n = (1:3:(3*length(satelliteList2)))+3*length(satelliteList);
for i = 1:length(satelliteList2)
    index = strfind(cubesat,satelliteList2{i});
    index2(i) = find(~cellfun(@isempty,index));
    newlist{i,:} = cubesat{index2(i)};
    longstr1{i,:} = cubesat{index2(i)+1};
    longstr2{i,:} = cubesat{index2(i)+2};
    textfileList{n(i),:} = newlist{i,:};
    textfileList{n(i)+1,:} = longstr1{i,:};
    textfileList{n(i)+2,:} = longstr2{i,:};
end
%%
filename3 = ['./tle/ourTLE.txt'];
filename4 = ['./tle/Orbitron/Tle/ourTLE.txt'];
fileID = fopen(filename3,'w+');
fileID2 = fopen(filename4,'w+');
for i = 1:length(textfileList)
    fprintf(fileID,textfileList{i,:});
    fprintf(fileID,'\n');
    fprintf(fileID2,textfileList{i,:});
    fprintf(fileID2,'\n');
end
fclose(fileID);
fclose(fileID2);
end