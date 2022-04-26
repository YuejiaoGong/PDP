function Nimg = GetImagePyramid(img,levels,type)

Nimg(1).img = img;
 
switch type
    case 'disk'
        g = fspecial('disk',5);
    case 'gaussian'
        g = fspecial('gaussian',[5 5],0.5);
    case 'laplacian'
        g = fspecial('laplacian',0.2);
    case 'LoG'
        g = fspecial('log',[5 5],0.5);     
end

%pyramid
for i = 2 : levels
    %perform guassian filtering
    im = imfilter(Nimg(i-1).img,g,'conv');
    %perform downsampling (horizontal)
    im1 = im(:,1:2:size(Nimg(i-1).img,2),:);
    %vertical
    im2 = im1(1:2:size(Nimg(i-1).img,1),:,:);
    %store it in a struct format
    Nimg(i).img = im2;
end