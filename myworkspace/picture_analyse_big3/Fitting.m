function linefin = Fitting(lines_final)
    p = polyfit(lines_final(:,1),lines_final(:,2),3);
    linefin = polyval(p,lines_final(:,1));
end