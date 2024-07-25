function df = filter_out_fights(df)
    % Remove rows based on weight class
    df = remove_rows_by_col_string(df, 'weightclass', 'Women');

    % Remove rows based on method
    df = remove_rows_by_col_string(df, 'method', 'DQ', true, true);
    df = remove_rows_by_col_string(df, 'method', 'Decision - Split');
    df = remove_rows_by_col_string(df, 'method', 'Overturned');
    df = remove_rows_by_col_string(df, 'method', 'Other', true);

    % Remove rows based on details
    df = remove_rows_by_col_string(df, 'details', 'Point Deducted');
    df = remove_rows_by_col_string(df, 'details', 'Points Deducted');
    df = remove_rows_by_col_string(df, 'details', 'Illegal');

    % Remove rows based on result
    df = remove_rows_by_col_string(df, 'result', 'NC', true, true);
    df = remove_rows_by_col_string(df, 'result', 'D', true, true);
end

function df = remove_rows_by_col_string(df, col_name, str, exact, case_sensitive)
    if nargin < 4
        exact = false;
    end
    if nargin < 5
        case_sensitive = false;
    end

    if exact
        if case_sensitive
            mask = strcmp(df.(col_name), str);
        else
            mask = strcmpi(df.(col_name), str);
        end
    else
        if case_sensitive
            mask = contains(df.(col_name), str);
        else
            mask = contains(lower(df.(col_name)), lower(str));
        end
    end

    df = df(~mask, :);
end

