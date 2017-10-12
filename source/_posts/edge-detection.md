---
title: Edge-detection边缘检测
date: 2017-09-26 00:03:52
tags:
    - Recognition System
    - Edge Detection
---

不管是点，线，还是边缘的检测，无非是找到像素点变化的地方，人眼可以很明显的看到图案在哪发生了变化，而从一个图像的数字格式中无法直接找到强度变化明显的地方，但是可以通过对一个像素点以及其周围的像素点进行计算，然后得到一个可以用来衡量强度变化的结果。

![Detection types](/images/edge-detection/detection-types.png)

我们通过取一块区域的图像与一个设计好的`Laplacian mask`做点积运算得到一个值R，然后取R的绝对值与一个阈值T比较来判断是否把这个位置归为一个点、线或边缘。

![Working Principle](/images/edge-detection/principle.png)

这种`Laplacian mask`的操作可以用matlab里的`imfilter`来做，自己实现的`myimfilter`如下：

```matlab
function filtered_image=myimfilter(image,filter)

image = im2double(image);

[ih, iw] = size(image);
[fh, fw] = size(filter);

border = (fw-1)/2;

tmp_image = zeros(ih+2*border, iw+2*border);
tmp_image(1+border:ih+border, 1+border:iw+border) = image;
image = tmp_image;

tmp = zeros(ih+2*border, iw+2*border);

for i = (1+border):(ih+border)
    for j = (1+border):(iw+border)
        tmp(i, j) =sum(sum((image(i-border:i+border, j-border:j+border).*filter)));
    end
end

filtered_image = tmp(border+1:border+ih, border+1:border+iw);
end
```

# Point Detection & Line Detection

Point Detection用的mask如下：

![Point mask](/images/edge-detection/point-mask.png)

Line Detection用的mask如下：

![Line mask](/images/edge-detection/line-mask.png)

# Edge Detection

## Type of edges

如下图，有三种典型的边缘类型

![Edge type](/images/edge-detection/edge-type.png)

下面三张图分别是在边缘处的intensity的变化曲线：

![Edge type ramp](/images/edge-detection/ramp.png)
![Edge type step](/images/edge-detection/step.png)
![Edge type roof](/images/edge-detection/roof.png)

## Gradient Operator

Gradient用来衡量一个边缘变化的剧烈情况以及边缘的方向

![Gradient](/images/edge-detection/gradient.png)

![Gradient](/images/edge-detection/gradient2.png)

![Gradient](/images/edge-detection/gradient3.png)

Gradient Operators

![Operators](/images/edge-detection/operators.png)

![Operators](/images/edge-detection/operators2.png)

![Operators](/images/edge-detection/operators3.png)

Prewitt的一个实现如下

```matlab
function g = myprewittedge(Im,T,direction)
    g = zeros(size(Im));
    if strcmp(direction, 'horizontal') || strcmp(direction, 'all')
        w_horizontal = [-1 -1 -1; 0 0 0; 1 1 1];
        tmp = abs(myimfilter(Im, w_horizontal));
        g = g | (tmp>T);  
    end
    if strcmp(direction, 'vertical') || strcmp(direction, 'all') 
        w_vertical = [-1 0 1; -1 0 1; -1 0 1];
        tmp = abs(myimfilter(Im, w_vertical));
        g = g | (tmp>=T);  
    end
    if strcmp(direction, 'pos45') || strcmp(direction, 'all')
        w_pos45 = [0 1 1; -1 0 1; -1 -1 0];
        tmp = abs(myimfilter(Im, w_pos45));
        g = g | (tmp>=T);  
    end
    if strcmp(direction, 'neg45') || strcmp(direction, 'all')
        w_neg45 = [-1 -1 0; -1 0 1; 0 1 1];
        tmp = abs(myimfilter(Im, w_neg45));
        g = g | (tmp>=T);  
    end
end
```

运行如下图所示：

![Prewitt](/images/edge-detection/prewitt.png)

## Marr-Hildreth edge detector

### Laplacian of Gaussian

进行边缘检测前很重要的一步是去除噪音，对图像进行平滑处理，所以先进行高斯模糊再做Laplacian操作。

![Laplacian](/images/edge-detection/laplacian.png)

![Gaussian](/images/edge-detection/gaussian.png)

![LOG](/images/edge-detection/log.png)

![Mexican hat](/images/edge-detection/mexican-hat.png)

### Marr-Hildreth algorithm

![Marr-Hildreth](/images/edge-detection/marr-hildreth.png)
![Marr-Hildreth](/images/edge-detection/marr-hildreth2.png)