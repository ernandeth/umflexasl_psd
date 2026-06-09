% File to plot the rotations stored in kviews
files = dir('kviews*.txt');

nechotrains = 1;
nechos = 100;


for file_n = 1:length(files)
    filename = fullfile(files(file_n).folder, files(file_n).name);

    % Read the entire file as a numeric array
    data = readmatrix(filename, 'Delimiter', '\t');
    [nRows, nCols] = size(data);
    rot_mats = data(:, 6:14);

    % Echo Train Information
    echons = data(:, 3);
    etl = max(echons) + 1;
    nframes = floor(length(echons) / etl);
    
    % Initial vector
    v0 = [1; 0; 0];
    
    % Storage for tip positions
    tipTrajectory = zeros(nRows, 3);
    
    % Set up figure
    figure;
    hold on;
    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Animated Rotation of Vector');
    view(3);
    xlim([-1.2 1.2]);
    ylim([-1.2 1.2]);
    zlim([-1.2 1.2]);
    
    % Plot elements: trajectory and vector
    trajPlot = plot3(NaN, NaN, NaN, 'o', 'LineWidth', 1.5); % trace of tip
    vecArrow = quiver3(0, 0, 0, 0, 0, 1, 0, 'r', 'LineWidth', 2); % current vector

    if nechotrains <= 0
        nechotrains = nframes;
    end

    if nechos <= 0
        nechos = etl;
    end

    for i = 1:nechotrains
        cur_color = rand(1, 3);
        
        trajPlot = plot3(NaN, NaN, NaN, 'o', 'LineWidth', 1.5, 'Color', cur_color); % trace of tip
        %vecArrow = quiver3(0, 0, 0, 0, 0, 1, 0, 'r', 'LineWidth', 2, 'Color', cur_color); % current vector

        for j = 1:nechos
            % Extract and reshape rotation matrix
            R = reshape(rot_mats(j + (i-1) * etl,1:9), [3, 3])';
        
            % Rotate vector
            vRot = R * v0;
        
            % Save tip position
            tipTrajectory(j, :) = vRot';
        
            % Update arrow
            set(vecArrow, 'UData', vRot(1), 'VData', vRot(2), 'WData', vRot(3));
        
            % Update trajectory plot
            set(trajPlot, 'XData', tipTrajectory(1:j,1), ...
                          'YData', tipTrajectory(1:j,2), ...
                          'ZData', tipTrajectory(1:j,3));
        
            drawnow;
            %pause(0.5);
        end
    end
end