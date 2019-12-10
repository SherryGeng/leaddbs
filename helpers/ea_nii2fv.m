function fv=ea_nii2fv(nii,thresh)

if ~exist('thresh','var')
thresh=(mean(nii.img(nii.img~=0))/3);
end

options.prefs=ea_prefs;
nii.img(isnan(nii.img))=0;

[xx,yy,zz]=ind2sub(size(nii.img),find(nii.img>thresh)); %(mean(nii.img(nii.img~=0))/3))); % find 3D-points that have correct value.

if ~isempty(xx)
    XYZ=[xx,yy,zz]; % concatenate points to one matrix.
    XYZ=map_coords_proxy(XYZ,nii); % map to mm-space
end


bb=[0,0,0;size(nii.img)];

bb=map_coords_proxy(bb,nii);
gv=cell(3,1);
for dim=1:3
    gv{dim}=linspace(bb(1,dim),bb(2,dim),size(nii.img,dim));
end
[X,Y,Z]=meshgrid(gv{1},gv{2},gv{3});
if options.prefs.hullsmooth
    nii.img = smooth3(nii.img,'gaussian',options.prefs.hullsmooth);
end

fv=isosurface(X,Y,Z,permute(nii.img,[2,1,3]),max(nii.img(:))/2);
fvc=isocaps(X,Y,Z,permute(nii.img,[2,1,3]),max(nii.img(:))/2);
fv.faces=[fv.faces;fvc.faces+size(fv.vertices,1)];
fv.vertices=[fv.vertices;fvc.vertices];





function coords=map_coords_proxy(XYZ,V)

XYZ=[XYZ';ones(1,size(XYZ,1))];

coords=V.mat*XYZ;
coords=coords(1:3,:)';