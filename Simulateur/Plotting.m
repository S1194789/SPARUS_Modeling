%% here you can implement the code in order to have some figures ...
%%
global Para

%% Positions
% Linear Position
T= (1:size(PosE,1))*0.01;
figure(1)
subplot(2, 2, 1); % 2 rows, 1 column, 1st subplot
set(gcf,'Name', 'Positions')

plot(T,PosE_S(:,1))
hold on
plot(T,PosE_S(:,2))
plot(T,PosE_S(:,3))
hold off
grid on
legend('surge','sway','heave')
title('Positions')
xlabel('t [s]');
ylabel('Positions [m]');

% Angular Position
subplot(2, 2, 2); % 2 rows, 1 column, 1st subplot

set(gcf,'Name', 'Angular Position');

plot(T,180*PosE_S(:,4)/pi);
hold on
plot(T,180*PosE_S(:,5)/pi)
plot(T,180*PosE_S(:,6)/pi)
hold off
grid on
legend('roll','pitch','yaw')
title('Angular Positions')
xlabel('t [s]');
ylabel('Angles [deg]');


%% Velocities

% Linear Position
T= (1:size(PosE,1))*0.01;
subplot(2, 2, 3); % 2 rows, 1 column, 1st subplot

set(gcf,'Name', 'Linear Velocity')

plot(T,VitB_S(:,1))
hold on
plot(T,VitB_S(:,2))
plot(T,VitB_S(:,3))
hold off
grid on
legend('surge','sway','heave')
title('Linear Velocity')
xlabel('t [s]');
ylabel('Linear Velocity [m.s-1]');

% Angular Position
subplot(2, 2, 4);

set(gcf,'Name', 'Angular Velocity');

plot(T,180*VitB_S(:,4)/pi);
hold on
plot(T,180*VitB_S(:,5)/pi)
plot(T,180*VitB_S(:,6)/pi)
hold off
grid on
legend('roll','pitch','yaw')
title('Angular Velocity')
xlabel('t [s]');
ylabel('Anglular velocity [deg.s-1]');




%% Acceleration


% Linear Position
figure(2)
subplot(2, 1, 1);
set(gcf,'Name', 'Linear Acceleration')

plot(T,AccB_S(:,1))
hold on
plot(T,AccB_S(:,2))
plot(T,AccB_S(:,3))
hold off
grid on
legend('surge','sway','heave')
title('Linear Acceleration')
xlabel('t [s]');
ylabel('Linear Acceleration [m.s-2]');

% Angular Position
subplot(2, 1, 2);

set(gcf,'Name', 'Angular Acceleration');

plot(T,180*AccB_S(:,4)/pi);
hold on
plot(T,180*AccB_S(:,5)/pi)
plot(T,180*AccB_S(:,6)/pi)
hold off
grid on
legend('roll','pitch','yaw')
title('Angular Acceleration')
xlabel('t [s]');
ylabel('Angular Acceleration [deg.s-2]');



%% 3D movement

x = PosE_S(:, 1); 
y = PosE_S(:, 2); 
z = -PosE_S(:, 3); 
time = T; 
disp(z(1:100, :)); 
min(z) 
max(z) 

figure(3);
plot3(x, y, z, 'LineWidth', 2);
grid on;
hold on;

% Mark the start and end points
plot3(x(1), y(1), z(1), 'go', 'MarkerSize', 10, 'LineWidth', 2); % Start point (green circle)
plot3(x(end), y(end), z(end), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % End point (red circle)

% Annotate the start and end points
text(x(1), y(1), z(1), '  Start', 'FontSize', 12, 'Color', 'green');
text(x(end), y(end), z(end), '  End', 'FontSize', 12, 'Color', 'red');

xlabel('X Position (m)', 'FontSize', 12);
ylabel('Y Position (m)', 'FontSize', 12);
zlabel('Z Position (m)', 'FontSize', 12);
title('3D Trajectory of Sparus AUV', 'FontSize', 16);

% Update the Z-axis tick labels to show negative values
z_ticks = get(gca, 'ZTick'); % Get current Z-tick values
set(gca, 'ZTickLabel', arrayfun(@num2str, -z_ticks, 'UniformOutput', false)); % Make them negative

legend('AUV Trajectory', 'Location', 'best');
hold off;