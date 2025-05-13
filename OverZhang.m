H = [1.8763, -0.3382, 0.0007;
     0.0579, 1.7524, 0.0002;
     -221.6571, -33.1472, 1.0000];

[U, S, V] = svd(H); % Compute SVD of H
sigma2 = S(2,2);     % Extract the second singular value
H_norm = H / sigma2; % Normalize H so that σ₂ = 1

[U, W, V] = svd(H_norm);
    Vt = V';
    
    % Get singular values
    lambda1 = W(1,1);
    lambda3 = W(3,3);
    
    lambda1m3 = (lambda1 - lambda3);
    lambda1m3_2 = lambda1m3 * lambda1m3;
    lambda1t3 = lambda1 * lambda3;
    
    t1 = 1.0 / (2.0 * lambda1t3);
    t2 = sqrt(1.0 + 4.0 * lambda1t3 / lambda1m3_2);
    t12 = t1 * t2;
    
    e1 = -t1 + t12; % t1 * (-1.0 + t2)
    e3 = -t1 - t12; % t1 * (-1.0 - t2)
    
    e1_2 = e1 * e1;
    e3_2 = e3 * e3;
    
    nv1p = sqrt(e1_2 * lambda1m3_2 + 2 * e1 * (lambda1t3 - 1) + 1.0);
    nv3p = sqrt(e3_2 * lambda1m3_2 + 2 * e3 * (lambda1t3 - 1) + 1.0);
    
    % Compute v1p and v3p vectors
    v1p = Vt(1,:)' * nv1p;
    v3p = Vt(3,:)' * nv3p;
    
    % The eight solutions are:
    % (A): tstar = +- (v1p - v3p)/(e1 - e3), n = +- (e1*v3p - e3*v1p)/(e1-e3)
    % (B): tstar = +- (v1p + v3p)/(e1 - e3), n = +- (e1*v3p + e3*v1p)/(e1-e3)
    
    v1pmv3p = v1p - v3p;
    v1ppv3p = v1p + v3p;
    
    e1v3me3v1 = e1 * v3p - e3 * v1p;
    e1v3pe3v1 = e1 * v3p + e3 * v1p;
    
    inv_e1me3 = 1.0 / (e1 - e3);
