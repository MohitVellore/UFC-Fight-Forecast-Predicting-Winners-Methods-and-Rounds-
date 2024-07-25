% Function to convert time format (min:sec) to seconds
function total_seconds = convertToSeconds(time_str)
    if isempty(time_str) || ~contains(time_str, ':')
        total_seconds = NaN;
    else
        parts = split(time_str, ':');
        if length(parts) == 2
            minutes = str2double(parts{1});
            seconds = str2double(parts{2});
            total_seconds = minutes * 60 + seconds;
        else
            total_seconds = NaN;
        end
    end
end
