function PMSE=mean_square_err(A,B,w)

PMSE=0;
for i=1:w
 for j=1:w 
     diff=A(i,j)-B(i,j);
     PMSE=PMSE+diff*diff*power(w*w+1-i-j,2);
 end
end
PMSE=PMSE/(w*w);
end
