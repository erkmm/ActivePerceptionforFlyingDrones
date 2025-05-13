H = [1.8763, -0.3382, 0.0007;
     0.0579, 1.7524, 0.0002;
     -221.6571, -33.1472, 1.0000];

[U, S, V] = svd(H);
H_normalized = H / S(2,2);  % Now σ₂ = 1

N = H_normalized' * H_normalized;
[evec, eval] = eig(N);
eval = diag(eval);
[val_sorted, idx] = sort(eval, 'descend');  % λ₁ ≥ λ₂ ≥ λ₃

% Force λ₂ = 1 if needed (numerical stability)
if abs(val_sorted(2) - 1) > 1e-6
    warning("Adjusting λ₂ to 1.");
    val_sorted(2) = 1;
end

lambda1 = val_sorted(1);
lambda3 = val_sorted(3);

% Check if the term under sqrt is positive
term1 = 1 + (4 * lambda1 * lambda3) / (lambda1 - lambda3)^2;
term3 = 1 - (4 * lambda1 * lambda3) / (lambda1 - lambda3)^2;

if term1 < 0 || term3 < 0
    error("Invalid eigenvalues: Cannot compute real τ₁ and τ₃.");
end

tau1 = 1/(2*lambda1*lambda3) + (-1 + sqrt(term1));
tau3 = 1/(2*lambda1*lambda3) + (-1 - sqrt(term3));

v1_abs = tau1^2*(lambda1-lambda3)^2+2*tau1*(lambda1*lambda3-1)+1;
v3_abs = tau3^2*(lambda1-lambda3)^2+2*tau3*(lambda1*lambda3-1)+1;

v1 = v1_abs*vec_1;
v3 = v3_abs*vec_3;

% Compute t_dot and n
t_dot = (v1 - v3) / (tau1 - tau3);
n = (tau1 * v3 - tau3 * v1) / (tau1 - tau3);

% Compute rotation (use pinv for stability)
Rot = H_normalized * pinv(eye(3) + t_dot * n');