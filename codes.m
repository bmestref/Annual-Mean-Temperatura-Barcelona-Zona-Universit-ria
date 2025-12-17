% --- Select and read Excel file ---
[FILENAME, PATHNAME] = uigetfile('*.xlsx');
rawData = readcell(fullfile(PATHNAME, FILENAME));

% --- Separate headers and data ---
headers = rawData(1, :);
dataRows = rawData(2:end, :);

% --- Identify column indices ---
colDate = find(strcmp(headers, 'by_year_data_lectura'));
colTemp = find(strcmp(headers, 'avg_valor_lectura'));

% --- Extract temperature values ---
Y = cell2mat(dataRows(:, colTemp));

% --- Extract years from date strings ---
dateStrings = dataRows(:, colDate);
dataYear = zeros(size(dateStrings));

for i = 1:length(dateStrings)
    % Convert string to datetime
    dt = datetime(dateStrings{i}, 'InputFormat', 'yyyy MMM dd hh:mm:ss a');
    dataYear(i) = year(dt);
end

X = dataYear;

% --- Plot ---
figure;
scatter(X, Y, 'filled');
hold on;
xlabel('Year');
ylabel('Mean Annual Temperature (°C)');
title('Annual Mean Temperature Trend - Barcelona Zona Universitària');
legend('Observed yearly mean', 'Linear trend', 'Location', 'best');
grid on;


% --- Fit linear regression ---
B = polyfit(X, Y, 1);      % slope and intercept
Y_pred = polyval(B, X);

% --- Display results ---
fprintf('Slope (°C/year): %.5f\n', B(1));
fprintf('Intercept: %.3f\n', B(2));
fprintf('Trend (°C/century): %.2f\n', B(1)*100);

% --- Compute R² ---
SS_res = sum((Y - Y_pred).^2);
SS_tot = sum((Y - mean(Y)).^2);
R2 = 1 - SS_res/SS_tot;
fprintf('R²: %.3f\n', R2);

% --- Plot ---
figure;
scatter(X, Y, 'filled');
hold on;
plot(X, Y_pred, 'r-', 'LineWidth', 1.5);
xlabel('Year');
ylabel('Mean Annual Temperature (°C)');
title('Annual Mean Temperature Trend - Barcelona Zona Universitària');
legend('Observed yearly mean', 'Linear trend', 'Location', 'best');
grid on;


