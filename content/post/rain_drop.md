---
title: "LeetCode 42: Trapping Rain Water I & II"
date: 2018-03-14T19:41:00+08:00
tags:
    - Dynamic Programming
categories:
    - Leetcode
---

[42.Trapping Rain Water](https://leetcode.com/problems/trapping-rain-water/description/) and [407.Trapping Rain Water II](https://leetcode.com/problems/trapping-rain-water-ii/description/) are very interesting problems.

# Trapping Rain Water

![Description](/images/leetcode/42_1.png)

This problem is taged with "Two Pointers" and "Stack", they corresponds to two different solutions.

## Two Pointers Solution

Let hl=height[0] and rl=height[len(height)-1] be height of left border and height of right border, and left=1, right=len(height)-2.

This is a 1-D pool, so there are only two borders left and right, and space between them can trap min(hl, hr) water.

So suppose hl<hr,   

* If A[left]<=hl, position (left) can hold (hl-A[left]) water.
* If A[left]>hl, position (left) can't hold any water, just update hl=left[l].

Operations are symmetrical for the situation hl>hr. And choose either left or right when hl==hr.

When left>right, stop and return the sum of capacity at every position.

Here is the code:

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

## Stack solution

The stack solution maintains a stack whose elements are possible left local border for following positions. And the top of the stack is poped when its right local border comes. 

As the picture shows:

![pic](/images/leetcode/42_2.png)

Here is the code:

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

In the first problem, in 1-D space we only have two borders, but in 2-D space we need to build wall on four directions. So we can evolve from the two pointers to (2*m+2*n-4) pointers given a pool with size m*n. 

In the two pointers problem, we always choose the lowest one by just comparing hl and hr, but when we have more pointers, to pick a lowest one from them with new pointers coming in becomes more difficult. The first data structure that comes to mind should be a min-heap. We extends from outer to innner until we visited all cells, so to solve this problem, just use heap to get the node to expand.

Here is the code:

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
            h, i, j = heapq.heappop(heap)
            for (x, y) in [(i+1, j), (i-1, j), (i, j-1), (i, j+1)]:
                if 0<=x<m and 0<=y<n and (x, y) not in visited:
                    ret += 0 if grid[x][y]>=h else (h-grid[x][y])
                    heapq.heappush(heap, (max(grid[x][y], h), x, y))
                    visited.add((x, y))
        
        return ret
```
