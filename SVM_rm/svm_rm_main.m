%% variables
trainratio=.6;
cvratio=.2;
testratio=.2;
fieldstoexclude={'RS','si','class','IVtime','firstrecordingtimethatday'};
%% randomize
% order=randperm(length(DATASUM));
% DATASUM=DATASUM(order);
%% remove unnecessairy fields and normalize data

fieldnamek=fieldnames(DATASUM);
class=[DATASUM.class];
fname={DATASUM.fname};
ID={DATASUM.ID};
DATA=DATASUM;
normalize_params=struct;
for fieldi=1:length(fieldnamek)
    fieldname=fieldnamek{fieldi};
    if any(strcmp(fieldstoexclude,fieldname)) | ~isnumeric(DATA(1).(fieldname))
        DATA=rmfield(DATA,fieldname);
    elseif any(isnan([DATA.(fieldname)]))
        DATA=rmfield(DATA,fieldname);
    else
        [Z,mu,sigma] = zscore([DATA.(fieldname)]);
        Z=num2cell(Z);
        [DATA.(fieldname)]=Z{:};
        normalize_params.(fieldname).mu=mu;
        normalize_params.(fieldname).sigma=sigma;
    end
end
%% dividing training CV and test sets
features=fieldnames(DATA);
TRAINING_set=[];
TRAINING_class=[];
CV_set=[];
CV_class=[];
TEST_set=[];
TEST_class=[];
classes=sort(unique(class));
for classi=1:length(classes)
    classnow=classes(classi);
    train_n=ceil(sum(class==classnow)*trainratio);
    cv_n=ceil(sum(class==classnow)*cvratio);
    test_n=sum(class==classnow)-train_n-cv_n;
    classidxes=find(class==classnow);
    TRAINING_set=[TRAINING_set,DATA(classidxes(1:train_n))];
    TRAINING_class=[TRAINING_class;class(classidxes(1:train_n))'];
    CV_set=[CV_set,DATA(classidxes([1:cv_n]+train_n))];
    CV_class=[CV_class;class(classidxes([1:cv_n]+train_n))'];
    TEST_set=[TEST_set,DATA(classidxes([1:test_n]+train_n+cv_n))];
    TEST_class=[TEST_class;class(classidxes([1:test_n]+train_n+cv_n))'];
end
TRAINING_values=zeros(length(TRAINING_class),length(features));
CV_values=zeros(length(CV_class),length(features));
TEST_values=zeros(length(TEST_class),length(features));
for featurei=1:length(features)
    feature=features{featurei};
    TRAINING_values(:,featurei)=[TRAINING_set.(feature)];
    CV_values(:,featurei)=[CV_set.(feature)];
    TEST_values(:,featurei)=[TEST_set.(feature)];
end
%% parameter selection
errordata=struct;
predictiondata=struct;
for classi=1:length(classes)
    class_now=classes(classi);
    kitevok=[-2:2];
    alapok=[1,5];
    cvals=[];
    sigmavals=[];
    for i = 1:length(alapok)
        cvals=[cvals,power(10,kitevok)*alapok(i)];
        sigmavals=[sigmavals,power(10,kitevok)*alapok(i)];
    end
    cvals=sort(cvals);
    sigmavals=sort(sigmavals);
    errors=zeros(length(cvals),length(sigmavals));
    predictions=cell(length(cvals),length(sigmavals));
    progressnow=0;
    progressend=length(errors(:));
    for ci=1:length(cvals)
        for sigmai=1:length(sigmavals)
            C=cvals(ci);
            sigma=sigmavals(sigmai);
            model = svmTrain(TRAINING_values, double(TRAINING_class==class_now), C, @linearKernel, 1e-3, 20);
            pred = svmPredict(model, CV_values);
            errors(ci,sigmai)=mean(double(pred~=double(CV_class==class_now)));
            predictios{ci,sigmai}=pred;
            progressnow=progressnow+1;
            waitbar(progressnow/progressend);
        end
    end
    errordata(classi).errors=errors;
    errordata(classi).class=class_now;
    errordata(classi).cvals=cvals;
    errordata(classi).sigmavals=sigmavals;
end
%%
for classi=1:length(classes)
    [minerror,idx]=min(errordata(classi).errors(:))
end