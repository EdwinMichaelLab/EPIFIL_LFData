%% Function: median, Entropy, var, prctile, vartestn, vartest2

%% Description: To extrat data from the Excel files and calculate
% elimination timelines, weighted variance, median, 95% elimination
% timelines, entropy, normalised entropy and perform F-test

%% Input: Excel files

%% Output: elimination timelines, weighted variance, median, 95% elimination
% timelines, entropy, normalised entropy and F test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 




type={'Kirare','Alagramam','Peneng'}; % sites
Scenario={'A1','A2','A3','A4'}; % scenarios

j=1;
k=2;
NumRounds=[];


x=zeros(60000,4);
x(:,:)=NaN;
%% to extract data from the Excel files
for itype=1:length(type)
    if itype==1
       
        [num,txt,raw]=xlsread('TRANSFIL_Kirare.xlsx');
        Scennum=[1 17625 ;
            17626 24039  ;
            24040 26147  ;
            26148 31552  ];
        colnum=2;
    elseif itype==2
        
        [num,txt,raw]=xlsread('TRANSFIL_Alagramam.xlsx');
         Scennum=[1 9109 ;
            9110 14664  ;
            14665 15192  ;
            15193 15575  ];
        colnum=2;
    else
        [num,txt,raw]=xlsread('TRANSFIL_Peneng.xlsx');
         Scennum=[1 55425 ;
            55426 64317  ;
            64318 71335  ;
            71336 85257  ];
        colnum=5;
    end
    
    
   
  
    
    for iscen=1:length(Scenario)
        
        % calculate timelines to WHO 1% mf threshold
        for i=Scennum(iscen,j):Scennum(iscen,k)
            
            T = find((num(i,colnum:12:(50*12)+colnum-1))*100 < 1);
            
            if ~isempty(T)
                NumRounds(i,itype) = T(1);  
            else
                NumRounds(i,itype)=50;
               
            end  
            
        end
        
       
 %% Calculation of weighted variance
        Frequency=0;
        mean=0;
variance=0;
a=unique(NumRounds((Scennum(iscen,1):Scennum(iscen,2)),itype));
for i = 1:length(a)
        Frequency(i) = sum(NumRounds((Scennum(iscen,1):Scennum(iscen,2)),itype) == a(i));
end
for i=1:length(a)
    mean=mean+a(i)*Frequency(i);
end
Wmean(iscen,itype)=mean/sum(Frequency);
for i=1:length(a)
    variance=variance+Frequency(i)*(a(i)-Wmean(iscen,itype))^2;
end 
Wvariance(iscen,itype)=variance/(sum(Frequency)*((length(Frequency)-1)/length(Frequency)));

%% Calculation of entropy, variance, normalised entropy, 95% elimination timeline
x1(iscen,itype)=prctile(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype),2.5);
x2(iscen,itype)=prctile(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype),97.5);
entrp(iscen,itype) = Entropy(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));
vari(iscen,itype) = var(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));

maxyear(iscen,itype) = max(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));

minyear(iscen,itype) = min(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));
medianyear(iscen,itype) = median(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));
entrp_norm(iscen,itype) = Entropy_normalised(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));



x(1:Scennum(iscen,2)-Scennum(iscen,1)+1,iscen) = NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype);
    end
   
     
    
    
    %% F test for equal variance
    p1 = vartestn(x); % are all variances are equal?
    p2 = vartest2(x(:,1),x(:,2)); % are pairwise variances equal?
    p3 = vartest2(x(:,1),x(:,3));
    p4 = vartest2(x(:,1),x(:,4));
    p5 = vartest2(x(:,2),x(:,3));
    p6 = vartest2(x(:,2),x(:,4));
    p7 = vartest2(x(:,3),x(:,4));
save(sprintf('Data_%s_TRANSFIL.mat',type{itype}),...
        'Wvariance','Wmean','x1','x2','entrp','vari','maxyear','minyear','medianyear','entrp_norm','NumRounds','x','p1','p2','p3','p4','p5','p6','p7','NumRounds');
end
