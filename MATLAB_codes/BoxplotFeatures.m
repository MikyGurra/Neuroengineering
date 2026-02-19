function BoxplotFeatures(mean_RH, mean_LH, p_mean, slope_RH, slope_LH, p_slope, peak_RH, peak_LH, p_peak, task_name, alpha, custom_ylim)

% Function generating boxplots to compare hemodynamic features between hemispheres
%
% DESCRIPTION:
%   Produces a figure comparing Left Hemisphere (LH) and Right Hemisphere (RH) 
%   values for three extracted features: Mean Amplitude, Slope, and Peak Amplitude.
%   The function visualizes the data distribution using boxplots, overlays the 
%   mean value (dashed line) on top of the median (solid line), and indicates 
%   statistical significance (asterisks and p-values) based on the provided inputs.
%
% INPUT:
% - mean_RH, mean_LH   : vectors containing Mean Amplitude values for RH and LH.
% - p_mean             : p-value resulting from the statistical comparison of Mean Amplitude.
% - slope_RH, slope_LH : vectors containing Slope values for RH and LH.
% - p_slope            : p-value resulting from the statistical comparison of Slope.
% - peak_RH, peak_LH   : vectors containing Peak Amplitude values for RH and LH.
% - p_peak             : p-value resulting from the statistical comparison of Peak Amplitude.
% - task_name          : string specifying the task name (e.g., 'RMI', 'LMI') for the title.
% - alpha              : significance threshold (e.g., 0.05).
% - custom_ylim        : (optional) [min max] vector to force specific Y-axis limits.
%
% OUTPUT:
%   The function generates a figure titled 'Comparison LH vs RH [task_name]'.

    % GRAPHICAL PARAMETERS
    boxWidth = 0.4; % Width of the boxes
    % Colors (Teal for LH, Orange for RH)
    colorLH = [0.00, 0.55, 0.55]; 
    colorRH = [0.90, 0.40, 0.10]; 
    % ----------------------------

    % Handle optional argument for Y-limits
    if nargin < 12
        custom_ylim = [];
    end

    % Data Preparation
    data = [mean_LH; mean_RH; slope_LH; slope_RH; peak_LH; peak_RH];
    
    g1 = 1 * ones(size(mean_LH)); g2 = 2 * ones(size(mean_RH));
    g3 = 3 * ones(size(slope_LH)); g4 = 4 * ones(size(slope_RH));
    g5 = 5 * ones(size(peak_LH)); g6 = 6 * ones(size(peak_RH));
    grouping = [g1; g2; g3; g4; g5; g6];

    positions = [1, 1.6,  3, 3.6,  5, 5.6];

    % Setup Figure
    figure('Name', ['Comparison LH vs RH - ' task_name], 'Color', 'w', 'NumberTitle','off');
    
    h = boxplot(data, grouping, 'Positions', positions, 'Widths', boxWidth, 'Symbol', 'o');
    hold on; grid on;

    % Styling & Colors
    hBoxes = findobj(gca, 'Tag', 'Box'); 
    for i = 1:6
        if mod(i, 2) ~= 0 % Odd -> LH
            col = colorLH;
        else % Even -> RH
            col = colorRH;
        end
        set(h(:, i), 'Color', col, 'LineWidth', 1.2); 
    end

    % Add Mean Lines (Dashed) - Constrained to box width
    means = [mean(mean_LH, 'omitnan'), mean(mean_RH, 'omitnan'), ...
             mean(slope_LH, 'omitnan'), mean(slope_RH, 'omitnan'), ...
             mean(peak_LH, 'omitnan'), mean(peak_RH, 'omitnan')];
         
    halfWidth = boxWidth / 2;
    
    for i = 1:6
        plot([positions(i)-halfWidth, positions(i)+halfWidth], [means(i), means(i)], ...
             'LineStyle', '--', 'Color', 'k', 'LineWidth', 1.5);
    end

    % X-Axis Formatting
    xticks([mean(positions(1:2)), mean(positions(3:4)), mean(positions(5:6))]);
    set(gca, 'TickLabelInterpreter', 'tex', 'FontSize', 12);
    xticklabels({ ...
    'Mean [mM \cdot mm]', ...
    'Slope [mM \cdot mm / s]', ... 
    'Peak Amplitude [mM \cdot mm]'});
    ylabel('Value');
    set(gca, 'FontSize', 9);
    title(['\DeltaO_2Hb Features - ' task_name], 'FontSize', 14);

    % Statistical Significance
    p_values = [p_mean, p_slope, p_peak];
    rawData = {mean_LH, mean_RH; slope_LH, slope_RH; peak_LH, peak_RH};
    
    % Retrieve current or custom limits to position stars
    if ~isempty(custom_ylim)
        current_ylim = custom_ylim;
    else
        current_ylim = ylim;
    end
    y_range = current_ylim(2) - current_ylim(1);
    offset_step = y_range * 0.05; 
    
    for i = 1:3
        p = p_values(i);
        if p < alpha
            idxLH = 2*i - 1;
            idxRH = 2*i;
            x1 = positions(idxLH);
            x2 = positions(idxRH);
            
            % Find local maximum to place the bar
            current_data = [rawData{i,1}; rawData{i,2}];
            if ~isempty(current_data)
                max_val = max(current_data);
            else
                max_val = 0;
            end
            
            % Place bar above the highest data point (plus offset)
            y_bar = max_val + offset_step; 
            
            plot([x1, x1, x2, x2], [y_bar, y_bar+offset_step*0.5, y_bar+offset_step*0.5, y_bar], ...
                 '-k', 'LineWidth', 1.5);
             
            if p < 0.001
                star_char = ['***'];
                txt = ['p = ', num2str(p,1)];
            elseif p < 0.01
                star_char = ['**'];
                txt = ['p = ', num2str(p,1)];
            else
                star_char = ['*'];
                txt = ['p = ', num2str(p,1)];
            end
            
            % Draw p-value (lower, near the bracket)
            text(mean([x1, x2]), y_bar + offset_step * 1.5, ...
                txt, ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', ...
                'FontSize', 9); 
            
            % Draw asterisk (higher, above the p-value)
            text(mean([x1, x2]), y_bar + offset_step * 0.2, ...
                star_char, ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', ...
                'FontSize', 18, ... 
                'FontWeight', 'bold'); 
        end
    end
    
    % Set Axis Limits
    if ~isempty(custom_ylim)
        ylim(custom_ylim);
    else
        ylim auto;
    end

    % Custom Legend
    h1 = plot(nan, nan, 's', 'MarkerFaceColor', 'none', 'Color', colorLH, 'LineWidth', 2);
    h2 = plot(nan, nan, 's', 'MarkerFaceColor', 'none', 'Color', colorRH, 'LineWidth', 2);
    h3 = plot(nan, nan, '-', 'Color', 'k', 'LineWidth', 1.5);
    h4 = plot(nan, nan, '--', 'Color', 'k', 'LineWidth', 1.5);
    
    legend([h1, h2, h3, h4], ...
           {'Left Hemisphere', 'Right Hemisphere', 'Median (Solid)', 'Mean (Dashed)'}, ...
           'Location', 'best');
    hold off;
end