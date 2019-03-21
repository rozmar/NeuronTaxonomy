function taxonomy_pca_differences_between_groups(DATASUM)
%% variables
csoport1=7;
csoport2=8;
signvalbetweengroups=.01; % significance level when comparing groups

mergecorrelatingvals=0; % use only one from the correlating variables
corrpval=.0000001; % threshold for correlation (p)

count=10; %the number of variables included in the PCA

%% csoport hisztogramok
close all
fieldek=fieldnames(DATASUM);
fieldek(find(strcmp(fieldek,'fname')))=[];
fieldek(find(strcmp(fieldek,'iv')))=[];
csoporok=unique([DATASUM.class]);
princompmatrix=[];
princompps=[];
princompnames=[];
for fieldnum=1:length(fieldek)
    if ~ischar([DATASUM.(fieldek{fieldnum})]) & ~strcmp(fieldek{fieldnum},'class')
%         figure(1)
%         clf
        clear datanow
        for i=1:length(csoporok)
            alldata=[DATASUM.(fieldek{fieldnum})];
%             range=[min(alldata):(max(alldata)-min(alldata))/20:max(alldata)];
%             subplot(length(csoporok)+1,1,1)
%             hist(alldata,range)
%             title(fieldek{fieldnum})
            
            neededcells=[DATASUM.class]==csoporok(i);
            toplot=[DATASUM(neededcells).(fieldek{fieldnum})];
%             subplot(length(csoporok)+1,1,i+1)
%             hist(toplot,range)
%             title(csoporok(i))
            datanow(i).data=toplot;
        end
%         figure(2)
%         clf
%         plot([DATASUM.class],alldata,'ko')
%         xlim([0 5])
        if sum(~isnan(datanow(csoport1).data)) >4 && sum(~isnan(datanow(csoport2).data)) >4
            [p,h]=ranksum(datanow(csoport1).data,datanow(csoport2).data,signvalbetweengroups);
        else
%             disp(fieldnum)
            p=1;
            h=0;
        end
        if h==1
%             disp(p)
            if ~any(isnan([DATASUM.(fieldek{fieldnum})]))
                princompmatrix(:,size(princompmatrix,2)+1)=[DATASUM.(fieldek{fieldnum})]';
                princompps(length(princompps)+1)=p;
                princompnames{length(princompnames)+1}=fieldek{fieldnum};
            end
            %         pause
        end
    end
end
%% principal component analysis
[princomppsnew,IX]=sort(princompps);
princompmatrixnew=princompmatrix(:,IX);
princompnamesnew=princompnames(IX);
if mergecorrelatingvals==1
    i=1;
    princompmatrixnewnew=[];
    princompnamesnewnew=[];
    while length(princompnamesnew)>1 %for i=1:size(princompmatrixnew,2)
        tomerge=zeros(1,size(princompmatrixnew,2));
        for j=1:size(princompmatrixnew,2)
            [R,p]=corrcoef(princompmatrixnew(:,i),princompmatrixnew(:,j));
            if p(2)<corrpval %abs(R(2))>maxcorrval
                tomerge(j)=1;
            end
        end
        mergeidx=find(tomerge);
        newname=[];
        for namei=1:length(mergeidx)
            newname=[newname,'-',princompnamesnew{mergeidx(namei)}];
        end
        princompnamesnewnew=[princompnamesnewnew,{newname}];
        princompnamesnew(mergeidx)=[];
        princompmatrixnewnew=[princompmatrixnewnew,princompmatrixnew(:,mergeidx(1))];
        princompmatrixnew(:,mergeidx)=[];
    end
    if length(princompnamesnew)==1
        mergeidx=1;
        princompnamesnewnew=[princompnamesnewnew,{[princompnamesnew{mergeidx}]}];
        princompnamesnew(mergeidx)=[];
        princompmatrixnewnew=[princompmatrixnewnew,princompmatrixnew(:,mergeidx(1))];
        princompmatrixnew(:,mergeidx)=[];
    end    
    princompmatrixnew=princompmatrixnewnew;
    princompnamesnew=princompnamesnewnew;
