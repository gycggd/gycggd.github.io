---
title: Hough Transform霍夫变换
date: 2017-09-27 08:03:08
tags:
    - Recognition System
---

# Hough-Line

``` matlab
function [H, theta, r] = myhough(BW)
    [h, w] = size(BW);

    theta_low = -pi/2;
    theta_high = pi/2;

    r_low = -sqrt(h^2+w^2);
    r_high = sqrt(h^2+w^2);

    num_theta = 180;
    num_r = round(r_high*2);
    H = zeros(num_theta, num_r);

    for x = 1:h
        for y = 1:w
            if BW(x, y)==1
                for i = 1:num_theta
                    theta = theta_low + (i-1)/num_theta*(theta_high-theta_low);
                    r = x*cos(theta) + y*sin(theta);
                    j = round(1 + (num_r-1) * (r-r_low)/(r_high-r_low));
                    H(i, j) = H(i, j) + 1;
                end
            end
        end
    end
    
    [m, I] = max(H(:));
    [i, j] = ind2sub(size(H), I);

    theta = theta_low + (i-1)/num_theta*(theta_high-theta_low);
    r = r_low + (j-1)/num_r*(r_high-r_low);
    
    while (abs(theta)<=pi/90 && (abs(r)<=2 || abs(abs(r)-h)<=2)) || (abs(pi/2-abs(theta))<=pi/90 && (abs(r)<=2 || abs(abs(r)-w)<=2)) 
        H(i, j) = 0;
        [m, I] = max(H(:));
        [i, j] = ind2sub(size(H), I);

        theta = theta_low + (i-1)/num_theta*(theta_high-theta_low);
        r = r_low + (j-1)/num_r*(r_high-r_low);
    end
end
```

# Hough-Circle

``` matlab
function [x, y, R] = myhoughcircle(BW, max_r, k, gap)

    [h, w] = size(BW);

    num_x = h;
    num_y = w;
    
    if nargin < 2 || isempty(max_r)
        max_r = min(h/2, w/2);
    end
    if nargin < 3
        k = 1;
    end
    if nargin < 4
        gap = 20;
    end
    
    H = zeros(num_x, num_y, max_r);

    for i = 1:h
        for j = 1:w 
            if BW(i, j)==1
                for a = 1:num_x
                    for b = 1:num_y
                        r = round(sqrt((a-i)^2+(b-j)^2));
                        if r>0 && r<=max_r
                            H(a, b, r) = H(a, b, r) + 1;
                        end
                    end
                end
            end
        end
    end
    
    
    img = cat(3, BW, BW, BW)*255;
    
    hh = H(:);
    
    prex = 0;
    prey = 0;
    preR = 0;
    
    idx = 1;
    
    while idx<=k
        
        [~, I] = max(hh);
        [x, y, R] = ind2sub(size(H), I);
        hh(I) = 0;
        
        if (x-prex)<=gap && (y-prey)<=gap && (R-preR)<=gap
           continue 
        end
                        
        for i = 1:h
            for j = 1:w
                computed_r = sqrt((i-x)^2+(j-y)^2);
                if abs(computed_r-R)<=1
                    img(i, j, :) = [255, 0, 0];
                end
            end
        end
        prex = x;
        prey = y;
        preR = R;
        idx = idx+1;
        
    end
        
end
```