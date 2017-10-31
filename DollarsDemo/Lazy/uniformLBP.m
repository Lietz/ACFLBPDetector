function getlbpimg = uniformLBP(oriimg, table)  
    rows=size(oriimg,1);
    cols=size(oriimg,2);
    for y=2:rows-1
        for x=2:cols-1
       %     uchar neighbor[8] = {0};  
            neighbor=zeros(1,8);
            neighbor=int8(neighbor);
            neighbor(1) = oriimg(y-1, x-1);  
            neighbor(2) = oriimg(y-1, x);  
            neighbor(3) = oriimg(y-1, x+1);  
            neighbor(4) = oriimg(y, x+1);  
            neighbor(5) = oriimg(y+1, x+1);  
            neighbor(6) = oriimg(y+1, x);  
            neighbor(7) = oriimg(y+1, x-1);  
            neighbor(8) = oriimg(y, x-1);  
            center = oriimg(y, x);  
            temp = int8(0);  
            for k = 1:8 
                %C = BITSHIFT(A,K)
                temp =temp+(BITSHIFT((neighbor(k) >= center),k)); % // 计算LBP的值  
            end 
            result(y,x) = table(temp);  % //  降为59维空间  
        end  
    end  
    getlbpimg=result;
end  