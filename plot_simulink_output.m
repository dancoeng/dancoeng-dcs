clc; close all;
sim('First_Order_system');
time = err(:, 1);

% Control Action
h = figure(1);
plot(time, u(:, 2), 'LineWidth', 1.5);
grid on
xlabel('time')
ylabel('Control Action (u)')
title('Control Action (u) Vs Time')
print(h,'-dpng','-r1000','Control_Action')

% Error
h = figure(2);
plot(time, err(:, 2), 'LineWidth', 1.5);
grid on
xlabel('time')
ylabel('error = y - y_m')
title('Error Between the Required Model Output and the Actual Output')
print(h,'-dpng','-r1000','Error')

% Output
h = figure(3);
hold all
plot(time, output(:, 2), 'LineWidth', 1.5);
plot(time, output(:, 3), 'LineWidth', 1.5);
plot(time, output(:, 4), 'LineWidth', 1.5);
plot(time, output(:, 5), 'LineWidth', 1.5);
grid on
xlabel('time')
ylabel('Simulation Output')
title('Simulation Output Vs Time')
legend('G_m Model Output', 'Adjusted Output', 'Feedback of Ordinary System Output', 'Input (Required Output)')
print(h,'-dpng','-r1000','Output')

% Control Parameters
h = figure(4);
hold all
plot(time, ContParam(:, 2), 'LineWidth', 1.5);
plot(time, ContParam(:, 3), 'LineWidth', 1.5);
grid on
xlabel('time')
ylabel('Control Parameters')
title('Control Parameters Vs Time')
legend('t_0', 's_0')
print(h,'-dpng','-r1000','Control_Parameters')
