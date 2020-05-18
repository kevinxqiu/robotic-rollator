ax = all_data(:,2) * 9.81 / 100.;
ay = all_data(:,3) * 9.81 / 100.;
r = all_data(:,4) * pi / 180;
wl = all_data(:,5);
wr = all_data(:,6);
vx_actual = all_data(:,11);
vy_actual = all_data(:,10);

T = 0.004;
t = (1:length(all_data))' * T;
x_hat = zeros(2,length(t) + 1);
Q = [0.001 0; 0 0.001];
R = [0.1 0; 0 0.1];
w_k = diag(Q);
v_k = diag(R);
P = 1;
y = [((wl + wr) / 2 * 0.08255)'; (all_data(:,13))']; %[vx_meas using wheel encoders, predicted vy]
H = [1 0; 0 1];

for k = 1 : length(t)
    
    %prediction
    F = [1 r(k)*T; -r(k)*T 1];
    x_hat_priori = F * x_hat(:,k) + T * [ax(k); ay(k)] + w_k * randn;
    P_priori = F * P * F' + Q;
    
    %update
    y_k = y(:,k) + v_k * randn;
    h = x_hat_priori;
    K = P_priori * H' / (H * P_priori * H' + R);
    P = (eye(2) - K * H) * P_priori;
    x_hat(:,k+1) = x_hat_priori + K * (y_k - h);
    
end

RMSE_vx = sqrt(sum((x_hat(1,2:end) - (vx_actual')).^2) / length(t));
RMSE_vy = sqrt(sum((x_hat(2,2:end) - (vy_actual')).^2) / length(t));
RMSE_TCN = sqrt(sum((x_hat(2,2:end) - (all_data(:,13))').^2) / length(t));

figure(1)
plot([0 ; t], x_hat(1,:), t, vx_actual)
legend('Estimate','Vicon Data')
xlabel('Time [s]')
ylabel('Longitudanal Velocity [m/s]')

figure(2)
plot([0 ; t], x_hat(2,:), t, (all_data(:,13))')
hold on
plot(t, vy_actual, 'LineWidth', 2)
hold off
legend('KF + TCN','TCN','Vicon Data')
xlabel('Time [s]')
ylabel('Lateral Velocity [m/s]')

figure(3)
plot(t, (all_data(:,13))', t, vy_actual)
legend('Estimate','Vicon Data')
xlabel('Time [s]')
ylabel('Lateral Velocity [m/s]')