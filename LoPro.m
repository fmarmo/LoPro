function U=LoPro(xyz,r,p,E,v)
% Evaluate displacements in a half-space due to vertical load on surface
% 
% Reference: 
% M.G. D'Urso, F. Marmo, On a generalized Love's problem.
%
% Syntax:
% U=LoPro(xyz,r,p,E,v)
%
% Description:
% U=LoPro(xyz,r,p,E,v) returns the three components of displacement at the
% point of coordinate xyz=[x;y;z] of the half-space z>0, with Young modulus
% E and Poisson ration v, generated by a vertical load p uniformly applied 
% on the polygonal region of vertices r of the surface of the half-space.
%
% Example: see TestLoPro.m
%
% Coded by:
% Francesco Marmo
% E-mail: f.marmo@unina.it
% Department of Structures for Engineering and Architecture
% University of Naples Federico II
% Italy

% Set the reference origin at xyz
rp(:,1)=-r(:,1)+ones(size(r,1),1)*xyz(1);
rp(:,2)=-r(:,2)+ones(size(r,1),1)*xyz(2);
z=xyz(3);

% Lame constants
l=E*v/((1+v)*(1-2*v));
m=E/(2*(1+v));

% Integrals
I1=intI1(rp,z);
I3=intI3(rp,z);
I4=intI4(rp,z); 

% Displacements

U(1:2,1)=-I1*p/(4*pi*(l+m));
U(3,1)=I3*p/(4*pi*m)+I4*p/(4*pi*(l+m));

if z~=0
    I2=intI2(rp,z);
    al=alpha(rp);
    U(1:2,1)=U(1:2,1)-I2*z*p/(4*pi*m);
    U(3,1)=U(3,1)-z*al*p/(4*pi*(l+m));
end


end

function I1=intI1(r,z)
% Evaluate the integral I1

nv=size(r,1);
rot=[0,1;-1,0];
I1=[0;0];

for i=1:nv
    
    ri=r(i,:)';
    
    if (i==nv)
        rj=r(1,:)';
    else
        rj=r(i+1,:)';
    end
    
    rjio=rot*(rj-ri);
    
    a=(rj-ri)'*(rj-ri);
    b=ri'*(rj-ri);
    c=ri'*ri;
    d=c+z^2;
    e=d-b^2/a;
    t0 = b/a;
    t1 = 1 + b/a; 
    
    if norm(rjio)~=0
        S1i=intS1i(a,e,z,t0,t1);
        I1=I1+S1i*rjio;
    end
end

end

function I2=intI2(r,z)
% Evaluate the integral I2

nv=size(r,1);
rot=[0,1;-1,0];
I2=0;

for i=1:nv
    
    ri=r(i,:)';
    
    if (i==nv)
        rj=r(1,:)';
    else
        rj=r(i+1,:)';
    end
    
    rjio=rot*(rj-ri);
    
    a=(rj-ri)'*(rj-ri);
    b=ri'*(rj-ri);
    c=ri'*ri;
    d=c+z^2;
    e=d-b^2/a;
    t0 = b/a;
    t1 = 1 + b/a; 
    
    if norm(rjio)~=0
        S2i=intS2i(a,e,t0,t1);
        I2=I2+rjio*S2i;
    end
end

end

function I3=intI3(r,z)
% Evaluate the integral I3

nv=size(r,1);
rot=[0,1;-1,0];
I3=0;

for i=1:nv
    
    ri=r(i,:)';
    
    if (i==nv)
        rj=r(1,:)';
    else
        rj=r(i+1,:)';
    end
    
    rjo=ri'*(rot*rj);
    
    a=(rj-ri)'*(rj-ri);
    b=ri'*(rj-ri);
    c=ri'*ri;
    d=c+z^2;
    e=d-b^2/a;
    t0 = b/a;
    t1 = 1 + b/a; 
    
    if rjo ~= 0
        S2i=intS2i(a,e,t0,t1);
        I3=I3+rjo*S2i;
    end
end

end

function I4=intI4(r,z)
% Evaluate the integral I4

nv=size(r,1);
rot=[0,1;-1,0];
I4=0;

for i=1:nv
    
    ri=r(i,:)';
    
    if (i==nv)
        rj=r(1,:)';
    else
        rj=r(i+1,:)';
    end
    
    rjo=ri'*(rot*rj);
    
    a=(rj-ri)'*(rj-ri);
    b=ri'*(rj-ri);
    c=ri'*ri;
    d=c+z^2;
    A = c/a - b^2/a^2;
    B = d/a - b^2/a^2;
    t0 = b/a;
    t1 = 1 + b/a; 
    
    if rjo ~= 0
        S3i=intS3i(a,A,B,t0,t1);
        I4=I4+rjo*S3i;
    end
end

end

function S1i=intS1i(a,e,z,t0,t1)
% Evaluate the integral S1i

S1i = (sqrt(a)*t0 - sqrt(a)*t1);

if (e - z^2)~=0
	S1i = S1i - ... 
        sqrt(e - z^2)*atan((sqrt(a)*t0)/sqrt(e - z^2)) + ... 
        sqrt(e - z^2)*atan((sqrt(a)*t1)/sqrt(e - z^2)) + ... 
        sqrt(e - z^2)*atan((sqrt(a)*t0*z)/(sqrt(e + a*t0^2)*sqrt(e - z^2))) - ... 
        sqrt(e - z^2)*atan((sqrt(a)*t1*z)/(sqrt(e + a*t1^2)*sqrt(e - z^2)));
end

if z~=0
	S1i = S1i - ...
        z*log(a*t0 + sqrt(a)*sqrt(e + a*t0^2)) + ... 
        z*log(a*t1 + sqrt(a)*sqrt(e + a*t1^2));
end

if t0~=0
    S1i = S1i - ... 
        sqrt(a)*t0*log(sqrt(e + a*t0^2) + z);
end

if t1~=0
    S1i = S1i + ... 
        sqrt(a)*t1*log(sqrt(e + a*t1^2) + z);
end
  
S1i=S1i/sqrt(a);

end

function S2i=intS2i(a,e,t0,t1)
% Evaluate the integral S2i

S2i = (log((a*t1+sqrt(a*(a*t1^2+e)))/(a*t0+sqrt(a*(a*t0^2+e)))))/sqrt(a);

end

function S3i=intS3i(a,A,B,t0,t1)
% Evaluate the integral S3i

S3i=atan(t1*sqrt((B-A)/(A*(B+t1^2))))-atan(t0*sqrt((B-A)/(A*(B+t0^2))));
S3i=S3i*sqrt((B-A)/A)+log((t1+sqrt(B+t1^2))/(t0+sqrt(B+t0^2)));
S3i=S3i/sqrt(a);

end

function a=alpha(r)
% Evaluate the angular measure alpha

a=0;
for i=1:length(r)
    
    ri=r(i,:);
    if i<length(r)
        rj=r(i+1,:);
    else
        rj=r(1,:);
    end
    if norm(rj)>0 && norm(ri)>0
       
        aj=atan2(rj(2),rj(1));
        ai=atan2(ri(2),ri(1));
        da=aj-ai;
        if da > pi
            da=da-2*pi;
        end
        if da< -pi
            da=da+2*pi;
        end
        if abs(da)==pi
            da=0;
        end
        a=a+da;
   end
   
end

end

