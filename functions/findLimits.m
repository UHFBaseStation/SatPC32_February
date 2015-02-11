function [azimuthSerialPort] = findLimits
delete(instrfind);clear all;
  azimuthSerialPort = serial('COM4');
  azimuthSerialPort.Terminator = {'CR/LF', 'CR/LF'};
  azimuthSerialPort.Timeout = 2;
  azimuthSerialPort.BytesAvailableFcn = {@myFgets};

  fopen(azimuthSerialPort);
  fprintf(azimuthSerialPort, '++mode 1');
  fprintf(azimuthSerialPort, '++addr 15');
  fprintf(azimuthSerialPort, '++auto 1');
  fprintf(azimuthSerialPort, '++clr');
  fprintf(azimuthSerialPort, 'H<');
  pause(0.5);
  fprintf(azimuthSerialPort, 'S<');
  fprintf(azimuthSerialPort, 'Aa1<Bf<');
  fprintf(azimuthSerialPort, '++spoll');
  fprintf(azimuthSerialPort, 'Aa1<Br<');
fprintf(azimuthSerialPort, '++spoll');
    function myFgets(source, eventdata)
        fgets(azimuthSerialPort)
    end
end