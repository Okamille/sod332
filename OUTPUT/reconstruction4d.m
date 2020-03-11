function Zlist=reconstruction4d(Start_Player1,Start_Player2)

global topt INF
    global xmesh ymesh 
    global xmin xmax 
    global dx nn
%===============================================================
%- Trajectory reconstruction Algorithm -  Minimum Time Function
%===============================================================
%- The dynamic programming principle can be written as: inf_theta tmin(y_x(h)) = tmin(x)-h
%- The state trajectory satisfies an approximation in the following form: y_x(h) = x + h f(x,a,b(t)) (or RK2),

F_dynamics = @(x,a,alpha,b,beta) [a*cos(alpha); a*sin(alpha); b*cos(beta); b*sin(beta)];


xm1=xmesh;      % Grid points on the X-axis
xm2=ymesh;      % Grid points on the Y-axis


%-----------------------------------
%- discretisation of the control variables
%- ulist=(0:Nu-1)/Nu*2*pi;
%-----------------------------------
N=20;

%%%
%% SUGGESTION - Changer ces valeurs ici et dans le fichier paramsTwoPlayers.dat
%% Pour analyser ce qui se passe lorsque le rapport des vitesses change entre les deux
%% joueurs
%% 
bmin = 0;
bmax = 0.8;
amin = 0;
amax = 1;

%% Discretisation de l'ensemble des commandes
alphalist=(0:N-1)/N * 2*pi;
alist=(0:N)/N;    %%- CORRIGE

%- Time step
h=min(dx(1),dx(2));
h=h/2;
fprintf('Le pas de reconstruction h=%8.5f\n',h);


%------------------------------------------------------
%- Trajectory reconstruction
%------------------------------------------------------

X=[Start_Player1(1); Start_Player1(2)]; %- point initial (Player 1)
Y=[Start_Player2(1); Start_Player2(2)]; %- point initial (Player 2)
    
Z=[X;Y];    % Point initial des deux joueurs     
    
t=0;        %- temps initial
ITERMAX=0;

res=interpol(Z);
fprintf('t=%5.3f, X=%7.3f %7.3f, tmin=%7.3f\n',t,X(1),X(2),res);
input('Press the button to continue the reconstruction of an optimal trajectory');

Zlist=[Z', res, t]; %- liste des positions, tmin corresondant, temps correspondant

eps=1e-4;   % seuil de temps pour arret des iterations
            


%%%%%%%%%%%%%%%%%%%%%%
%%
%%  SUGGESTION:  VOUS POUVEZ DEFINIR PLUSIEURS FONCTIONS (b(.),beta(.)
%%  POUR MIEUX ANNALYSER la RECONSTRUCTION DE TRAJECTOIRES  
%%  
 LOI=6;
switch LOI
case 1
  %- LOI 1
  bvit  = @(t) bmax;
  bang  = @(t) -3*pi/4;
case 2
  %- LOI 2
  bvit  = @(t) bmax;
  bang  = @(t) pi;
case 3
  %- LOI 3
  bvit  = @(t) bmax;
  bang  = @(t) 2*pi/3;
case 4
  %- LOI 4
  bvit  = @(t) bmax;
  bang  = @(t) pi*(t<=1)+2*pi/3*(t>1);
case 5 
  %- LOI 5
  bvit  = @(t) bmax;
  bang  = @(t) rand(1)*2*pi;
case 6
  bvit = @(t) bmax;
  bang = @(t) pi/2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%


while (res>=eps && ITERMAX<=30)
  ITERMAX=ITERMAX+1;
  b = bvit(t);
  beta = bang(t);
  
  best_time = inf;
  best_alpha = 0;
  best_a = 0;
  
  % TODO : change this
  RR = 1.2;
  
  for a = alist
      for alpha = alphalist
          Z_temp = Z + h * F_dynamics(Z, a, alpha, b, beta);
          t_temp = interpol(Z_temp);
          if (Z_temp(1) - Z_temp(3))^2 + (Z_temp(2) - Z_temp(4))^2 < RR
              respect_constraint = false;
          else
              respect_constraint = true;
          end
          if t_temp < best_time && respect_constraint
             best_time = t_temp;
             best_alpha = alpha;
             best_a = a;
          end
      end
  end
  
  % Step 2
  Z = Z + h * F_dynamics(Z, best_a, best_alpha, b, beta);
  res = interpol(Z);
  
  % Step 3
  t = t + h; 
  Znew= Z;
  Z=Znew;
  
  %% ICI CORRECTION: 
  Zlist= [Zlist; [Z', res, t]]; 

  % Compute the next optimal position
  fprintf('t=%5.3f, Joueur1=%7.3f %7.3f, Joueur2=%7.3f %7.3f, tmin=%7.3f\n',t,Z(1),Z(2),Z(3),Z(4),res);
  
  if res>=INF-10
    fprintf('Minimum Time = inf - STOP\n');
    break;
  end
  if res<eps
    fprintf('Minimum Time < eps ==> OK , An optimal trajctory is computed\n');
  end
end
end

%-----------------------------------
%% 
% fonction d'interpolation de topt en un point x=(X,Y) quelconque de R^4:

function val=interpol2(x)
global topt
global xmin xmax xmesh ymesh
global nn dx
global INF 

x1=x(1);x2=x(2);x3=x(3);x4=x(4);
dx1=dx(1);dx2=dx(2);dx3=dx(3);dx4=dx(4);
x1min=xmin(1);x2min=xmin(2);x3min=xmin(3);x4min=xmin(4);
x1max=xmax(1);x2max=xmax(2);x3max=xmax(3);x4max=xmax(4);

xm1=xmesh; xm2=ymesh; xm3=xmesh; xm4=ymesh;

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

