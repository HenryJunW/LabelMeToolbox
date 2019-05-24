clear all

% use a function that is not in the same folder as your current folder?
addpath(genpath('/vulcan/scratch/junwang/core3D/LabelMeToolbox'))

HOMEIMAGES = '/vulcan/scratch/junwang/core3D/Images';

HOMEANNOTATIONS = '/vulcan/scratch/junwang/core3D/Annotations';

filename = fullfile(HOMEANNOTATIONS, '/users/HenryWong/core3d', 'jax_004_006_rgb.xml');
[annotation, img] = LMread(filename, HOMEIMAGES);

database = LMdatabase(HOMEANNOTATIONS);

[D,j] = LMquery(database, 'object.name', 'building');

% LMquery(D(1), 'object.attributes', 'shadow-free')



% for each image
for i = 1:length(D)

	mask = zeros(1024);

    % folderlist{i} = D(i).annotation.folder;
    filelist = D(i).annotation.filename;
    [E,k] = LMquery(D(i), 'object.attributes', 'shadow-free'); 
	% counts = LMcountobject(database(j)); 
	for m = 1:length(E)
		[mask1, class] = LMobjectmask(E(m).annotation, HOMEIMAGES);

		mask = mask + sum(mask1, 3);
		% size_ = size(mask1, 3);
		% for t = 1:size_;
		% 	mask = mask + mask1(:,:,t);
	end

    [E,k] = LMquery(D(i), 'object.attributes', 'self-shadow'); 
	% counts = LMcountobject(database(j)); 
	for m = 1:length(E)
		[mask2, class] = LMobjectmask(E(m).annotation, HOMEIMAGES, objectlist);

		mask = mask + 2*sum(mask2, 3);

		% size_ = size(mask2, 3);
		% for t = 1:size_;
		% 	mask = mask + 2*mask2(:,:,t);
	end

    [E,k] = LMquery(D(i), 'object.attributes', 'cast-shadow'); 
	% counts = LMcountobject(database(j)); 
	for m = 1:length(E)
		[mask3, class] = LMobjectmask(E(m).annotation, HOMEIMAGES, objectlist);

		mask = mask + 3*sum(mask3, 3);
	end
		% size_ = size(mask3, 3);
		% for t = 1:size_;
		% 	mask = mask + 3*mask3(:,:,t);
% image export the mask to be 
	[path, name,ext] = fileparts(filelist)

	imwrite(uint8(mask), strcat('/vulcan/scratch/junwang/core3D/segmentation_masks/', name));

end