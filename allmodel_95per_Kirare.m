%% Function: wprctile

%% Description: to calculate weighgted percentile for Kirare

%% Input: Data files

%% Output: Weighted percentile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% for Kirare Scenario0
weight=0;
Frequency=0;
load('Data_SSA_modelonly.mat')
y(isnan(y))=0;
a0=length(nonzeros(y(:,1)));
num0(1:a0,1)=y(1:a0,1);
load('Data_Kirare_LYMPHASIM.mat')
x(isnan(x))=0;
b0=length(nonzeros(x(:,1)));
num0(a0+1:a0+b0,1)=x(1:b0,1);
load('Data_Kirare_TRANSFIL_Scen0.mat')
y(isnan(y))=0;
c0=length(nonzeros(y(:,1)));
num0(a0+b0+1:a0+b0+c0,1)=y(1:c0,1);

b=length(num0);
a=unique(num0);
for i = 1:length(a)
        Frequency(i) = sum(num0(1:b) == a(i));
end
for i = 1:length(a)
        weight(i) = Frequency(i)/b;
end
d0 = wprctile(a,[2.5 97.5],Frequency);
c0=wprctile(a,[2.5 97.5],weight);


%% for Kirare Scenario1
weight=0;
Frequency=0;
load('Data_Kirare_EPIFIL.mat')
x(isnan(x))=0;
a1=length(nonzeros(x(:,1)));
num1(1:a1,1)=x(1:a1,1);
load('Data_Kirare_LYMPHASIM.mat')
x(isnan(x))=0;
b1=length(nonzeros(x(:,2)));
num1(a1+1:a1+b1,1)=x(1:b1,2);
load('Data_Kirare_TRANSFIL.mat')
x(isnan(x))=0;
c1=length(nonzeros(x(:,1)));
num1(a1+b1+1:a1+b1+c1,1)=x(1:c1,1);

b=length(num1);
a=unique(num1);
for i = 1:length(a)
        Frequency(i) = sum(num1(1:b) == a(i));
end
for i = 1:length(a)
        weight(i) = Frequency(i)/b;
end
d1 = wprctile(a,[2.5 97.5],Frequency);
c1=wprctile(a,[2.5 97.5],weight);

%% for Kirare Scenario2
weight=0;
Frequency=0;
load('Data_Kirare_EPIFIL.mat')
x(isnan(x))=0;
a2=length(nonzeros(x(:,2)));
num2(1:a2,1)=x(1:a2,2);
load('Data_Kirare_LYMPHASIM.mat')
x(isnan(x))=0;
b2=length(nonzeros(x(:,3)));
num2(a2+1:a2+b2,1)=x(1:b2,3);
load('Data_Kirare_TRANSFIL.mat')
x(isnan(x))=0;
c2=length(nonzeros(x(:,2)));
num2(a2+b2+1:a2+b2+c2,1)=x(1:c2,2);

b=length(num2);
a=unique(num2);
for i = 1:length(a)
        Frequency(i) = sum(num2(1:b) == a(i));
end
for i = 1:length(a)
        weight(i) = Frequency(i)/b;
end
d2 = wprctile(a,[2.5 97.5],Frequency);
c2=wprctile(a,[2.5 97.5],weight);


%% for Kirare Scenario3
weight=0;
Frequency=0;
load('Data_Kirare_EPIFIL.mat')
x(isnan(x))=0;
a3=length(nonzeros(x(:,3)));
num3(1:a3,1)=x(1:a3,3);
load('Data_Kirare_LYMPHASIM.mat')
x(isnan(x))=0;
b3=length(nonzeros(x(:,4)));
num3(a3+1:a3+b3,1)=x(1:b3,4);
load('Data_Kirare_TRANSFIL.mat')
x(isnan(x))=0;
c3=length(nonzeros(x(:,3)));
num3(a3+b3+1:a3+b3+c3,1)=x(1:c3,3);

b=length(num3);
a=unique(num3);
for i = 1:length(a)
        Frequency(i) = sum(num3(1:b) == a(i));
end
for i = 1:length(a)
        weight(i) = Frequency(i)/b;
end
d3 = wprctile(a,[2.5 97.5],Frequency);
c3=wprctile(a,[2.5 97.5],weight);

%% for Kirare Scenario4
weight=0;
Frequency=0;
load('Data_Kirare_EPIFIL.mat')
x(isnan(x))=0;
a4=length(nonzeros(x(:,4)));
num4(1:a4,1)=x(1:a4,4);
load('Data_Kirare_LYMPHASIM.mat')
x(isnan(x))=0;
b4=length(nonzeros(x(:,5)));
num4(a4+1:a4+b4,1)=x(1:b4,5);
load('Data_Kirare_TRANSFIL.mat')
x(isnan(x))=0;
c4=length(nonzeros(x(:,4)));
num4(a4+b4+1:a4+b4+c4,1)=x(1:c4,4);

b=length(num4);
a=unique(num4);
for i = 1:length(a)
        Frequency(i) = sum(num4(1:b) == a(i));
end
for i = 1:length(a)
        weight(i) = Frequency(i)/b;
end
d4 = wprctile(a,[2.5 97.5],Frequency);
c4=wprctile(a,[2.5 97.5],weight);

save(sprintf('Allmodel_95per_Kirare.mat'),...
        'd0','d1','d2','d3','d4');