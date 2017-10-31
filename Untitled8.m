
tic
for i=1:100
    I=rgbConvert(imread('inria_sample.png'),'gray'); 
    %I=imread('inria_sample.png');
    out=uniformLBPTrans(I);
    disp(i);
end
toc;
%imshow(out);