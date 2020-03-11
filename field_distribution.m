function [P, z, nz] = field_distribution(lambda,theta,d,n,r,t,pol)

if length(theta) ~= 1 || length(r) ~= 1 || length(lambda) ~= 1
    error('Inputs should be scalars')
end

K=2*pi/lambda;

i=length(d);
while n(i-1)==n(end)
    d(i-1)=0;
    i=i-1;
end
dsub = d(1);
d(1) = 0;
dair = d(end);
d(end)=0;


% determining an optimal resolution, 20 points on the thinnest layer
step = min(d(d~=0))/20;
sz = round(sum(d)/step);          % size of z vector
z  = linspace(0,sum(d),sz);
nz = ones(1,sz);

zv =[0; cumsum(d)];

for i=1:sz
    for j=length(d):-1:1
        if (z(i) < zv(j+1)) && (z(i) >= zv(j))
            nz(i)=n(j);
        end
    end
end

nz(1)=n(1);
nz(end)=n(end);
step = z(2)-z(1);

z_sub = -dsub : step : -step;
sz_sub = length(z_sub);
nz_sub = n(1)*ones(1,sz_sub);

z_air = step : step : dair;
sz_air = length(z_air);
nz_air = n(end)*ones(1,sz_air);

theta=theta/180*pi;
beta = n(1)*sin(theta);
costheta_z = sqrt(nz.^2-beta^2)./nz;  

% There are two methods of proceiding:
% - the first one is the TMM applied from left to right, where
%   Eout = T * Ein
%   i.e. field on te right of the interface is equal to matrix T times
%   field on the left (assuming input field comes from the left
%   All vectors and matrices that refer to this metod have suffix t
% - the second one is the TMM applied from right to left, where
%   Ein = D * Ein
%   All vectors and matrices that refer to this method have suffix d
%
% They are absolutely equivalent, but the matrices T and D use
% diffrent fresnel coefficients and the results might differ a little
% bit when propagation is considered on long distances (due to
% intabylity of complex number matrices)



Et=zeros(2,sz);
Et(1,1)=1;
Et(2,1)=r;
Mt = eye(2);

Et_air=zeros(2,sz_air);
Et_sub=zeros(2,sz_sub);

Ed=zeros(2,sz);
Ed(1,end)=t;
Ed(2,end)=0;
Md = eye(2);    

Ed_air=zeros(2,sz_air);
Ed_sub=zeros(2,sz_sub);

for i=1:sz-1
    kt=K*nz(i);
    Pt = prop(kt,z(i+1)-z(i),costheta_z(i));
    Mt = Pt*Mt;
    if nz(i) ~= nz(i+1)
        T = Tij(nz(i),nz(i+1),beta,pol);
        Mt = T*Mt;
    end
    
    Et(:,i+1)  = Mt*[1;r];
end  

for i=sz:-1:2
    if nz(i)~=nz(i-1)
        D = Dij(nz(i-1),nz(i),beta,pol);
        Md= D*Md;
    end
    kd=K*nz(i-1);
    Pd = prop(kd,z(i-1)-z(i),costheta_z(i-1)) ;
    Md = Pd*Md;
    
    Ed(:,i-1) = Md*[t;0];
end

z  = [z_sub,   z, z_air+z(end)];
nz = [nz_sub, nz, nz_air];
% z  = [ z, z_air+z(end)];
% nz = [nz, nz_air];

Et_air(1,:) = Et(1,end)*exp(+1i*K*nz(end)*costheta_z(end)*z_air);
Et_sub(1,:) = Et(1,1)*exp(+1i*K*nz(1)*costheta_z(1)*z_sub);
Et_sub(2,:) = Et(2,1)*exp(-1i*K*nz(1)*costheta_z(1)*z_sub);
Et=[Et_sub, Et, Et_air];
% Et=[Et, Et_air];

Ed_air(1,:) = Ed(1,end)*exp(+1i*K*nz(end)*costheta_z(end)*z_air);
Ed_sub(1,:) = Ed(1,1)*exp(+1i*K*nz(1)*costheta_z(1)*z_sub);
Ed_sub(2,:) = Ed(2,1)*exp(-1i*K*nz(1)*costheta_z(1)*z_sub);
Ed=[Ed_sub, Ed, Ed_air];
% Ed=[Ed, Ed_air];

if pol == 'p'
    H_correction=nz/physconst('lightspeed');
else
    H_correction=ones(1,sz+sz_air+sz_sub);
end

figure
plot(z,abs(Ed(1,:)+Ed(2,:)).^2,z,abs(Et(1,:)+Et(2,:)).^2,...
     z,real(nz)*400);
nicePlot
ylim([0 1400])
P = abs((Ed(1,:)+Ed(2,:)).*H_correction).^2;

end