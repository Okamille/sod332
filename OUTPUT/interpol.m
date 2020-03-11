%-----------------------------------
%% 
% fonction d'interpolation de topt en un point x=(X,Y) quelconque de R^4:

function val=interpol(x)
global Topt
global xmin xmax xmesh ymesh
global nn dx
global INF 

x1=x(1);x2=x(2);x3=x(3);x4=x(4);
dx1=dx(1);dx2=dx(2);dx3=dx(3);dx4=dx(4);
x1min=xmin(1);x2min=xmin(2);x3min=xmin(3);x4min=xmin(4);
x1max=xmax(1);x2max=xmax(2);x3max=xmax(3);x4max=xmax(4);

xm1=xmesh; xm2=ymesh; xm3=xmesh; xm4=ymesh;

topt=Topt;

if (x1>=xmax(1) | x2>=xmax(2) | x3>=xmax(3) | x4>=xmax(4) | ...
        x1<=xmin(1) | x2<=xmin(2) | x3<=xmin(3) | x4<=xmin(4) )
  val=INF;
else  
  % on determine la maille contenant xi, puis interpolation
  i1=floor((x1-x1min)/dx1)+1;  i1=min(i1,nn(1)-1); p1=(x1-xm1(i1))/dx1; 
  i2=floor((x2-x2min)/dx2)+1;  i2=min(i2,nn(2)-1); p2=(x2-xm2(i2))/dx2;
  i3=floor((x3-x3min)/dx3)+1;  i3=min(i3,nn(3)-1); p3=(x3-xm3(i3))/dx3;
  i4=floor((x4-x4min)/dx4)+1;  i4=min(i4,nn(4)-1); p4=(x4-xm4(i4))/dx4;
  i=i3;     j=i4; t11 = (1-p1)*(1-p2)*topt(i1,i2,i,j) + p1*(1-p2)*topt(i1+1,i2,i,j) + (1-p1)*p2*topt(i1,i2+1,i,j) + p1*p2*topt(i1+1,i2+1,i,j);
  i=i3+1;   j=i4; t21 = (1-p1)*(1-p2)*topt(i1,i2,i,j) + p1*(1-p2)*topt(i1+1,i2,i,j) + (1-p1)*p2*topt(i1,i2+1,i,j) + p1*p2*topt(i1+1,i2+1,i,j);
  i=i3;   j=i4+1; t12 = (1-p1)*(1-p2)*topt(i1,i2,i,j) + p1*(1-p2)*topt(i1+1,i2,i,j) + (1-p1)*p2*topt(i1,i2+1,i,j) + p1*p2*topt(i1+1,i2+1,i,j);
  i=i3+1; j=i4+1; t22 = (1-p1)*(1-p2)*topt(i1,i2,i,j) + p1*(1-p2)*topt(i1+1,i2,i,j) + (1-p1)*p2*topt(i1,i2+1,i,j) + p1*p2*topt(i1+1,i2+1,i,j);
  val= (1-p3)*(1-p4)*t11 + p3*(1-p4)*t21 + (1-p3)*p4*t12 + p3*p4*t22;
end
end