end
princomppsnew=princomppsnew(1:min(count,length(princompnamesnew)));
princompmatrixnew=princompmatrixnew(:,1:min(count,length(princompnamesnew)));
princompnamesnew=princompnamesnew(1:min(count,length(princompnamesnew)));
% close all
figure(1)
clf
subplot(2,2,3);
hold on
[COEFF,SCORE,latent,tsquare] = princomp(zscore(princompmatrixnew));
medians=[median(SCORE([DATASUM.class]==csoport1,1)),median(SCORE([DATASUM.class]==csoport1,2)),median(SCORE([DATASUM.class]==csoport1,3));median(SCORE([DATASUM.class]==csoport2,1)),median(SCORE([DATASUM.class]==csoport2,2)),median(SCORE([DATASUM.class]==csoport2,3))];

plot3(SCORE([DATASUM.class]==csoport1,1),SCORE([DATASUM.class]==csoport1,2),SCORE([DATASUM.class]==csoport1,3),'ro','MarkerFaceColor',[1 0 0]);
plot3(SCORE([DATASUM.class]==csoport2,1),SCORE([DATASUM.class]==csoport2,2),SCORE([DATASUM.class]==csoport2,3),'bo','MarkerFaceColor',[0 0 1]);
plot3(SCORE([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,1),SCORE([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,2),SCORE([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,3),'ko','MarkerFaceColor',[1 1 1]);

xlabel('1st principal component')
ylabel('2nd principal component')
zlabel('3rd principal component')
plot3(medians(1,1),medians(1,2),medians(1,3),'rx','MarkerSize',16,'LineWidth',3)
plot3(medians(2,1),medians(2,2),medians(2,3),'bx','MarkerSize',16,'LineWidth',3)
plot3(medians(:,1),medians(:,2),medians(:,3),'ko-','MarkerSize',16,'LineWidth',3)
xlim([-6 6])
ylim([-6 6])
subplot(2,2,1)
hold on
[nall,xout]=hist(SCORE([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,1),[-6:.5:6]);
[n11,~]=hist(SCORE([DATASUM.class]==csoport1,1),xout);
[n21,~]=hist(SCORE([DATASUM.class]==csoport2,1),xout);
bar1=bar(xout,[nall;n21;n11]','grouped');%,'k','b','r','FaceColor',[1 1 1]
set(bar1(1),'FaceColor',[1 1 1]) ;
set(bar1(2),'FaceColor',[0 0 1]) ;
set(bar1(3),'FaceColor',[1 0 0]) ;
set(bar1,'barwidth',1) ;
% bar(xout,n21,'b','FaceColor',[0 0 1])
% bar(xout,n11,'r','FaceColor',[1 0 0])
xlim([-6 6])

subplot(2,2,4)
hold on
[nall,xout]=hist(SCORE([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,1),[-6:.5:6]);
[n11,~]=hist(SCORE([DATASUM.class]==csoport1,2),xout);
[n21,~]=hist(SCORE([DATASUM.class]==csoport2,2),xout);
bar1=barh(xout,[nall;n21;n11]','grouped');%,'k','FaceColor',[1 1 1])
set(bar1(1),'FaceColor',[1 1 1]) ;
set(bar1(2),'FaceColor',[0 0 1]) ;
set(bar1(3),'FaceColor',[1 0 0]) ;
set(bar1,'barwidth',1) ;
% barh(xout,n21,'b','FaceColor',[0 0 1])
% barh(xout,n11,'r','FaceColor',[1 0 0])
ylim([-6 6])


figure(2)
clf
hold on
plot3(princompmatrixnew([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,1),princompmatrixnew([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,2),princompmatrixnew([DATASUM.class]~=csoport1 & [DATASUM.class]~=csoport2,3),'ko','MarkerFaceColor',[1 1 1]);
plot3(princompmatrixnew([DATASUM.class]==csoport1,1),princompmatrixnew([DATASUM.class]==csoport1,2),princompmatrixnew([DATASUM.class]==csoport1,3),'ro','MarkerFaceColor',[1 0 0]);
plot3(princompmatrixnew([DATASUM.class]==csoport2,1),princompmatrixnew([DATASUM.class]==csoport2,2),princompmatrixnew([DATASUM.class]==csoport2,3),'bo','MarkerFaceColor',[0 0 1]);
xlabel(princompnamesnew{1})
ylabel(princompnamesnew{2})
zlabel(princompnamesnew{3})
