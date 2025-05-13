H_we= [0.9660    0.1056    0.0002;
    -0.5013    0.6468   -0.0011;
    73.9933   -8.5384    1.0000];       
K = [[1109, 0, 320];[0 1109 180];[0, 0, 1]];
H_we_calib= inv(K)*H_we*K;
[U,D,V] = svd(H_we_calib);
eig1 = D(1,1);
eig2 = D(2,2);
eig3 = D(3,3);

si = sqrt((eig1^2-eig2^2)/(eig2^2-eig3^2));
s = det(U)*det(V);
alfa = (eig1+s*eig3*si^2)/(eig2*(1+si^2));
beta = -sqrt(1-alfa^2);

R = U*[alfa 0 beta; 0 1 0; -s*beta 0 s*alfa]*transpose(V);
w=1/(7.6546*10^10);
n1 = w*(si*V(:,1)+V(:,3));
t2 = (1/w)*(-beta*U(:,1)+(eig3/eig2-s*alfa)*U(:,3));
d1 = 3;

H_new = R*(eye(3)-t2*transpose(n1)/d1);

H_real = K*H_new*inv(K);