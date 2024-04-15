function err = nse(y,exp)
    if exp ~=0
        err = ((y-exp)^2)/(exp^2);
    else
        err = (y-exp)^2;
    end
end