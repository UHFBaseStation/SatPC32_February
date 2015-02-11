function orbit(Az,sport)

% Outputs could be:
% Mode: "turning" or "Not turning" for example.
% Speed
% Axis
% <<<<<<< HEAD
%Rotor azimuth
try
fprintf(sport, 'H<');
pause(0.5);
fprintf(sport, 'L<');
if Az >= 100
    stringAz = num2str(Az,'%-5.2f');
else
    stringAz = ['0' num2str(Az,'%-5.2f')];
end
stringAz = strrep(stringAz, '.', '');
fprintf(sport, ['Pat' stringAz '<']); % fprintf(sport, ['Pat00000<']);
fprintf(sport, 'H<');
pause(0.5);
fprintf(sport, 'G<');        % Turn CONTROLLER to 'RUN': Start motion
catch
  disp(lasterr);
  disp('Error occuring in orbit.m');
end

% =======
% Rotor azimuth


% >>>>>>> FETCH_HEAD




% Get the correct format for the orbit unit, satpc32 gives out 1 decimal. 




% Read rotor Azimuth via serial com 



end