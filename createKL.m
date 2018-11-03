K = zeros(1, 2);
K(1) = omega_c^2 * m;
K(2) = zeta_c*2*m*omega_c - c;

k_r = K(1);

L = zeros(2, 1);
L(1) = 2* zeta_o * omega_o - c / m;
L(2) = omega_o^2 -2 * zeta_o * omega_o * c /m + c^2/m^2;
