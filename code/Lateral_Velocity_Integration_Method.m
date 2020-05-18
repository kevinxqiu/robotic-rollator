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
alpha = 3;
B = eye(2);
C = [1 0];
y = (wl + wr) / 2 * 0.08255;

for k = 1 : length(t)
    
    r_k = r(k);
    if abs(r_k) < 0.05
        r_k = 0;
    end
    
    A = [0 r_k; -r_k 0];
    K = [2 * alpha * abs(r_k); (alpha^2 - 1) * r_k];
    x_hat(:,k+1) = ((A - K * C) * T + eye(2)) * x_hat(:,k) + ... 
        T * (B * [ax(k); ay(k)] + K * r_k);
    
end

RMSE_vx = sqrt(sum((x_hat(1,2:end) - (vx_actual')).^2) / length(t));
RMSE_vy = sqrt(sum((x_hat(2,2:end) - (vy_actual')).^2) / length(t));

figure(1)
plot([0 ; t], x_hat(1,:), t, vx_actual)
legend('Estimate','Vicon Data')
xlabel('Time [s]')
ylabel('Longitudanal Velocity [m/s]')

figure(2)
plot([0 ; t], x_hat(2,:), t, vy_actual)
legend('Estimate','Vicon Data')
xlabel('Time [s]')
ylabel('Lateral Velocity [m/s]')
