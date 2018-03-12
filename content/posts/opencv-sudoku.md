---
title: 用OpenCV来做数独
date: 2017-10-17 00:27:22
tags:
    - Recognition
    - OpenCV
---

今天看OpenCV的时候花了几个小时写了一个小程序根据一个数独的初始图片自动完成数独，如下是一张数独的图片。

![](/images/opencv-sudoku/sudoku.png)

下面所有的代码可以在我的Github上找到: [Sudoku](https://github.com/gycggd/sudoku)

这里使用了OpenCV，pillow，numpy这几个库：

``` py
import numpy as np
import cv2
import os
import shutil
from PIL import Image
```

# Preprocessing

``` py
if board_origin.ndim == 3:
    board_origin = cv2.cvtColor(board_origin, cv2.COLOR_BGR2RGB)
    board_gray = cv2.cvtColor(board_origin, cv2.COLOR_RGB2GRAY)
else:
    board_gray = board_origin

board_gray = cv2.GaussianBlur(board_gray, (5, 5), 0)
board_thresh = cv2.adaptiveThreshold(board_gray, 255, 1, 1, 5, 2)
cv2.imshow('board_thresh', board_thresh)
```

1. 如果不是灰度图像，转成灰度图像
2. 做高斯模糊，去除Noise
3. 二值化，转成黑白图像

效果如图：
![](/images/opencv-sudoku/pped.png)


# Extract Prefilled Numbers

``` py
_, contours, hierarchy = cv2.findContours(board_thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

max_contour = contours[0]
max_rect = cv2.boundingRect(contours[0])
max_idx = 0

for idx, contour in enumerate(contours):
    [x, y, w, h] = cv2.boundingRect(contour)
    if w * h > max_rect[2] * max_rect[3]:
        max_contour = contour
        max_rect = [x, y, w, h]
        max_idx = idx

cv2.drawContours(board_origin, [max_contour], 0, (0, 255, 0), 3)

number_contours = []
candidates = []
for i in range(len(hierarchy[0])):
    if hierarchy[0][i][3] == max_idx:
        candidates.append(i)

while len(candidates) > 0:
    c = candidates[0]
    candidates.pop(0)
    rect = cv2.boundingRect(contours[c])

    if rect[2] > max_rect[2] / 10 or rect[3] > max_rect[3] / 10:
        for j in range(len(hierarchy[0])):
            if hierarchy[0][j][3] == c:
                candidates.append(j)
    elif (rect[3] > max_rect[2] / 20 or rect[3] > max_rect[3] / 18) and \
            (rect[3] < max_rect[2] / 9 or rect[3] < max_rect[3] / 9):
        cv2.drawContours(board_origin, contours, c, (0, 0, 255), 3)
        number_contours.append(contours[c])

print '# of grid already filled: ' + str(len(number_contours))
```

1. Get contour tree
1. Find the biggest contour
1. Find num contours using breadth-first search of the tree

效果如图：
![](/images/opencv-sudoku/extracted_contours.png)

# Identify numbers using k-NN

1. Get training sets from Mac Fontbook (Screenshot the numbers in the fonts)
![](/images/opencv-sudoku/train_sets.png)
1. Preprocess the images
``` py
for f in os.listdir(path_all_numbers):
    img_pil = Image.open(os.path.join(path_all_numbers, f))
    img_origin = np.array(img_pil)
    img = img_origin.copy()
    if img.ndim == 3:
        img_gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    else:
        img_gray = img

    img_blur = cv2.GaussianBlur(img_gray, (5, 5), 0)
    img_thresh = cv2.adaptiveThreshold(img_blur, 255, 1, 1, 11, 2)

    image, contours, _ = cv2.findContours(img_thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cv2.drawContours(img, contours, -1, (0, 0, 255), 3)

    height, width = img.shape[:2]

    list = []
    for cnt in contours:
        [x, y, w, h] = cv2.boundingRect(cnt)

        if h > (height / 4):
            list.append([x, y, w, h])
            cv2.rectangle(img, (x, y), (x + w, y + h), (0, 0, 255), 2)

    cv2.imwrite(os.path.join(path_contour, 'contour_' + f), img)

    list_sorted = sorted(list, cmp=lambda p1, p2: p1[1] - p2[1] if abs(p1[1] - p2[1]) > height / 4 else p1[0] - p2[0])
    list_sorted = list_sorted[-1:] + list_sorted[:-1]

    for idx, (x, y, w, h) in enumerate(list_sorted):
        cv2.imwrite(os.path.join(path_number, str(idx) + '_' + f.split('.')[0] + '.jpg'),
                    img_origin[y:y + h, x:x + w])
        # cv2.imshow(f.split('.')[0] + '_' + str(idx), img[y:y + h, x:x + w])
```
1. Train the model using OpenCV
``` py
images = []
labels = []

for f in os.listdir(path_number):
    img_pil = Image.open(os.path.join(path_number, f))
    img = np.array(img_pil)
    if img.ndim == 3:
        img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    img = cv2.resize(img, (20, 40))
    img = cv2.adaptiveThreshold(img, 255, 1, 1, 11, 2)
    cv2.imwrite(os.path.join(path_resized_number, f), img)
    normalized_img = img / 255
    images.append(normalized_img.flatten())
    labels.append(int(f[0]))

images = np.array(images, np.float32)
labels = np.array(labels, np.float32)

model = cv2.ml.KNearest_create()
model.train(images, cv2.ml.ROW_SAMPLE, labels)
```
1. Get the number using the model
``` py
_, results, neigh_resp, dists = model.findNearest(sample1, 1)
number = int(results.ravel()[0])
```

Now we can mark the result on the picture so that we can check with our eyes:

![](/images/opencv-sudoku/numbers_marked.png)

# Solve Sudoku

Here I find a solution online (from [here](http://norvig.com/sudoku.html)), it works well but fails in some cases.

The code is [https://github.com/gycggd/sudoku/blob/master/sudoku_algorithm.py](https://github.com/gycggd/sudoku/blob/master/sudoku_algorithm.py)

# Fill in the pic with our solution

``` py
for i in range(9):
    for j in range(9):
        if (j, i) in prefilled:
            continue
        x = int((i + 0.25) * box_w)
        y = int((j + 0.75) * box_h)
        cv2.putText(board_origin, str(sudoku[j][i]), (max_rect[0] + x, max_rect[1] + y), 3, 2, (0, 0, 0), 2,
                    cv2.LINE_AA)
```

![](/images/opencv-sudoku/solution.png)

EOF