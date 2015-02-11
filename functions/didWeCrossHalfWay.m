function answer = didWeCrossHalfWay( lastAz, firstAz )
%DIDWECROSSHALFWAY Summary of this function goes here
%   Detailed explanation goes here
if lastAz > 0 && lastAz < 359.5 && firstAz ~= 0
  difference = abs( lastAz - firstAz );
  if difference < 180
    if lastAz <= 180 && firstAz >= 180
      answer = 'y'; % crossed and we went reverse initially
    elseif lastAz >= 180 && firstAz <= 180
      answer = 'y'; % crossed and we went forward initially
    else
      answer = 'n'; % not crossed
    end
  else
    disp('crossed too far');
    answer = 'b';
  end
else
  answer = 'n';
end

end
