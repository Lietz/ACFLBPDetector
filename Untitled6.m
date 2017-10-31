I=imread('inria_sample.png');
I=rgb2gray(I);
mapping=getmapping(8,'u2'); 
J=lbp(I,1,8,mapping,no);
JJ=extractLBPFeatures(I);
