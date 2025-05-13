K = [[320, 0, 385];[0 320 415];[0, 0, 1]];
H = [1.8763, -0.3382, 0.0007;
     0.0579, 1.7524, 0.0002;
     -221.6571, -33.1472, 1.0000];
H_normalized = H / norm(H, 'fro');
H_calib = inv(K) *H_normalized * K;

[U,D,V] = svd(H_calib);
D