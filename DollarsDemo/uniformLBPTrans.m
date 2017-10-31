function LBP_Im = uniformLBPTrans(Input_Im)
% tic,
if size(Input_Im, 3) == 3
    Input_Im = rgb2gray(Input_Im);
end
% LBP_Im= Input_Im;
% toc;
% tic,
mapping=getmapping(8,'u2');
LBP_Im=lbp(Input_Im,1,8,mapping,0);
LBP_Im=imresize(LBP_Im,size(Input_Im));%%resizeCJ
LBP_Im=single(LBP_Im);
% toc;