% Function to convert height from 'ft in' to inches
function total_inches = convertHeightToInches(height_str)
    if isempty(height_str)
        total_inches = NaN;
    else
        % Split the height string into feet and inches with a space
        parts = regexp(height_str, '(\d+)''\s*(\d+)"', 'tokens');
        if ~isempty(parts)
            feet = str2double(parts{1}{1});
            inches = str2double(parts{1}{2});
            total_inches = feet * 12 + inches;
        else
            total_inches = NaN; % Handle unexpected formats
        end
    end
end
