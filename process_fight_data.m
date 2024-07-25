function fight_data_raw_comb = process_fight_data()
    %%% fights formatting and processing %%%
    fight_data_raw_1_path = 'fights.csv';
    fight_data_raw_2_path = 'competitions.csv';
    
    % Convert certain columns to string type after event_url column
    opts = detectImportOptions(fight_data_raw_1_path);
    event_url_index = find(strcmp(opts.VariableNames, 'event_url'));
    
    % Define the list of strings to search for in column names
    search_strings = {'Sig_str', 'Clinch', 'Ground', 'Total_str', 'Td', 'Head', 'Body', 'Leg', 'Distance'};
    
    for i = event_url_index+1:length(opts.VariableNames)
        col_name = opts.VariableNames{i};
        for j = 1:length(search_strings)
            if contains(col_name, search_strings{j})
                % Read the column as string to split later
                opts = setvartype(opts, col_name, 'string');
            end
        end
    end
    
    fight_data_raw_1 = readtable(fight_data_raw_1_path, opts);
    fight_data_raw_2 = readtable(fight_data_raw_2_path, opts);
    
    % Combine tables
    fight_data_raw_comb = vertcat(fight_data_raw_1, fight_data_raw_2);
    
    % Initialize a list to keep track of columns to be removed
    columns_to_remove = {};
    
    % Process each column to split values and create new columns
    for i = event_url_index+1:length(fight_data_raw_comb.Properties.VariableNames)
        col_name = fight_data_raw_comb.Properties.VariableNames{i};
        for j = 1:length(search_strings)
            if contains(col_name, search_strings{j})
                % Initialize new columns with NaN to handle the splitting
                new_col_landed = [col_name, '_landed'];
                new_col_attempted = [col_name, '_attempted'];
                fight_data_raw_comb.(new_col_landed) = NaN(height(fight_data_raw_comb), 1);
                fight_data_raw_comb.(new_col_attempted) = NaN(height(fight_data_raw_comb), 1);
    
                % Split the values in the column and assign to new columns
                for k = 1:height(fight_data_raw_comb)
                    value = fight_data_raw_comb.(col_name){k};
                    if ~isempty(value) && ischar(value)
                        split_data = split(value, ' of ');
                        if length(split_data) == 2
                            fight_data_raw_comb.(new_col_landed)(k) = str2double(split_data{1});
                            fight_data_raw_comb.(new_col_attempted)(k) = str2double(split_data{2});
                        end
                    end
                end
    
                % Add the original column to the list of columns to be removed
                columns_to_remove{end+1} = col_name;
            end
        end
    end
    
    % Remove the original columns
    fight_data_raw_comb = removevars(fight_data_raw_comb, columns_to_remove);
    
    % Process 'Ctrl' columns to convert time format to seconds
    for i = 1:length(fight_data_raw_comb.Properties.VariableNames)
        col_name = fight_data_raw_comb.Properties.VariableNames{i};
        if contains(col_name, 'Ctrl')
            % Check if the column is a cell array
            if iscell(fight_data_raw_comb.(col_name))
                % Convert the time format to seconds
                fight_data_raw_comb.(col_name) = cellfun(@(x) convertToSeconds(x), fight_data_raw_comb.(col_name));
            end
        end
    end
    
    % Display the first few rows to verify
    disp('First few rows of the combined table with new columns:');
    head(fight_data_raw_comb)
    
    % Display the data types of each column
    disp('Data types of each column:');
    column_classes = varfun(@class, fight_data_raw_comb, 'OutputFormat', 'table');
    disp(column_classes)
    
    %%% fighter formatting and processing %%%
    
    % Load fighter data
    fighter_data_raw = readtable('individuals.csv');
    
    % Identify the height column (assuming it's named 'Height')
    height_col_name = 'height';
    
    % Initialize an array to store the converted heights
    converted_heights = NaN(height(fighter_data_raw), 1);
    
    % Convert height values from feet and inches to inches
    for i = 1:height(fighter_data_raw)
        height_str = fighter_data_raw.(height_col_name){i};
        converted_heights(i) = convertHeightToInches(height_str);
    end
    
    % Update the height column with the converted values
    fighter_data_raw.(height_col_name) = converted_heights;
    
    %%% Creating master dataset/table %%%
    
    % Merge fighter data for player1
    fight_data_raw_comb = outerjoin(fight_data_raw_comb, fighter_data_raw, 'LeftKeys', 'player1', 'RightKeys', 'name', 'MergeKeys', true, 'Type', 'left');
    
    % Loop through the last 7 columns to add 'p1_' prefix to their names
    num_cols = width(fight_data_raw_comb);
    for i = num_cols-6:num_cols
        fight_data_raw_comb.Properties.VariableNames{i} = ['p1_', fight_data_raw_comb.Properties.VariableNames{i}];
    end
    
    % Merge fighter data for player2
    fight_data_raw_comb = outerjoin(fight_data_raw_comb, fighter_data_raw, 'LeftKeys', 'player2', 'RightKeys', 'name', 'MergeKeys', true, 'Type', 'left');
    %fight_data_raw_comb.Properties.VariableNames = strrep(fight_data_raw_comb.Properties.VariableNames, '_fighter_data_raw', '_player2');
    
    % Loop through the last 7 columns to add 'p2_' prefix to their names
    num_cols = width(fight_data_raw_comb);
    for i = num_cols-6:num_cols
        fight_data_raw_comb.Properties.VariableNames{i} = ['p2_', fight_data_raw_comb.Properties.VariableNames{i}];
    end
    
    %remove fights before 2014
    fight_data_raw_comb = fight_data_raw_comb(fight_data_raw_comb.event_date >= datetime(2014,1,1), :);

    % Apply additional filtering
    fight_data_raw_comb = filter_out_fights(fight_data_raw_comb);
    
    %sort back by date
    fight_data_raw_comb = sortrows(fight_data_raw_comb, 'event_date','descend'); 

    % Save the processed data to a file for future use
    writetable(fight_data_raw_comb, 'processed_fight_data.csv');
end

