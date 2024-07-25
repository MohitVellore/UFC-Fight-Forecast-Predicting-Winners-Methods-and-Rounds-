% Check if the processed data file exists
processed_data_file = 'processed_fight_data.csv';

if exist(processed_data_file, 'file') == 2
    % If the processed data file exists, load it
    fight_data_raw_comb = readtable(processed_data_file);
else
    % If the processed data file does not exist, process the data
    fight_data_raw_comb = process_fight_data();
end
