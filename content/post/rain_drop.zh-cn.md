---
title: "LeetCode 42: Trapping Rain Water I & II"
date: 2018-03-14T19:41:00+08:00
tags:
    - Dynamic Programming
categories:
    - Leetcode
---

本篇包括[42.Trapping Rain Water](https://leetcode.com/problems/trapping-rain-water/description/) and [407.Trapping Rain Water II](https://leetcode.com/problems/trapping-rain-water-ii/description/).

# Trapping Rain Water

![Description](/images/leetcode/42_1.png)

This problem is taged with "Two Pointers" and "Stack", they corresponds to two different solutions.

这道题目带有“双指针”和“栈”这两个标签，对应这道题的两种解法。

## 双指针解法

初始化 hl=height[0] and rl=height[len(height)-1] 为左边界和右边界的高度，left=1, right=len(height)-2 为左右两边的指针。

因为这个池子是1维的，所以它“漏水”只有从左右两边出去，所以只要记录左右两边的边界高度，中间每一格就可以存储 min(hl, hr) 高度的水。

假设 hl<hr,   

* If A[left]<=hl, left 处可以存储 (hl-A[left]) 的水.
* If A[left]>hl, left 处无法存水, just update hl=left[l].

hl>hr 的情况是对称的，另外，当hl==hr的时候，任意挑选左边或者右边往内逼近。

当left和right指针相遇后并且left>right时，退出循环，返回所有位置存储水的总量。

代码如下：

```
class Solution:
    def trap(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        if not height:
            return 0
        l, r = 0, len(height)-1
        hl, hr = height[l], height[r]
        l, r = l+1, r-1
        total = 0
        while l<=r:
            if hl<=hr:
                if height[l]<=hl:
                    total += (hl-height[l])
                else:
                    hl = height[l]
                l += 1
            else:
                if height[r]<=hr:
                    total += (hr-height[r])
                else:
                    hr = height[r]
                r -= 1
        return total
```

## 栈解法

使用栈的解法维护一个这样的栈，把heights数组中的元素依次入栈，并且保证栈里的每一个元素都可能是右边的元素的左边界。当遇到一个元素比栈顶的大时，当前元素与栈顶下面的一个元素构成了一个长度、边界可以计算出来的的局部储水池。栈顶出栈，重复构成局部储水池，直到当前元素小于栈顶元素。局部储水池之和即是储水量。

如下图所示：

![pic](/images/leetcode/42_2.png)

代码如下:

```
class Solution:
    def trap(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        if not height:
            return 0
        st = []
        total = 0
        for i in range(len(height)):
            if not st or height[i]<height[st[-1]]:
                st.append(i)
            else:
                while st and height[st[-1]]<height[i]:
                    idx = st.pop(-1)
                    if st:
                        total += (min(height[st[-1]], height[i])-height[idx])*(i-st[-1]-1)
                st.append(i)
        return total
```


# Trapping Rain Water II

![Description](/images/leetcode/407_1.png)

上一个问题中我们说过，1维的水池只有左右两个边界，而一个二维的水池则有四面八方，所以第一个问题中我们是2个指针往内逼近，在这个问题中我们最开始有(2m+2n-4)个指针（池子尺寸为`m*n`），并且在往内计算的过程中，数量还会发生变化。

双指针问题中我们只需要比较两个边界的大小就可以判断从哪一侧往内延伸，现在我们有更多的方向，每次想从最小的边界往内延伸，并且每次还会加入新的边界，所以很显然可以用一个最小堆来维持顺序。

代码如下：

```
class Solution:
    def trapRainWater(self, grid):
        """
        :type heightMap: List[List[int]]
        :rtype: int
        """
        if not grid or not grid[0]:
            return 0
        
        m, n = len(grid), len(grid[0])
        
        heap = []
        
        visited = set()
        # 初始化，将所有边界加入堆中
        for i in range(m):
            heapq.heappush(heap, (grid[i][0], i, 0))
            heapq.heappush(heap, (grid[i][n-1], i, n-1))
            visited.add((i, 0))
            visited.add((i, n-1))
        for i in range(n):
            heapq.heappush(heap, (grid[0][i], 0, i))
            heapq.heappush(heap, (grid[m-1][i], m-1, i))
            visited.add((0, i))
            visited.add((m-1, i))
            
        ret = 0
        while heap:
            # 每次取最低点向内延伸
            h, i, j = heapq.heappop(heap)
            for (x, y) in [(i+1, j), (i-1, j), (i, j-1), (i, j+1)]:
                if 0<=x<m and 0<=y<n and (x, y) not in visited:
                    # 如果内部点更高，则无法存水，如果内部点低，可以存差值的水
                    ret += 0 if grid[x][y]>=h else (h-grid[x][y])
                    # 如果内部点更高，边界更新为内部点高度，如果内部点低，用水填满到外部点高度
                    # 因为外部点是最低边界，所以填满池子这里肯定可以填到外部点高度
                    heapq.heappush(heap, (max(grid[x][y], h), x, y))
                    visited.add((x, y))
        
        return ret
```
