%----------------------------------------------------
%- loading data.dat and initialisation of parameters
%----------------------------------------------------

filePrefix=[TEST,'-'];
dataFile=[filePrefix, 'data.dat'];
param=load(dataFile,'-ascii'); %- problem & mesh parameters

global nn

i=1;
dim =param(i); i=i+1;
MESH=param(i); i=i+1;    %% MESH: pour definir si le point est au milieu de
                         %% la cellule ou au bord.

dx=zeros(1,dim); xmin=zeros(1,dim); xmax=zeros(1,dim); nn=zeros(1,dim);
for d=1:dim
  dx(d)=param(i); i=i+1;
end
for d=1:dim
  xmin(d)=param(i); i=i+1;
  xmax(d)=param(i); i=i+1;
  fprintf('d=%i, xmin(d)=%6.3f, xmax(d)=%6.3f\n',d,xmin(d),xmax(d));
end
for d=1:dim
  nn(d)=param(i); i=i+1;
end

T=param(i); i=i+1;
V_EXACT = param(i); i=i+1; %- In C++, put 1 if the exact front is known

dimcoupe = param(i); i=i+1; %-here param(i) contains the dimension of the cut

 
%===========
%% Lecture d'une coupe de la fonction temps minimal 
coupe_dims=zeros(dim,1); coupe_vals=zeros(dim,1);
for d=1:dim,
    coupe_dims(d) = param(i); i=i+1;
    fprintf('coupe_dims(%i)=%2i; ',d,coupe_dims(d));
  end
  fprintf('\n');
  
  cdd = find(coupe_dims==1);

  for d=1:dim
    coupe_vals(d) = param(i); i=i+1; %Nb : only values for which coupe_dims(d)=1 are meaningful
  end


%==============================================================
%% Valeures sauvegardees au temps final ou temps intermediaires
%==============================================================
save_vfall=param(i); i=i+1; %% =1 means several values of VF
                            %% =0 means (at most) final VF at final time 
nbSaves=param(i); i=i+1;    
nbTraj=param(i); i=i+1;
fprintf('nbTraj (nombre de trajectoires)=%2i\n',nbTraj);
TRAJECTORY=(nbTraj>=1);

%==============================================================
%  VALUE_PB, SAVE_COUPE_ALL, nbSavesCoupe
%==============================================================
VALUE_PB=param(i); i=i+1;

SAVE_COUPE_ALL=param(i); i=i+1;
nbSavesCoupe=param(i); i=i+1; 


FILE=[filePrefix 'coupetopt.dat'];
fprintf(strcat('loading TOPT_COUPE (',FILE,')... '));
          
TITLE=FILE; 
[status,result]=unix(strcat('ls ./',FILE));
    if status==2;
        fprintf('%s not found,\n',FILE);
        return;
    end
data=load(FILE);	%- 2d
fprintf('DONE\n');

    xi(:,1:2)=data(:,1:2);
    val=data(:,3);
    Topt_Coupe=zeros(nn(cdd(1)),nn(cdd(2)));
    Topt_Coupe(:)=val;
    XMIN = repmat(xmin(cdd),length(xi),1);
    DX   = repmat(dx(cdd),length(xi),1);
    x = XMIN + xi.*DX + (1-MESH)*DX/2;  
    
    xmesh=x(1:nn(cdd(1)),1);
    ymesh=x(nn(cdd(1))*(1:nn(cdd(2))),2);
        

%- Chargement du fichier topt.dat:
fprintf('loading topt.dat file (into topt0)...');
FILE0=[filePrefix 'topt.dat'];
topt0=load(FILE0);
fprintf('done. \n');

%- Preparation du fichier topt
fprintf('preparation de l''hypermatrice topt...');
Topt=zeros(nn(1),nn(2),nn(3),nn(4));
j=0;
for i4=1:nn(4)
for i3=1:nn(3)
for i2=1:nn(2)
for i1=1:nn(1)
  j=j+1;
  Topt(i1,i2,i3,i4)=topt0(j,5);
end
end
end
end
fprintf('done. \n');
