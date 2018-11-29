function ea_pcanii_generic(fis,mask)
vizz=0;


N=length(fis);
imgs=cell(N,1);
% load data
for fi=1:length(fis)
    imgs{fi}=ea_load_nii(fis{fi});
end

if exist('mask','var')
    msk=ea_load_nii(mask);
    maskidx=find(msk.img(:)>0);
    fullidx=[1:length(imgs{1}.img(:))]';
else
    maskidx=[1:length(imgs{1}.img(:))]';
    fullidx=[1:length(imgs{1}.img(:))]';
end

allidx=zeros(numel(imgs{fi}.img),N);
idx=zeros(length(maskidx),N);
% feature scale data &
% generate joint pointlist
for fi=1:length(fis)
    allidx(:,fi)=zscore(imgs{fi}.img(fullidx));
    if fi>1 % need to retain first image for output.
        imgs{fi}=[]; % free ram
    end
    idx(:,fi)=allidx(maskidx,fi);
end

if vizz && N==3
    figure
    plot3(idx(1:1000:end,1),idx(1:1000:end,2),idx(1:1000:end,3),'.');
end

% train PCA only on brain part of the image:
[wcoeff,~,~,~,exp]=pca(idx);
% orthogonalize PC coeffs:
coefforth = inv(diag(std(idx)))*wcoeff;
% apply orthogonalized coefficients to full images:
cscores = zscore(allidx)*coefforth;
disp([num2str(exp(1)),' % of variance explained by first PC.']);


if vizz
    hold on
    for v=1:3
        plot3([0,V(1,v)],[0,V(2,v)],[0,V(3,v)],'r-');
    end
end


imgs{1}.img(:)=0;
imgs{1}.img(fullidx)=cscores(:,1);

imgs{1}.img=imgs{1}.img-min(imgs{1}.img(:));
imgs{1}.img=imgs{1}.img/max(imgs{1}.img(:));
imgs{1}.img=imgs{1}.img*(100); % 
[pth,fname,ext]=fileparts(imgs{1}.fname);
imgs{1}.fname=fullfile(pth,[fname,'_pca','.nii']);
ea_write_nii(imgs{1});
